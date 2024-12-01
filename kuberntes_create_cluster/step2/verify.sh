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

# Vérification du namespace
kubectl get namespace "$EXPECTED_NAMESPACE" > /dev/null 2>&1
print_result $? "Le namespace '$EXPECTED_NAMESPACE' existe."

# Vérification du secret
kubectl -n "$EXPECTED_NAMESPACE" get secret "$EXPECTED_SECRET" > /dev/null 2>&1
print_result $? "Le secret '$EXPECTED_SECRET' existe dans le namespace '$EXPECTED_NAMESPACE'."

# Vérification de la clé et de la valeur du secret
ACTUAL_VALUE=$(kubectl -n "$EXPECTED_NAMESPACE" get secret "$EXPECTED_SECRET" -o jsonpath="{.data.$EXPECTED_KEY}" | base64 --decode)

if [ "$ACTUAL_VALUE" == "$EXPECTED_VALUE" ]; then
    echo "✅  La clé '$EXPECTED_KEY' dans le secret '$EXPECTED_SECRET' a la valeur attendue."
else
    echo "❌  La clé '$EXPECTED_KEY' dans le secret '$EXPECTED_SECRET' n'a pas la valeur attendue."
    echo "Valeur actuelle : '$ACTUAL_VALUE'"
    exit 1
fi

echo "🎉  Toutes les vérifications ont réussi !"