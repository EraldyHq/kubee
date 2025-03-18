# Contrib/Dev


This helm is based on the [container](https://docs.postalserver.io/other/containers)

## Ports

Postal doesn't support is implicit TLS.
It requires explicit TLS https://github.com/orgs/postalserver/discussions/3326

## Test 
### Open Port

```bash
nc -vz postal.eraldy.com 25
```
```
Starting Nmap 7.95 ( https://nmap.org ) at 2025-03-18 16:15 CET
Nmap scan report for postal.eraldy.com (188.245.43.250)
Host is up (0.020s latency).
rDNS record for 188.245.43.250: whoami.eraldy.com

PORT   STATE    SERVICE
25/tcp filtered smtp

Nmap done: 1 IP address (1 host up) scanned in 0.25 seconds
```

### Test Transaction from the cluster

Connect
* From a cluster shell:
```bash
# without startls
telnet smtp.postal 25
# without starttls
openssl s_client -crlf -starttls smtp -connect smtp.postal:25
```
and start a transaction.

### Test Transaction from outside the cluster

```bash
telnet postal.eraldy.com 25 # May be blocked by your internet provider
# you need to test it from the cluster
telnet postal.eraldy.com 587
openssl s_client \
  -crlf \
  -starttls smtp \
  -connect postal.eraldy.com:25
```

## Return Path

```http request
Return-Path: <kvmsrm@psrp.postal.eraldy.com>
```

## Example DNS configuration

With the sub-domain `postal.example.com`

* A mx
```bash
dig A postal.eraldy.com +short
```
```
x.x.x.x # your server ip
```

* AAAA:
```bash
dig AAAA postal.eraldy.com +short
```
```
x.x.x.x
```
* Mx:
```bash
dig MX postal.example.com +short
```
```
10 postal.example.com.
```
* Spf:
```bash
dig TXT postal.example.com +short
```
```
"v=spf1 a mx include:postal.example.com ~all"
```
* Dkim
```bash
dig TXT postal-a1ekqz._domainkey.postal.example.com +short
```
```
v=DKIM1; t=s; h=sha256; p=MIGfMA0GCSxxxxxxx
```
* A return path (should not be the same name as mx)
```bash
dig A rp.postal.eraldy.com + short
```
```
x.x.x.x # your server ip
```
* CNAME Return Path
```bash
dig CNAME +short psrp.postal.example.com 
```
```
rp.postal.example.com.
```


## Database install and upgrade on ArgoCd


ArgoCD documentation on Helm handling: https://argo-cd.readthedocs.io/en/stable/user-guide/helm/#helm-hooks

Specifically: 'install' vs 'upgrade' vs 'sync'
Argo CD cannot know if it is running a first-time "install" or an "upgrade" 
every operation is a "sync'. This means that, by default, 
apps that have pre-install and pre-upgrade will have those hooks run at the same time.

## Config

We have split the [config](https://docs.postalserver.io/getting-started/configuration) in 2:
* [File](https://github.com/postalserver/postal/blob/main/doc/config/yaml.yml) stored as `conf_yaml`
* [Env](https://github.com/postalserver/postal/blob/main/doc/config/environment-variables.md) for secret and host

The default config is for docker as:
* it listens to `localhost` and not `0.0.0.0`
* and the service name is not in Kubernetes format.


`$config-file-root`, in the [docker image](https://docs.postalserver.io/other/containers#configuration), the `$config-file-root` is `/config`

## TODO
### Automatic Admin User ?

* The password hash is a [bcrypt](https://github.com/postalserver/postal/blob/fd3c7ccdf6dc4ee0a76c9523cbd735159e4b8000/app/models/concerns/has_authentication.rb#L31)
* uuid is number 4 `554423b5-15bd-4d37-87eb-fbb3487db815`
* `timezone` UTC

```sql
insert into users (id, uuid, first_name, last_name, email_address, password_digest, time_zone, email_verification_token,
                   email_verified_at, created_at, updated_at, password_reset_token, password_reset_token_valid_until,
                   admin, oidc_uid, oidc_issuer)
values ();
```




## Search Note

### Docker Artifacts

* [Compose](https://github.com/postalserver/install/blob/main/templates/docker-compose.v3.yml)
* [Dockerfile](https://github.com/postalserver/postal/blob/main/Dockerfile)


### Helm

#### Postal Helm Server Install Pull
The helm is not yet finished: https://github.com/postalserver/install/pull/20
and pretty poor

We didn't go with it.
```bash
mkdir charts
git remote add -f postal-chart https://github.com/dmitryzykov/postal-install.git
git subtree add --prefix=resources/charts/stable/postal/charts/postal postal-chart main --squash -- helm/postal
mkdir charts/postal-1.0.0.tgz
```

#### Postal Helm Chart
We found [this postal chart](https://github.com/hoverkraft-tech/helm-chart-postal), but it's not yet released
in a correct format.


Does not work:
```bash
# Pull of https://github.com/hoverkraft-tech/helm-chart-postal
helm pull https://github.com/hoverkraft-tech/helm-chart-postal/archive/refs/tags/0.3.1.tar.gz -d charts --untar
# Does not work (expect only one chart, chart is not at the root)
helm pull oci://github.com/hoverkraft-tech/helm-chart-postal -d charts --untar
```

### Database Model

See: https://github.com/postalserver/postal/tree/3.3.4/app/models

###  Standard Installation

#### Postal Cli Install

Install the [postal bash cli](https://github.com/postalserver/install/blob/main/bin/postal)
and resources
```bash
sudo git clone https://github.com/postalserver/install /opt/postal/install
sudo ln -s /opt/postal/install/bin/postal /usr/bin/postal
```


#### Boostrap

Bootstrap is a docker compose file generation.
that generate three files in `/opt/postal/config`
```bash
sudo postal bootstrap postal.yourdomain.com
```
```
Latest version is: 3.3.4
=> Creating /opt/postal/config/postal.yml
=> Creating /opt/postal/config/Caddyfile
=> Creating signing private key
```
See:
* [postal installation](https://github.com/postalserver/install/blob/main/examples/postal.v3.yml)
* [posta fulll](https://github.com/postalserver/postal/blob/main/doc/config/yaml.yml)
* [Caddyfile](https://github.com/postalserver/install/blob/main/examples/Caddyfile)

#### Initialize/mk user

It will run the [docker-compose.v$MAJOR_VERSION.yml](https://github.com/postalserver/install/blob/main/templates/docker-compose.v3.yml)
to the `/opt/postal/install` dir


## Howto

### Connect to the database

```bash
kubee kubectl -n postal port-forward svc/mariadb 3306
```

## Support

### 550 Invalid server token

For any reason, mx should be equal to return_path_domain
https://github.com/postalserver/postal/issues/200#issuecomment-305448529

`550` implies that the domain on the email address 
that Postal is seeing is not one it is aware of.

### Bad password

[Connect to the database](#connect-to-the-database) and delete the rows from the users table




## Note

* Postal is a docker based installation. For instance, an upgrade is performed [postal upgrade command line](https://docs.postalserver.io/getting-started/upgrading)
* `postal make-user` pull a big image (491MB around 4 minutes)
* `postal` uses the `/config/postal.yml` conf
* ruby app
