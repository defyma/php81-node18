# Use the official Ubuntu 22.04 image as the base image
FROM ubuntu:22.04

# Set the DEBIAN_FRONTEND environment variable to noninteractive
ARG DEBIAN_FRONTEND=noninteractive

# Update the package repository and install the necessary packages
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y software-properties-common curl gnupg

# Install Node.js 18, Yarn Package Manager, and the required PHP modules
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
RUN add-apt-repository -y ppa:ondrej/php
RUN apt-get update && apt-get install -y php8.1 libapache2-mod-php8.1 php8.1-pgsql nodejs \
  php8.1-mysqlnd php8.1-bcmath php8.1-gd php8.1-intl php8.1-ldap php8.1-mbstring \
  php8.1-pdo php8.1-soap php8.1-opcache php8.1-xml php8.1-gmp \
  php8.1-zip php8.1-apcu php8.1-bz2 php8.1-curl php8.1-sqlite3 php8.1-pdo-sqlite \
    nano php8.1-xdebug

# Yarn Package Manager
RUN npm i -g corepack && corepack enable  && corepack prepare yarn@stable --activate

# Configure Apache to use PHP
RUN a2enmod php8.1
RUN sed -i 's/index.html/index.php/g' /etc/apache2/mods-enabled/dir.conf

# Enable the mod_rewrite module in Apache
RUN a2enmod rewrite

# Allow .htaccess files to override configuration settings
RUN sed -i 's/AllowOverride None/AllowOverride All/g' /etc/apache2/apache2.conf

# Configure Apache to listen on all IP addresses on port 8080
RUN echo "Listen 0.0.0.0:8080" >> /etc/apache2/ports.conf
RUN echo "Listen 0.0.0.0:8443" >> /etc/apache2/ports.conf

# Config php.ini display_errors On
RUN sed -i 's/display_errors = Off/display_errors = On/g' /etc/php/8.1/apache2/php.ini

# Expose the custom Apache ports
EXPOSE 8080
EXPOSE 8443

# Log to stdout
RUN ln -sf /dev/stdout /var/log/apache2/access.log
RUN ln -sf /dev/stdout /var/log/apache2/other_vhosts_access.log
RUN ln -sf /dev/stderr /var/log/apache2/error.log

# Start Apache
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
