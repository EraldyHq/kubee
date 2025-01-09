# Unit Testing for Alert Rules an PromQl with PromTool Test


## batch-job-test.yml

 
```bash
# go to the parent directory
cd ..
# kube-x-promtool will scan all file to search prometheusRules crd file 
kube-x-promtool test prometheusRules alert-unit-test/argocd-test.yml
# debug
kube-x-promtool test prometheusRules --debug alert-unit-test/argocd-test.yml
```

