#!/bin/bash

# ============================================================================
# Script de Test — Evaluation Candidat
# ============================================================================
#
# Usage : ./test-scenarios.sh [OPTIONS] [BASE_URL]
# Exemple : ./test-scenarios.sh http://localhost:8080
#           ./test-scenarios.sh --skip-feature http://localhost:8080
#
# Options :
#   --skip-feature  Ignore le scenario 11 (nouvelle feature stats)
#
# ============================================================================

SKIP_FEATURE=false
BASE_URL="http://localhost:8080"

for arg in "$@"; do
    if [[ "$arg" == "--skip-feature" ]]; then
        SKIP_FEATURE=true
    else
        BASE_URL="$arg"
    fi
done
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

# Fonction pour capturer body + HTTP code en une seule requete
do_request() {
    local FULL
    FULL=$(curl -s -w "\n%{http_code}" "$@")
    BODY=$(echo "$FULL" | sed '$d')
    HTTP_CODE=$(echo "$FULL" | tail -1)
}

# ============================================================================
echo "SCENARIO 1 : Commande Standard (montant <= 1000) — pas de remise"
echo "----------------------------------------------------------------------------"

do_request -X POST "$BASE_URL/api/ord" \
    -H "Content-Type: application/json" \
    -d '{"type":"std","email":"client1@test.com","amount":500}'

test_status_code "POST commande standard" "200" "$HTTP_CODE"
test_scenario "Montant inchange (500)" '"amount":500' "$BODY"

# ============================================================================
echo ""
echo "SCENARIO 2 : Commande Premium — flag premium:true et double discount"
echo "----------------------------------------------------------------------------"

RESPONSE=$(curl -s -X POST "$BASE_URL/api/ord" \
    -H "Content-Type: application/json" \
    -d '{"type":"prm","email":"premium@test.com","amount":800}')

test_scenario "Flag premium present" '"premium":true' "$RESPONSE"
test_scenario "Montant apres double discount 800 -> 648" '"amount":648' "$RESPONSE"

# ============================================================================
echo ""
echo "SCENARIO 3 : Commande Premium - double discount 1000 -> 810"
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

test_status_code "Commande avec email vide acceptee" "200" "$HTTP_CODE"

# ============================================================================
echo ""
echo "SCENARIO 6 : Email absent ne bloque PAS la commande"
echo "----------------------------------------------------------------------------"

HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$BASE_URL/api/ord" \
    -H "Content-Type: application/json" \
    -d '{"type":"std","amount":300}')

test_status_code "Commande sans champ email acceptee" "200" "$HTTP_CODE"

# ============================================================================
echo ""
echo "SCENARIO 7 : GET commande existante — contenu verifie"
echo "----------------------------------------------------------------------------"

# Creer une commande et recuperer son ID
RESPONSE=$(curl -s -X POST "$BASE_URL/api/ord" \
    -H "Content-Type: application/json" \
    -d '{"type":"std","email":"get-test@test.com","amount":100}')

ORDER_ID=$(echo $RESPONSE | grep -o '"id":"[^"]*"' | cut -d'"' -f4)

if [[ -n "$ORDER_ID" ]]; then
    do_request "$BASE_URL/api/ord/$ORDER_ID"
    test_status_code "GET commande existante" "200" "$HTTP_CODE"
    test_scenario "Reponse contient le type" '"type":"std"' "$BODY"
    test_scenario "Reponse contient le montant" '"amount":100' "$BODY"
    test_scenario "Reponse contient l email" '"email":"get-test@test.com"' "$BODY"
else
    echo -e "${YELLOW}SKIP${NC} — Impossible de recuperer l'ID de la commande"
fi

# ============================================================================
echo ""
echo "SCENARIO 8 : GET commande inexistante -> 404"
echo "----------------------------------------------------------------------------"

HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$BASE_URL/api/ord/inexistant-xyz-123")

test_status_code "GET inexistant retourne 404" "404" "$HTTP_CODE"

