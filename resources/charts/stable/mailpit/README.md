# Kubee Mailpit  Chart


This chart installs the Mail Catcher, [Mailpit](https://github.com/axllent/mailpit). 

You can use it as:
* mail testing tool
* or proxy cache via its relay function


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
  * the smtp server is available at `hostname:465` in tls mode without any authentication
  * the web server is available at https://hostname
