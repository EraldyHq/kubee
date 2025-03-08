# Unit Testing for Alert Rules an PromQl with PromTool Test


## batch-job-test.yml


```bash
# one file
promtool test rules batch-job-test.yml
# debug
promtool test rules --debug batch-job-test.yml
```


## test.yml : Example from doc
https://prometheus.io/docs/prometheus/latest/configuration/unit_testing_rules/#example

```bash
# one file
promtool test rules test.yml
# multiple
promtool test rules test1.yml test2.yml test3.yml
```