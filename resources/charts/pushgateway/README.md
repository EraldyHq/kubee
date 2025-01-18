



## Get Access


* Port Forwarding: `kubectl port-forward svc/pushgateway 9091`.
    * http://localhost:9091
    * http://localhost:9091/metrics
* Kubectl Proxy `kubectl proxy`:
    * Metrics: http://localhost:8001/api/v1/namespaces/kube-prometheus/services/http:pushgateway:9091/proxy/metrics
    * Status: status page does not work (`display=none` on the node) when there is a path.