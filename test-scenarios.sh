#!/bin/bash

# ============================================================================
# 🧪 Script de Test — Évaluation Candidat
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
echo "🧪 TEST DE NON-RÉGRESSION — Évaluation Candidat"
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
        echo -e "${GREEN}✅ PASS${NC} — $name"
        PASSED=$((PASSED + 1))
        return 0
    else
        echo -e "${RED}❌ FAIL${NC} — $name"
        echo -e "   ${YELLOW}Attendu contient :${NC} $expected"
        echo -e "   ${YELLOW}Reçu :${NC} $actual"
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
        echo -e "${GREEN}✅ PASS${NC} — $name (HTTP $actual_code)"
        PASSED=$((PASSED + 1))
        return 0
    else
        echo -e "${RED}❌ FAIL${NC} — $name"
        echo -e "   ${YELLOW}Attendu :${NC} HTTP $expected_code"
        echo -e "   ${YELLOW}Reçu :${NC} HTTP $actual_code"
        FAILED=$((FAILED + 1))
        return 1
    fi
}

# ============================================================================
echo "📦 SCÉNARIO 1 : Commande Standard acceptée"
echo "----------------------------------------------------------------------------"

HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$BASE_URL/api/ord" \
    -H "Content-Type: application/json" \
    -d '{"t":"std","m":"client1@test.com","a":500}')

test_status_code "POST commande standard" "200" "$HTTP_CODE"

# ============================================================================
echo ""
echo "👑 SCÉNARIO 2 : Commande Premium avec flag pr:true"
echo "----------------------------------------------------------------------------"

RESPONSE=$(curl -s -X POST "$BASE_URL/api/ord" \
    -H "Content-Type: application/json" \
    -d '{"t":"prm","m":"premium@test.com","a":800}')

test_scenario "Flag premium présent" '"pr":true' "$RESPONSE"

# ============================================================================
echo ""
echo "👑 SCÉNARIO 3 : Commande Premium - double discount appliqué"
echo "----------------------------------------------------------------------------"
# 1000€ avec double discount 10% → 1000 * 0.9 * 0.9 = 810€

RESPONSE=$(curl -s -X POST "$BASE_URL/api/ord" \
    -H "Content-Type: application/json" \
    -d '{"t":"prm","m":"premium2@test.com","a":1000}')

test_scenario "Montant après double discount (810)" '"a":810' "$RESPONSE"

# ============================================================================
echo ""
echo "🚀 SCÉNARIO 4 : Commande Express acceptée"
echo "----------------------------------------------------------------------------"

HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$BASE_URL/api/ord" \
    -H "Content-Type: application/json" \
    -d '{"t":"exp","m":"express@test.com","a":200}')

test_status_code "POST commande express" "200" "$HTTP_CODE"

# ============================================================================
echo ""
echo "📧 SCÉNARIO 5 : Email vide ne bloque PAS la commande"
echo "----------------------------------------------------------------------------"

HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$BASE_URL/api/ord" \
    -H "Content-Type: application/json" \
    -d '{"t":"std","m":"","a":100}')

test_status_code "Commande sans email acceptée" "200" "$HTTP_CODE"

# ============================================================================
echo ""
echo "🔍 SCÉNARIO 6 : GET commande existante"
echo "----------------------------------------------------------------------------"

# Créer une commande et récupérer son ID
RESPONSE=$(curl -s -X POST "$BASE_URL/api/ord" \
    -H "Content-Type: application/json" \
    -d '{"t":"std","m":"get-test@test.com","a":100}')

ORDER_ID=$(echo $RESPONSE | grep -o '"id":"[^"]*"' | cut -d'"' -f4)

if [[ -n "$ORDER_ID" ]]; then
    HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$BASE_URL/api/ord/$ORDER_ID")
    test_status_code "GET commande existante" "200" "$HTTP_CODE"
else
    echo -e "${YELLOW}⚠️  SKIP${NC} — Impossible de récupérer l'ID de la commande"
fi

# ============================================================================
echo ""
echo "🚫 SCÉNARIO 7 : GET commande inexistante → 404"
echo "----------------------------------------------------------------------------"

HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$BASE_URL/api/ord/inexistant-xyz-123")

test_status_code "GET inexistant retourne 404" "404" "$HTTP_CODE"

# ============================================================================
echo ""
echo "🗑️  SCÉNARIO 8 : Soft Delete → GET retourne 404 après DELETE"
echo "----------------------------------------------------------------------------"

# Créer une commande
RESPONSE=$(curl -s -X POST "$BASE_URL/api/ord" \
    -H "Content-Type: application/json" \
    -d '{"t":"std","m":"delete-test@test.com","a":50}')

ORDER_ID=$(echo $RESPONSE | grep -o '"id":"[^"]*"' | cut -d'"' -f4)

if [[ -n "$ORDER_ID" ]]; then
    # Supprimer
    curl -s -X DELETE "$BASE_URL/api/ord/$ORDER_ID" > /dev/null
    
    # Vérifier que GET retourne 404
    HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$BASE_URL/api/ord/$ORDER_ID")
    test_status_code "GET après DELETE retourne 404" "404" "$HTTP_CODE"
else
    echo -e "${YELLOW}⚠️  SKIP${NC} — Impossible de récupérer l'ID de la commande"
fi

# ============================================================================
echo ""
echo "📊 SCÉNARIO 9 : Endpoint Stats (nouvelle feature)"
echo "----------------------------------------------------------------------------"

HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$BASE_URL/api/ord/stats")

if [[ "$HTTP_CODE" == "200" ]]; then
    RESPONSE=$(curl -s "$BASE_URL/api/ord/stats")
    test_status_code "Endpoint stats existe" "200" "$HTTP_CODE"
    test_scenario "Stats contient totalOrders" "totalOrders" "$RESPONSE"
    test_scenario "Stats contient ordersByType" "ordersByType" "$RESPONSE"

    # Vérifier que les commandes supprimées sont exclues
    # 7 commandes créées (scénarios 1-6 + 8), 1 supprimée (scénario 8) → totalOrders = 6
    test_scenario "Stats exclut les commandes supprimées (totalOrders=6)" '"totalOrders":6' "$RESPONSE"
else
    TOTAL=$((TOTAL + 1))
    FAILED=$((FAILED + 1))
    echo -e "${RED}❌ FAIL${NC} — Endpoint stats n'existe pas (HTTP $HTTP_CODE)"
    echo -e "   ${YELLOW}Le candidat n'a pas implémenté la feature${NC}"
fi

# ============================================================================
echo ""
echo "============================================================================"
echo "📋 RÉSULTATS"
echo "============================================================================"
echo ""
echo -e "Tests passés  : ${GREEN}$PASSED${NC} / $TOTAL"
echo -e "Tests échoués : ${RED}$FAILED${NC} / $TOTAL"
echo ""

SCORE=$((PASSED * 100 / TOTAL))
echo -e "Score : ${YELLOW}$SCORE%${NC}"
echo ""

if [[ $FAILED -eq 0 ]]; then
    echo -e "${GREEN}🎉 TOUS LES TESTS PASSENT${NC}"
    exit 0
elif [[ $FAILED -le 2 ]]; then
    echo -e "${YELLOW}⚠️  Quelques régressions mineures${NC}"
    exit 1
else
    echo -e "${RED}❌ RÉGRESSIONS CRITIQUES DÉTECTÉES${NC}"
    exit 1
fi
