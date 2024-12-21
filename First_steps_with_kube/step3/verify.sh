kubectl get service apache-service
serviceexpose=$(kubectl get service apache-service -ojsonpath='{.spec.selector.app}')
servicespected="apache"

if [ "$serviceexpose" == "$servicespected" ]; then
  echo "done"
else
  echo "fail"
  exit1

fi

portexpose=$(kubectl get service apache-service -o jsonpath='{.spec.ports[0].port}')
portexpected="80"

if [ "$portexpose" == "$portexpected" ]; then
  echo "done"
else
  echo "fail"
  exit1

fi

ip=$(kubectl get service apache-service -o jsonpath='{.spec.clusterIP'})
retour=$(curl $ip)
expected="<html><body><h1>It works!</h1></body></html>"

if [ "$retour" == "$expected" ]; then
  echo "done"
else
  echo "fail"
  exit1

fi