# ============================================================================
echo ""
echo "SCENARIO 9 : Soft Delete — DELETE retourne 200, puis GET retourne 404"
echo "----------------------------------------------------------------------------"

# Creer une commande
RESPONSE=$(curl -s -X POST "$BASE_URL/api/ord" \
    -H "Content-Type: application/json" \
    -d '{"type":"std","email":"delete-test@test.com","amount":50}')

ORDER_ID=$(echo $RESPONSE | grep -o '"id":"[^"]*"' | cut -d'"' -f4)

if [[ -n "$ORDER_ID" ]]; then
    # Verifier le code retour du DELETE
    HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" -X DELETE "$BASE_URL/api/ord/$ORDER_ID")
    test_status_code "DELETE retourne 200" "200" "$HTTP_CODE"

    # Verifier que GET retourne 404
    HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$BASE_URL/api/ord/$ORDER_ID")
    test_status_code "GET apres DELETE retourne 404" "404" "$HTTP_CODE"
else
    echo -e "${YELLOW}SKIP${NC} — Impossible de recuperer l'ID de la commande"
fi

# ============================================================================
echo ""
echo "SCENARIO 10 : DELETE commande inexistante -> 200"
echo "----------------------------------------------------------------------------"

HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" -X DELETE "$BASE_URL/api/ord/inexistant-delete-xyz")

test_status_code "DELETE inexistant retourne 200" "200" "$HTTP_CODE"

# ============================================================================
if [[ "$SKIP_FEATURE" == "true" ]]; then
    echo ""
    echo "SCENARIO 11 : SKIP (--skip-feature)"
    echo "----------------------------------------------------------------------------"
else
    echo ""
    echo "SCENARIO 11 : Endpoint Stats (nouvelle feature — verification complete)"
    echo "----------------------------------------------------------------------------"

    do_request "$BASE_URL/api/ord/stats"

    if [[ "$HTTP_CODE" == "200" ]]; then
        test_status_code "Endpoint stats existe" "200" "$HTTP_CODE"

        # Verification des champs obligatoires
        test_scenario "Stats contient totalOrders" "totalOrders" "$BODY"
        test_scenario "Stats contient ordersByType" "ordersByType" "$BODY"
        test_scenario "Stats contient totalRevenue" "totalRevenue" "$BODY"
        test_scenario "Stats contient averageOrderAmount" "averageOrderAmount" "$BODY"

        # 8 commandes creees (scenarios 1, 2, 3, 4, 5, 6, 7, 9), 1 supprimee (scenario 9) -> totalOrders = 7
        test_scenario "Stats exclut les commandes supprimees (totalOrders=7)" '"totalOrders":7' "$BODY"

        # Verification du mapping des types et des comptes
        # standard: scenarios 1, 5, 6, 7 = 4
        # premium: scenarios 2, 3 = 2
        # express: scenario 4 = 1
        test_scenario "ordersByType standard = 4" '"standard":4' "$BODY"
        test_scenario "ordersByType premium = 2" '"premium":2' "$BODY"
        test_scenario "ordersByType express = 1" '"express":1' "$BODY"
    else
        TOTAL=$((TOTAL + 1))
        FAILED=$((FAILED + 1))
        echo -e "${RED}FAIL${NC} — Endpoint stats n'existe pas (HTTP $HTTP_CODE)"
        echo -e "   ${YELLOW}Le candidat n'a pas implemente la feature${NC}"
    fi
fi

# ============================================================================
echo ""
echo "SCENARIO 12 : Commande Standard (montant > 1000) — remise 10% appliquee"
echo "----------------------------------------------------------------------------"
# 2000 avec remise 10% -> 2000 * 0.9 = 1800

RESPONSE=$(curl -s -X POST "$BASE_URL/api/ord" \
    -H "Content-Type: application/json" \
    -d '{"type":"std","email":"discount@test.com","amount":2000}')

test_scenario "Montant apres remise 10% (1800)" '"amount":1800' "$RESPONSE"

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
