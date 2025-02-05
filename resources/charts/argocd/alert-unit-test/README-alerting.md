# Unit Testing for Alert Rules an PromQl with PromTool Test


## batch-job-test.yml

 
```bash
# go to the parent directory
cd ..
# kubee-promtool will scan all file to search prometheusRules crd file 
kubee-promtool test prometheusRules alert-unit-test/argocd-test.yml
# debug
kubee-promtool test prometheusRules --debug alert-unit-test/argocd-test.yml
```

