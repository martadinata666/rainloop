FROM alpine:3.13
WORKDIR /var/www/localhost/htdocs/
ARG RELEASE=1.15.0
# Download master zip and copy apache, php conf
ADD https://github.com/RainLoop/rainloop-webmail/releases/download/v$RELEASE/rainloop-$RELEASE.zip /var/www/localhost/htdocs/
COPY ./php.ini /etc/php7/php.ini
COPY ./httpd.conf /etc/apache2/httpd.conf

# Add applications and extract
RUN apk add  --no-cache nano apache2 unzip php7-apache2 php7-json php7-dom php7-curl php7-iconv php7-openssl php7-pdo_sqlite apache2-ssl bash
RUN unzip rainloop-$RELEASE.zip -d /var/www/localhost/htdocs/

# Set permission
RUN adduser --disabled-password --uid 1000 rainloop
RUN chown -R rainloop:rainloop /var/www/localhost/htdocs/

# Clean index and zip
RUN rm /var/www/localhost/htdocs/index.html
RUN rm /var/www/localhost/htdocs/rainloop-$RELEASE.zip

# Show port
EXPOSE 80
EXPOSE 443

# HEALTHCHECK
#HEALTHCHECK --interval=5m --timeout=3s \
#  CMD curl -f http://localhost/ || exit 1

# Execute command
CMD /usr/sbin/httpd -DFOREGROUND -f /etc/apache2/httpd.conf

# User
#User rainloop

# Volume
VOLUME /var/www/localhost/htdocs
