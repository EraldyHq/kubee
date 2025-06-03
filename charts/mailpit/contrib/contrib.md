
You can use it as:
* mail testing tool
* or proxy cache via its relay function

## FAQ

### Why port 465 with TLS

Because we want to be able to proxy based on SNI
TLS is mandatory.

## Bootstrap

```bash
task dep
```


## Test With OpenSsl

Connect
* From a cluster shell:
```bash
openssl s_client -crlf -connect mailpit-smtp.mail:465 -nocommands
```
* From the outside world:
```bash
openssl s_client -crlf -connect mailpit-bcf52bfa.nip.io:465 -servername mailpit-bcf52bfa.nip.io -nocommands
```
and start a transaction.

