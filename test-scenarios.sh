#!/bin/bash

# ============================================================================
# Script de Test — Evaluation Candidat
# ============================================================================
#
# Usage : ./test-scenarios.sh [BASE_URL]
# Exemple : ./test-scenarios.sh http://localhost:8080
#
# ============================================================================

BASE_URL="${1:-http://localhost:8080}"
PASSED=0
FAILED=0
TOTAL=0

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo ""
echo "============================================================================"
echo "TEST DE NON-REGRESSION — Evaluation Candidat"
echo "============================================================================"
echo "URL de base : $BASE_URL"
echo ""

# ----------------------------------------------------------------------------
# Fonctions utilitaires
# ----------------------------------------------------------------------------
test_scenario() {
    local name="$1"
    local expected="$2"
    local actual="$3"

    TOTAL=$((TOTAL + 1))

    if [[ "$actual" == *"$expected"* ]]; then
        echo -e "${GREEN}PASS${NC} — $name"
        PASSED=$((PASSED + 1))
        return 0
    else
        echo -e "${RED}FAIL${NC} — $name"
        echo -e "   ${YELLOW}Attendu contient :${NC} $expected"
        echo -e "   ${YELLOW}Recu :${NC} $actual"
        FAILED=$((FAILED + 1))
        return 1
    fi
}

test_status_code() {
    local name="$1"
    local expected_code="$2"
    local actual_code="$3"

    TOTAL=$((TOTAL + 1))

    if [[ "$actual_code" == "$expected_code" ]]; then
        echo -e "${GREEN}PASS${NC} — $name (HTTP $actual_code)"
        PASSED=$((PASSED + 1))
        return 0
    else
        echo -e "${RED}FAIL${NC} — $name"
        echo -e "   ${YELLOW}Attendu :${NC} HTTP $expected_code"
        echo -e "   ${YELLOW}Recu :${NC} HTTP $actual_code"
        FAILED=$((FAILED + 1))
        return 1
    fi
}

# ============================================================================
echo "SCENARIO 1 : Commande Standard acceptee"
echo "----------------------------------------------------------------------------"

HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$BASE_URL/api/ord" \
    -H "Content-Type: application/json" \
    -d '{"type":"std","email":"client1@test.com","amount":500}')

test_status_code "POST commande standard" "200" "$HTTP_CODE"

# ============================================================================
echo ""
echo "SCENARIO 2 : Commande Premium avec flag premium:true"
echo "----------------------------------------------------------------------------"

RESPONSE=$(curl -s -X POST "$BASE_URL/api/ord" \
    -H "Content-Type: application/json" \
    -d '{"type":"prm","email":"premium@test.com","amount":800}')

test_scenario "Flag premium present" '"premium":true' "$RESPONSE"

# ============================================================================
echo ""
echo "SCENARIO 3 : Commande Premium - double discount applique"
echo "----------------------------------------------------------------------------"
# 1000 avec double discount 10% -> 1000 * 0.9 * 0.9 = 810

RESPONSE=$(curl -s -X POST "$BASE_URL/api/ord" \
    -H "Content-Type: application/json" \
    -d '{"type":"prm","email":"premium2@test.com","amount":1000}')

test_scenario "Montant apres double discount (810)" '"amount":810' "$RESPONSE"

# ============================================================================
echo ""
echo "SCENARIO 4 : Commande Express acceptee"
echo "----------------------------------------------------------------------------"

HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$BASE_URL/api/ord" \
    -H "Content-Type: application/json" \
    -d '{"type":"exp","email":"express@test.com","amount":200}')

test_status_code "POST commande express" "200" "$HTTP_CODE"

# ============================================================================
echo ""
echo "SCENARIO 5 : Email vide ne bloque PAS la commande"
echo "----------------------------------------------------------------------------"

HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$BASE_URL/api/ord" \
    -H "Content-Type: application/json" \
    -d '{"type":"std","email":"","amount":100}')

test_status_code "Commande sans email acceptee" "200" "$HTTP_CODE"

# ============================================================================
echo ""
echo "SCENARIO 6 : GET commande existante"
echo "----------------------------------------------------------------------------"

