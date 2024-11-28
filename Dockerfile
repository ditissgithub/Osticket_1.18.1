FROM almalinux:8.9

LABEL maintainer="satishg@cdac.in"

# Set environment variables
ENV PORT="YourPort"
ARG PHP_V=8.2
# Install required repositories and PHP modules
RUN dnf -y install \
    https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm \
    https://rpms.remirepo.net/enterprise/remi-release-8.rpm && \
    dnf -y install yum-utils && \
    dnf module reset php && \
    dnf module install -y php:remi-$PHP_V && \
    dnf install -y php php-{mysqlnd,pear,imap,cgi,gettext,common,curl,intl,zip,opcache,apcu,gd,ldap} && \
    dnf clean all

# Install additional tools and osTicket dependencies
RUN dnf -y install curl wget unzip vim initscripts procps-ng supervisor && \
    dnf clean all

ADD upload /upload

# Download and set up osTicket
RUN cd /var/www/html && \
    cp /upload/include/ost-sampleconfig.php /upload/include/ost-config.php && \
    mkdir /var/www/html/support && \
    cp -r /upload/* /var/www/html/support && \
    mkdir -p /run/php-fpm/ && \
    chown -R root:root /run/php-fpm/ && \
    rm -rf /upload

# Copy custom configuration files and scripts
COPY httpd_initscripts /etc/init.d/httpd
COPY support.conf /etc/httpd/conf.d/
COPY supervisord.conf /etc/supervisord.conf
COPY entrypoint.sh /

# Set file permissions
RUN chmod 0666 /var/www/html/support/include/ost-config.php && \
    chmod +x /etc/init.d/httpd && \
    chmod 0644 /etc/httpd/conf.d/support.conf && \
    chmod +x /entrypoint.sh


# Define the entrypoint script
CMD ["/entrypoint.sh"]

