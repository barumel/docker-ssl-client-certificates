# nginx-client-certificates
Nginx container used to generate client certificates.

This container is not meant to be used as nginx server. It only handles the server and client certificate generation.

To use it, create a volume that holds the data from SSL_CA_DIR and link it to your container.

# Usage
See the provided docker-compose.yml file for a usage example.


## Volume
To use the genreted ssl certificates, link the SSL_CA_DIR into your container.

```
volumes:
 - ca:/etc/ssl/ca
```


## Nginx configuration
Add the following lines to your nginx configuration file:

```
ssl_client_certificate /etc/ssl/ca/certs/ca.crt;
ssl_verify_client on;
```


# Enviroment variables
```
// Passphrase to generate the server certificate
ENV PASSPHRASE MwpHtTSDaEcAxkXGQyPtaGm5

// Country used in certificat subject
ENV COUNTRY CH

// State used in certificat subject
ENV STATE Neuchatel

// Locality used in certificat subject
ENV LOCALITY La Sagne

// Organization used in certificat subject
ENV ORGANIZATION Example Org

// Organizational unit used in certificat subject
ENV ORGANIZATIONAL_UNIT Example Unit

// Common name used in certificat subject
ENV COMMON_NAME example.ch

// Comma separated list of clients (users). A client certificate will be generated for each user at startup
ENV SSL_CLIENT_CERTIFICATES_FOR foo,bar

// Number of days the server certificate is valid
ENV SSL_SERVER_CERT_DURATION 365

// Number of days the client certificates are valid
ENV SSL_CLIENT_CERT_DURATION 365

// Passphrase for client certificates
ENV SSL_CLIENT_PASSPHRASE Ku7vLMPdWEpcJsZMGgqHmyKg

// Base SSL directory (where everything is stored).
ENV SSL_CA_DIR /etc/ssl/ca
```


# Scripts
A new client certificate can be generated on the fly (whitout adding it to the SSL_CLIENT_CERTIFICATES_FOR env variable).

```
docker run -it <<CONTAINER_ID>> /usr/local/bin/create-client-cert.sh -u <<USER>> -p <<PASSPHRASE>>
```


Certificates generated this way will be lost if you don't use a volume for your SSL_CA_DIR.

As this container should not be used to serve files, you will probably do that to be able to link the SSL_CA_DIR into your nginx container.

# Openssl configuration
If you want to use another openssl.cnf than the provided one, link it to your container.

```
volumes:
  - <<PATH_TO_YOUR_OPENSSL_CNF>>:/etc/ssl/openssl.cnf
```


Make sure you set the correct ```SSL_CA_DIR``` env variable to be able to generate the server certificate.


# docker-compose
The provided docker-compose file is an example. Make sure that you replace the required environment variables before use.


To be able to access the generated client certificates, you have to create a folder "certificates" in the main dir.


If you dont want to link a local folder to the container, you can also use ```docker container cp``` to get the certificates:

```
docker container cp <<CONTAINER>>:/etc/ssl/ca/export/* .
```
