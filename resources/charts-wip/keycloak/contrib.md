
## Operator

https://www.keycloak.org/operator/installation
https://www.keycloak.org/operator/installation#_installing_by_using_kubectl_without_operator_lifecycle_manager


## Manifest example

https://www.keycloak.org/server/configuration#_starting_keycloak

https://github.com/keycloak/keycloak-benchmark/tree/main/provision/minikube/keycloak


Dev mode: start-dev (HTTP is enabled)
https://raw.githubusercontent.com/keycloak/keycloak-quickstarts/refs/heads/main/kubernetes/keycloak.yaml

Prod mode: start argument
https://github.com/lukaszbudnik/keycloak-kubernetes/blob/main/keycloak.yaml

## Port

 
* http 8080 
* https 8443
* Health check endpoints are available at 
  * https://localhost:9000/health, 
  * https://localhost:9000/health/ready 
  * and https://localhost:9000/health/live
* Metrics:
  * https://localhost:9000/metrics 
