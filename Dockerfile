FROM alpine:latest
WORKDIR /var/www/localhost/htdocs/
ADD  https://www.rainloop.net/repository/webmail/rainloop-community-latest.zip /var/www/localhost/htdocs/
COPY ./php.ini /etc/php7/php.ini
COPY ./httpd.conf /etc/apache2/httpd.conf
RUN apk add  --no-cache nano apache2 unzip php7-apache2 php7-json php7-dom php7-curl php7-iconv php7-openssl php7-pdo_sqlite apache2-ssl bash
RUN unzip rainloop-community-latest.zip -d /var/www/localhost/htdocs/
RUN adduser --disabled-password --uid 1000 rainloop
RUN rm /var/www/localhost/htdocs/index.html
RUN rm /var/www/localhost/htdocs/rainloop-community-latest.zip
EXPOSE 443
CMD /usr/sbin/httpd -DFOREGROUND -f /etc/apache2/httpd.conf
#CMD /usr/bin/bash
