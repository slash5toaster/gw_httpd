# gw_httpd

Docker container serving [geneweb](https://github.com/geneweb/geneweb)

Using apache httpd 2.4 with a custom cgi

The container will have a default set of configs that expose the cgi

Bind geneweb database to /opt/geneweb/bases/

and you can override the configs by binding to /usr/local/apache2/conf/

```
docker run \
       -p ${EXPOSED_PORT}:80 \
       -p 2316:2316 \
       -p 2317:2317 \
       -v ${MOUNTDIR}/cgi-bin/:/usr/local/apache2/cgi-bin/ \
       -v ${MOUNTDIR}/conf/:/usr/local/apache2/conf/ \
       -v ${MOUNTDIR}/logs/:/usr/local/apache2/logs/ \
       -v ${MOUNTDIR}/public-html/:/usr/local/apache2/htdocs/ \
       -v ${MOUNTDIR}/bases/:/opt/geneweb/bases/ \
       gw-httpd
```
