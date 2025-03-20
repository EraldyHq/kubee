## Get Access


* Port Forwarding: `kubectl port-forward svc/pushgateway 9091`.
    * http://localhost:9091
    * http://localhost:9091/metrics
* Kubectl Proxy `kubectl proxy`:
    * Metrics: http://localhost:8001/api/v1/namespaces/kube-prometheus/services/http:pushgateway:9091/proxy/metrics
    * Status: status page does not work (`display=none` on the node) when there is a path.


## Persistence

The file is not a txt file.

## Cli / Startup Flag


They can be seen on the gui `Startup Flags`
```bash
kubee app shell --shell sh pushgateway
# then  
pushgateway
```
```
pushgateway --help
usage: pushgateway [<flags>]

The Pushgateway


Flags:
  -h, --[no-]help                Show context-sensitive help (also try --help-long and --help-man).
      --[no-]web.systemd-socket  Use systemd socket activation listeners instead of port listeners (Linux only).
      --web.listen-address=:9091 ...
                                 Addresses on which to expose metrics and web interface. Repeatable for multiple addresses. Examples: `:9100` or `[::1]:9100` for http, `vsock://:9100` for vsock
      --web.config.file=""       Path to configuration file that can enable TLS or authentication. See: https://github.com/prometheus/exporter-toolkit/blob/master/docs/web-configuration.md
      --web.telemetry-path="/metrics"
                                 Path under which to expose metrics.
      --web.external-url=        The URL under which the Pushgateway is externally reachable.
      --web.route-prefix=""      Prefix for the internal routes of web endpoints. Defaults to the path of --web.external-url.
      --[no-]web.enable-lifecycle
                                 Enable shutdown via HTTP request.
      --[no-]web.enable-admin-api
                                 Enable API endpoints for admin control actions.
      --persistence.file=""      File to persist metrics. If empty, metrics are only kept in memory.
      --persistence.interval=5m  The minimum interval at which to write out the persistence file.
      --[no-]push.disable-consistency-check
                                 Do not check consistency of pushed metrics. DANGEROUS.
      --log.level=info           Only log messages with the given severity or above. One of: [debug, info, warn, error]
      --log.format=logfmt        Output format of log messages. One of: [logfmt, json]
      --[no-]version             Show application version.

```