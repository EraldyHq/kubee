# Kubee Mailpit Chart


This chart installs the Mail Catcher, [Mailpit](https://github.com/axllent/mailpit). 


## Installation

* In your cluster values file
```yaml
mailpit:
  enabled: true
  hostname: 'hostname.example.tld'
```
* Play
```bash
kubee -c clusterName helmet play mailpit 
```
* Once installed,
  * the smtp server is available:
    * at `hostname:465` in tls mode without any authentication
    * by default only for your private network if defined
  * the web server is available at https://hostname with the traefik authentication
