% promtool(1) Version Latest | Promtool shipped in Docker
# DESCRIPTION

The [PromTool](https://prometheus.io/docs/prometheus/latest/command-line/promtool/) cli driven by [env](#environment-variable) with XTras.

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

# EXTRAS

## PrometheusRule Check

The command `check prometheusRule prometheusRuleFile` permits to check a [Prometheus Rule](https://prometheus-operator.dev/docs/api-reference/api/#monitoring.coreos.com/v1.PrometheusRule)

## The url flag

This script will set the `--url` flag (The URL for the Prometheus server) 
if the `KUBE_X_PROM_URL` is set (default to `http://localhost:9090`)

### Basic Auth

This script will set the `--http.config.file` (It defines the HTTP client configuration file for promtool to connect to Prometheus)
with `Basic Auth` configuration.

The `Basic Auth` credentials should be stored in [pass](https://www.passwordstore.org/)

* For the [basic_auth user](https://prometheus.io/docs/alerting/latest/configuration/#http_config): the env `KUBE_X_PROM_BASIC_AUTH_PASS_USER` gives its path  
```bash
# ie this command should return the user
pass "$KUBE_X_PROM_BASIC_AUTH_PASS_USER"
```
* For the [basic_auth password](https://prometheus.io/docs/alerting/latest/configuration/#http_config): the env `KUBE_X_PROM_BASIC_AUTH_PASS_PASSWORD` gives its path 
```bash
# ie this command should return the password
pass "$KUBE_X_PROM_BASIC_AUTH_PASS_PASSWORD"
```

# SYNOPSIS

```bash
This tool adds also the command `promtool check prometheusRules` to check one `PrometheusRule` CRD file of `Prometheus Operator`.

usage: promtool [<flags>] <command> [<args> ...]

Tooling for the Prometheus monitoring system.


Flags:
  -h, --[no-]help            Show context-sensitive help (also try --help-long and --help-man).
      --[no-]version         Show application version.
      --[no-]experimental    Enable experimental commands.
      --enable-feature= ...  Comma separated feature names to enable. Currently unused.

Commands:
help [<command>...]
    Show help.

check service-discovery [<flags>] <config-file> <job>
    Perform service discovery for the given job name and report the results, including relabeling.

check config [<flags>] <config-files>...
    Check if the config files are valid or not.

check web-config <web-config-files>...
    Check if the web config files are valid or not.

check healthy [<flags>]
    Check if the Prometheus server is healthy.

check ready [<flags>]
    Check if the Prometheus server is ready.

check rules [<flags>] [<rule-files>...]
    Check if the rule files are valid or not.

check metrics
    Pass Prometheus metrics over stdin to lint them for consistency and correctness.

    examples:

    $ cat metrics.prom | promtool check metrics

    $ curl -s http://localhost:9090/metrics | promtool check metrics

query instant [<flags>] <server> <expr>
    Run instant query.

query range [<flags>] <server> <expr>
    Run range query.

query series --match=MATCH [<flags>] <server>
    Run series query.

query labels [<flags>] <server> <name>
    Run labels query.

query analyze --server=SERVER --type=TYPE --match=MATCH [<flags>]
    Run queries against your Prometheus to analyze the usage pattern of certain metrics.

debug pprof <server>
    Fetch profiling debug information.

debug metrics <server>
    Fetch metrics debug information.

debug all <server>
    Fetch all debug information.

push metrics [<flags>] <remote-write-url> [<metric-files>...]
    Push metrics to a prometheus remote write (for testing purpose only).

test rules [<flags>] <test-rule-file>...
    Unit tests for rules.

tsdb bench write [<flags>] [<file>]
    Run a write performance benchmark.

tsdb analyze [<flags>] [<db path>] [<block id>]
    Analyze churn, label pair cardinality and compaction efficiency.

tsdb list [<flags>] [<db path>]
    List tsdb blocks.

tsdb dump [<flags>] [<db path>]
    Dump samples from a TSDB.

tsdb dump-openmetrics [<flags>] [<db path>]
    [Experimental] Dump samples from a TSDB into OpenMetrics text format, excluding native histograms and staleness markers, which are not representable in OpenMetrics.

tsdb create-blocks-from openmetrics [<flags>] <input file> [<output directory>]
    Import samples from OpenMetrics input and produce TSDB blocks. Please refer to the storage docs for more details.

tsdb create-blocks-from rules --start=START [<flags>] <rule-files>...
    Create blocks of data for new recording rules.

promql format <query>
    Format PromQL query to pretty printed form.

promql label-matchers set [<flags>] <query> <name> <value>
    Set a label matcher in the query.

promql label-matchers delete <query> <name>
    Delete a label from the query.


```

