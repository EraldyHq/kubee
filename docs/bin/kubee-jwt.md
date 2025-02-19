

The key used to sign tokens is auto-generated, and managed by dex.
https://github.com/dexidp/dex/issues/1310

When public keys are distributed, they are usually done by giving out 
a signed X509 certificate,
which contains
* the public key,
* identification information (linking that key to an entity),
* and a signature from a trusted authority.

## JWKS

The JSON Web Key Set (JWKS) is a set of keys containing the public keys 
used to verify any JSON Web Token (JWT) 
issued by the Authorization Server and signed using the RS256 signing algorithm.
https://auth0.com/docs/secure/tokens/json-web-tokens/json-web-key-sets

## RSA

An RSA public key is made up of:
* the modulus 
* and the public exponent.

### Xml
* Xml
```xml
<RSAKeyValue>
    <Modulus>1znidPBIcMcO7K/53tkTSyKqxlG5Mcws8kVtijS4tyEU4W/FEVWYpOtv+Stnb4Vt</Modulus>
    <Exponent>AQAB</Exponent>
</RSAKeyValue>
```

### JWK

A JSON object that represents a cryptographic key.
Rfc: https://www.rfc-editor.org/rfc/rfc7517

* https://dex-xxx.nip.io/keys is a `JSON Web Keyset` that holds a series of `JSON Web Key`. Example:
```json
{
  "use": "sig",
  "kty": "RSA",
  "kid": "5c6097630863e16d9eb72adf2c6f4624aeb1f6aa",
  "alg": "RS256",
  "n": "qXWwy_SMQ1qlqPo2FOcWbK5MRd3PHvso_LFncL0zhelLDjFwoFh2dAwVBUVnjzFcIuH4dW8pqlNkFk0E5SlEPgtL14Ah6YKMblnIHimnA_34Ttu-USpm3yBh637AOV1BIe4VGcNWV0rlQmOAL1QmsrIIfowdT3sVKvYnvJAcVPTL9F8Dbfh4K5ak0DvcwV5XOxjZWyW4R_0uhfJyahvpJb_j-NR2aOcHWN0DOCYIBSlE-6l3DwbnC8UOZroY0BrObSk-nP2qjtOw8q_z1c1Gc2iaoVTlYVmYR1VHSsfTsHzxLDHsSTO7TKfIkhWDE5H3Au10geUBDXeAZ5iULxD6aQ",
  "e": "AQAB"
}
```
were:
* kid is key id
* kty is the key type
* use is the usage (sig=signature)
* alg is the algo
* n is the modulus
* e is the exponent
You can paste this JSON into the public key text field in jwt.io and the JWT will pass validation

### Cert

```cert
Subject Public Key Info:
    Public Key Algorithm: rsaEncryption
        Public-Key: (2048 bit)
        Modulus:
            00:bb:cf:20:3d:ef:c7:3e:8e:8b:b7:84:09:9b:de:
            55:0a:ec:67:fd:75:96:b7:b6:e2:9c:86:27:94:d6:
            21:49:83:bf:30:3c:af:ef:f0:0c:e3:46:b3:1e:28:
            b6:e5:45:41:41:36:4c:f2:ca:fc:28:56:d4:c9:9b:
            76:16:60:b6:73:da:b7:52:a7:0c:c3:96:00:cc:d9:
            29:68:68:63:2a:95:e4:db:f7:ae:78:3a:9d:b4:6b:
            85:bf:83:6d:dc:18:6e:37:37:36:7e:93:77:f3:c3:
            c6:94:dc:5e:41:59:b8:8e:e2:f5:6f:aa:1f:cf:30:
            3c:cc:7a:6d:d0:5a:a4:46:3b:2e:d5:2d:e8:9f:df:
            cc:0f:d0:c8:62:27:0c:38:8b:63:ba:66:3d:32:66:
            ee:29:a9:d0:f8:7a:0c:88:87:13:77:35:91:ff:14:
            81:10:db:7b:58:72:a1:a8:f6:e2:be:c8:43:e1:d9:
            5f:9d:68:30:a1:2e:43:f9:7e:5c:0d:26:3a:65:22:
            35:a3:1a:bb:9e:ca:33:9b:ba:66:7c:86:2b:49:f5:
            f0:16:1b:ae:97:e7:bb:e6:f9:a5:d2:ac:32:36:91:
            1b:4e:1b:37:06:75:6b:89:11:06:1b:9a:89:b2:1c:
            39:40:1a:3b:a5:ff:37:16:46:6a:5b:bd:87:a5:43:
            b4:39
        Exponent: 65537 (0x10001)
```



## JWK to RSA fields
* parameter n: Base64 URL encoded string representing the modulus of the RSA Key.
* parameter e: Base64 URL encoded string representing the public exponent of the RSA Key.
* parameter d: Base64 URL encoded string representing the private exponent of the RSA Key.
* parameter p: Base64 URL encoded string representing the secret prime factor of the RSA Key.
* parameter q: Base64 URL encoded string representing the secret prime factor of the RSA Key.
* parameter dp: Base64 URL encoded string representing the first factor CRT exponent of the RSA Key. d mod (p-1)
* parameter dq: Base64 URL encoded string representing the second factor CRT exponentof the RSA Key. d mod (q-1)
* parameter qi: Base64 URL encoded string representing the first CRT coefficient of the RSA Key. q^-1 mod p

## Tools

https://openid.net/developers/jwt-jws-jwe-jwk-and-jwa-implementations/

