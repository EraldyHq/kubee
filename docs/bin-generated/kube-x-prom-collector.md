% kube-x-collector(1) Version Latest | Shows the unique metrics of a Prometheus collector
# DESCRIPTION

Shows the unique metrics of a Prometheus collector by cardinality

# EXAMPLE

The first 20 high cardinality metrics
```bash
kube-x-collector https://host/metrics | head 20
```

# SYNOPSIS

kube-x-prom-collector URL

