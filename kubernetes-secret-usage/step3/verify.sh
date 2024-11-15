# Variables à vérifier
EXPECTED_NAMESPACE="private"  # Nom du namespace attendu
EXPECTED_SECRET="myfirstsecret"       # Nom du secret attendu
EXPECTED_KEY="secret"              # Nom de la clé dans le secret
EXPECTED_VALUE="123456"         # Valeur attendue pour la clé

# Fonction pour afficher le résultat
function print_result() {
    if [ "$1" -eq 0 ]; then
        echo "✅  $2"
    else
        echo "❌  $2"
        exit 1
    fi
}

ACTUAL_VALUE=$(kubectl -n "$EXPECTED_NAMESPACE" get secret "$EXPECTED_SECRET" -o jsonpath="{.data.$EXPECTED_KEY}")
WRITTEN_VALUE=$(cat /opt/secret/value.txt)



if [ "$ACTUAL_VALUE" == "$WRITTEN_VALUE" ]; then
    echo "✅  La bonne est rentrée."
else
    echo "❌  La clé  n'a pas la valeur attendue."
    echo "Valeur actuelle : '$ACTUAL_VALUE'"
    exit 1
fi

echo "🎉  Toutes les vérifications ont réussi !"