# Creer une commande et recuperer son ID
RESPONSE=$(curl -s -X POST "$BASE_URL/api/ord" \
    -H "Content-Type: application/json" \
    -d '{"type":"std","email":"get-test@test.com","amount":100}')

ORDER_ID=$(echo $RESPONSE | grep -o '"id":"[^"]*"' | cut -d'"' -f4)

if [[ -n "$ORDER_ID" ]]; then
    HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$BASE_URL/api/ord/$ORDER_ID")
    test_status_code "GET commande existante" "200" "$HTTP_CODE"
else
    echo -e "${YELLOW}SKIP${NC} — Impossible de recuperer l'ID de la commande"
fi

# ============================================================================
echo ""
echo "SCENARIO 7 : GET commande inexistante -> 404"
echo "----------------------------------------------------------------------------"

HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$BASE_URL/api/ord/inexistant-xyz-123")

test_status_code "GET inexistant retourne 404" "404" "$HTTP_CODE"

# ============================================================================
echo ""
echo "SCENARIO 8 : Soft Delete -> GET retourne 404 apres DELETE"
echo "----------------------------------------------------------------------------"

# Creer une commande
RESPONSE=$(curl -s -X POST "$BASE_URL/api/ord" \
    -H "Content-Type: application/json" \
    -d '{"type":"std","email":"delete-test@test.com","amount":50}')

ORDER_ID=$(echo $RESPONSE | grep -o '"id":"[^"]*"' | cut -d'"' -f4)

if [[ -n "$ORDER_ID" ]]; then
    # Supprimer
    curl -s -X DELETE "$BASE_URL/api/ord/$ORDER_ID" > /dev/null

    # Verifier que GET retourne 404
    HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$BASE_URL/api/ord/$ORDER_ID")
    test_status_code "GET apres DELETE retourne 404" "404" "$HTTP_CODE"
else
    echo -e "${YELLOW}SKIP${NC} — Impossible de recuperer l'ID de la commande"
fi

# ============================================================================
echo ""
echo "SCENARIO 9 : Endpoint Stats (nouvelle feature)"
echo "----------------------------------------------------------------------------"

HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$BASE_URL/api/ord/stats")

if [[ "$HTTP_CODE" == "200" ]]; then
    RESPONSE=$(curl -s "$BASE_URL/api/ord/stats")
    test_status_code "Endpoint stats existe" "200" "$HTTP_CODE"
    test_scenario "Stats contient totalOrders" "totalOrders" "$RESPONSE"
    test_scenario "Stats contient ordersByType" "ordersByType" "$RESPONSE"

    # Verifier que les commandes supprimees sont exclues
    # 7 commandes creees (scenarios 1-6 + 8), 1 supprimee (scenario 8) -> totalOrders = 6
    test_scenario "Stats exclut les commandes supprimees (totalOrders=6)" '"totalOrders":6' "$RESPONSE"
else
    TOTAL=$((TOTAL + 1))
    FAILED=$((FAILED + 1))
    echo -e "${RED}FAIL${NC} — Endpoint stats n'existe pas (HTTP $HTTP_CODE)"
    echo -e "   ${YELLOW}Le candidat n'a pas implemente la feature${NC}"
fi

# ============================================================================
echo ""
echo "============================================================================"
echo "RESULTATS"
echo "============================================================================"
echo ""
echo -e "Tests passes  : ${GREEN}$PASSED${NC} / $TOTAL"
echo -e "Tests echoues : ${RED}$FAILED${NC} / $TOTAL"
echo ""

SCORE=$((PASSED * 100 / TOTAL))
echo -e "Score : ${YELLOW}$SCORE%${NC}"
echo ""

if [[ $FAILED -eq 0 ]]; then
    echo -e "${GREEN}TOUS LES TESTS PASSENT${NC}"
    exit 0
elif [[ $FAILED -le 2 ]]; then
    echo -e "${YELLOW}Quelques regressions mineures${NC}"
    exit 1
else
    echo -e "${RED}REGRESSIONS CRITIQUES DETECTEES${NC}"
    exit 1
fi
