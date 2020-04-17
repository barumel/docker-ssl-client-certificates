# Usage with nginx-proxy
This container can be used together with [nginx-proxy](https://github.com/nginx-proxy/nginx-proxy).


For a detailed explanation read the readme in the nginx-proxy repo.  

## Configuration

### Nginx

Create a file ```custom.conf``` and add the following lines to it:


```
ssl_client_certificate /etc/ssl/ca/certs/ca.crt;
ssl_verify_client on;
```

Then link the file to the proxy container:

```
volumes:
 - ./custom.conf:/etc/nginx/conf.d/my_proxy.conf:ro
```

### Openssl
You can also overwrite the openssl configuration by linking an openssl.cnf file to both containers:

```
volumes:
 - ./openssl.cnf:/etc/ssl/openssl.cnf
```

# Usage with letsencrypt
There is a handy companion container for the nginx-proxy - [letsencrypt-nginx-proxy-companion](https://github.com/nginx-proxy/docker-letsencrypt-nginx-proxy-companion). (see the repo for a detailed explanation)

To use it together with client certificates, add the following lines to your docker-compose.yml

```
nginx-proxy-letsencrypt:
    image: jrcs/letsencrypt-nginx-proxy-companion
    volumes_from:
      - nginx-proxy
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
    environment:
      - "DEFAULT_EMAIL=<<YOUR_SUPPORT_EMAIL_ADDRESS>>"
```


You will also have to add the following volumes to the nginx-proxy service:

```
volumes:
     - /etc/nginx/certs
     - /etc/nginx/vhost.d
     - /usr/share/nginx/html
```
