#!/bin/bash

# Verify that the pod is in the running state
expected="nginx   Running"
actual=$(kubectl get pod -n exercice1 -o custom-columns="NAME:.metadata.name,STATUS:.status.phase" --no-headers)


if [ "$expected" == "$actual" ]; then
    echo "✅  Issue fixed."
else
    echo "❌  No fixed"
    exit 1
fi