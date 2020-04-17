# Usage with nginx-proxy
This container can be used together with [nginx-proxy](https://github.com/nginx-proxy/nginx-proxy).

## Configuration

### Nginx

Create a file ```custom.conf``` and add the following lines to it:


```
ssl_client_certificate /etc/ssl/ca/certs/ca.crt;
ssl_verify_client on;
```

Then link the file to the proxy container:

```
./custom.conf:/etc/nginx/conf.d/my_proxy.conf:ro
```

### Openssl
You can also overwrite the openssl configuration by linking an openssl.cnf file to both containers:

```
./openssl.cnf:/etc/ssl/openssl.cnf
```
