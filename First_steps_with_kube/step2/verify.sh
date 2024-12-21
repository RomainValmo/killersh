kubectl get deployments.apps apache

imagedeployed=$(kubectl  get deployments.apps apache -oyaml | grep 'image:' | xargs)
imageexpected="- image: httpd"

if [ "$imagedeployed" == "$imageexpected" ]; then
  echo "done"
else
  echo "fail"
  exit 1
fi

containernamedeployed=$(kubectl get deployment apache -o jsonpath='{.spec.template.spec.containers[0].name}')
containernameexpected="apache-pod"

if [ "$containernamedeployed" == "$containernameexpected" ]; then
  echo "done"
else
  echo "fail"
  exit 1
fi

count=$(kubectl get pod | grep apache- | wc -l)
expected="4"

if [ "$count" == "$expected" ]; then
  echo "done"
else
  echo "fail"
  exit 1
fi