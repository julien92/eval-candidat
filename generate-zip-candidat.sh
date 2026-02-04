#!/bin/bash

# ============================================================================
# Génère le zip à envoyer aux candidats
# Exclut : target/, fichiers évaluateur, test-scenarios.sh
# ============================================================================

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
OUTPUT="$SCRIPT_DIR/test-technique-ia.zip"

# Supprimer l'ancien zip s'il existe
rm -f "$OUTPUT"

cd "$SCRIPT_DIR"

zip -r "$OUTPUT" test-technique-ia/ \
    -x "test-technique-ia/target/*" \
    -x "test-technique-ia/.idea/*" \
    -x "test-technique-ia/*.iml"

echo ""
echo "Zip candidat généré : $OUTPUT"
echo ""
echo "Contenu :"
unzip -l "$OUTPUT"
