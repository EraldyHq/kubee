% promtool(1) Version Latest | Promtool shipped in Docker
# DESCRIPTION

The [PromTool](https://prometheus.io/docs/prometheus/latest/command-line/promtool/) cli driven by [env](#environment-variable)

# EXAMPLE

```bash
cat metrics.prom | promtool check metrics
curl -s http://localhost:9090/metrics | promtool check metrics
promtool test rules test.yml
```
The files (`metrics.prom`, `test.yml`) should be in the current directory.


# EXECUTION

The `PromTool` is executed with:
* the Prometheus docker image 
* only the working directory available


# Environment Variable

This script will create automatically the following options based on the [environment](#environment-variable)

## The url flag

The `--url` flag (The URL for the Prometheus server) is created
via the `KUBE_X_PROM_URL` (default to `http://localhost:9090`)

## The http.config.file

The `--http.config.file` defines the HTTP client configuration file for promtool to connect to Prometheus.

We support creating it for `Basic Auth` with secrets stored in [pass](https://www.passwordstore.org/)

List:
* For the [basic_auth user](https://prometheus.io/docs/alerting/latest/configuration/#http_config): `KUBE_X_PROM_BASIC_AUTH_PASS_USER`  
```bash
# ie this command should return the user
pass "$KUBE_X_PROM_BASIC_AUTH_PASS_USER"
```
* For the [basic_auth password](https://prometheus.io/docs/alerting/latest/configuration/#http_config): `KUBE_X_PROM_BASIC_AUTH_PASS_PASSWORD` 
```bash
# ie this command should return the password
pass "$KUBE_X_PROM_BASIC_AUTH_PASS_PASSWORD"
```



# SYNOPSIS

```bash
${SYNOPSIS}
```

