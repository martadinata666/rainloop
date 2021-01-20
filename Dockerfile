FROM alpine:latest
WORKDIR /var/www/localhost/htdocs/

# Download master zip and copy apache, php conf
ADD  https://www.rainloop.net/repository/webmail/rainloop-community-latest.zip /var/www/localhost/htdocs/
COPY ./php.ini /etc/php7/php.ini
COPY ./httpd.conf /etc/apache2/httpd.conf

# Add applications and extract
RUN apk add  --no-cache nano apache2 unzip php7-apache2 php7-json php7-dom php7-curl php7-iconv php7-openssl php7-pdo_sqlite apache2-ssl bash
RUN unzip rainloop-community-latest.zip -d /var/www/localhost/htdocs/

# Set permission
RUN adduser --disabled-password --uid 1000 rainloop
RUN chown -R rainloop:rainloop /var/www/localhost/htdocs/

# Clean index and zip
RUN rm /var/www/localhost/htdocs/index.html
RUN rm /var/www/localhost/htdocs/rainloop-community-latest.zip

# Show port
EXPOSE 80
EXPOSE 443

# default user
USER rainloop

# HEALTHCHECK
#HEALTHCHECK --interval=5m --timeout=3s \
#  CMD curl -f http://localhost/ || exit 1

# Execute command
CMD /usr/sbin/httpd -DFOREGROUND -E /var/www/localhost/htdocs/httpd-logs.txt

#CMD /usr/bin/bash
