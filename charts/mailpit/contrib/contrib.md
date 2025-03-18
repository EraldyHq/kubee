
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
openssl s_client -crlf -connect mailpit-smtp.mail:465
```
* From the outside world:
```bash
openssl s_client -crlf -connect mailpit-bcf52bfa.nip.io:465 -servername mailpit-bcf52bfa.nip.io
```
and start a transaction.

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

