#!/bin/bash
  
# verify error understanding
expected="node/ubuntu"
real=$(kubectl get node -o name)

if [ "$expected" == "$real" ]; then
    echo "✅  Node running."
else
    echo "❌  Node not found"
    exit 1
fi

# Verify that the pod is in the running state
expected="      key: node-role.kubernetes.io/control-plane"
actual=$(kubectl get node -oyaml | grep "key: node-role.kubernetes.io")


if [ "$expected" == "$actual" ]; then
    echo "✅  Control-plan created"
else
    echo "❌  No Control-plan"
    exit 1
fi

