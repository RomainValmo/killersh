#!/bin/bash

# verify error understanding
expected=$(kubectl -n kube-system get pod | grep cilium | grep Running)
if [ "$expected" != "" ]; then
    echo "✅  cilium is  running."
else
    echo "❌  cilium  not found"
    exit 1
fi

# Verify that the pod is in the running state
expected="Running"
actual=$(kubectl get pod test -o jsonpath="{.status.phase}")


if [ "$expected" == "$actual" ]; then
    echo "✅  Pod test is running "
else
    echo "❌  Pod test is not running "
    exit 1
fi