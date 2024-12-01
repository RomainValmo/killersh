#!/bin/bash

# verify error understanding
errorexpected="Error"
errordeclared=$(cat /opt/exercise2/podstatus.txt)

if [ "$errorexpected" == "$errordeclared" ]; then
    echo "✅  Error found."
else
    echo "❌  Error not found"
    exit 1
fi

# Verify that the pod is in the running state
expected="apache   Running"
actual=$(kubectl get pod -n exercise2 -o custom-columns="NAME:.metadata.name,STATUS:.status.phase" --no-headers)


if [ "$expected" == "$actual" ]; then
    echo "✅  Issue fixed."
else
    echo "❌  No fixed"
    exit 1
fi