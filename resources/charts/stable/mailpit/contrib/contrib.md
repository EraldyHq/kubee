


## Bootstrap

```bash
mkdir charts/
ln -s $(realpath ../cluster) charts/kubee-cluster
mkdir charts/kubee-cluster-0.0.1.tgz
mkdir "charts/kubee-traefik"
mkdir charts/kubee-traefik-0.0.1.tgz
ln -s $(realpath ../traefik/Chart.yaml) charts/kubee-traefik/Chart.yaml
ln -s $(realpath ../traefik/values.yaml) charts/kubee-traefik/values.yaml
mkdir "charts/kubee-cert-manager"
mkdir charts/kubee-cert-manager-0.0.1.tgz
ln -s $(realpath ../cert-manager/Chart.yaml) charts/kubee-cert-manager/Chart.yaml
ln -s $(realpath ../cert-manager/values.yaml) charts/kubee-cert-manager/values.yaml

helm repo add jouve https://jouve.github.io/charts//
helm pull https://github.com/jouve/charts/releases/download/mailpit-0.22.2/mailpit-0.22.2.tgz -d charts --untar
```


## Test

* From a cluster shell:
```bash
openssl s_client -crlf -connect mailpit-smtp.mail:465 
```
* From the outside world:
```bash
openssl s_client -crlf -connect mailpit-bcf52bfa.nip.io:465 -servername mailpit-bcf52bfa.nip.io
```

## Support
### can_renegotiate:wrong

You get
```
408C23289C7F0000:error:0A00010A:SSL routines:can_renegotiate:wrong ssl version:ssl/ssl_lib.c:2833:
```

Why?
You enter `RCPT TO` in a openssl session.

But pressing `R` in an s_client session causes openssl to renegotiate and it's not supported in TLS 1.3

Solution: enter `rcpt to`

Ref:
* https://github.com/openssl/openssl/issues/12294
* https://serverfault.com/questions/336617/postfix-tls-over-smtp-rcpt-to-prompts-renegotiation-then-554-5-5-1-error-no-v#:~:text=Pressing%20%22R%22%20in%20an%20s_client%20session%20causes%20openssl%20to%20renegotiate.

