FROM centos:7

# Set our our meta data for this container.
LABEL name="LAP Container for eWAPS"
LABEL vendor="United States Department of Agriculture"

ENV PATH /usr/local/src/vendor/bin/:/usr/local/rvm/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/var/application/vendor/drush/drush:/var/application/docroot/vendor/drush/drush:vendor/drush/drush

# Set TERM env to avoid mysql client error message "TERM environment variable not set" when running from inside the container
ENV TERM xterm

# Fix command line compile issue with bundler.
ENV LC_ALL en_US.utf8

# Install and enable repositories
RUN yum -y update && \
    yum -y install epel-release && \
    yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm && \
    rpm -Uvh https://repo.ius.io/ius-release-el7.rpm && \
    yum -y update

RUN yum -y install \
    curl \
    git \
    mariadb \
    msmtp \
    net-tools \
    python34 \
    gettext \
    vim \
    wget \
    rsync \
    unzip \
    zip \
    gcc \
    gcc-c++ \
    make \
    mod_ssl.x86_64 \
    ImageMagick \
    ghostscript 

#Apache Upgrade 
RUN cd /etc/yum.repos.d && \
    wget https://repo.codeit.guru/codeit.el`rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release)`.repo && \
    yum -y install httpd-2.4.47 && \
    yum -y erase httpd-2.4.6

# Install PHP modules
RUN yum-config-manager --enable remi-php74 && \
  yum -y install \
    php \
    php-cli \
    php-curl \
    php-gd \
    php-imap \
    php-mbstring \
    php-mysqlnd \
    php-odbc \
    php-pear \
    php-pecl-imagick \
    php-pecl-json \
    php-pecl-redis5 \
    php-pecl-memcached \
    php-pecl-uploadprogress \
    php-pecl-apcu \
    php-pecl-zip \
    php-opcache \
    php-bcmath \
    php-xml \
    php-ldap \
    php-devel

RUN pecl install igbinary igbinary-devel redis

# Install misc tools
RUN yum -y install \
    python-setuptools

# Perform yum cleanup
RUN yum -y upgrade && \
    yum clean all

# Install Composer and Drush
RUN curl -sS https://getcomposer.org/installer | php -- \
    --install-dir=/usr/local/bin \
    --filename=composer

# Install Node.js and NPM
RUN yum -y install nodejs

# Install GRUNT tool and CLI tool
RUN npm install grunt@1.3.0 --save-dev
RUN npm install -g grunt-cli

# Disable services management by systemd.
RUN systemctl disable httpd.service

# Apache config, and PHP config, test apache config
# See https://github.com/docker/docker/issues/7511 /tmp usage
COPY public/index.php /var/www/public/index.php
COPY centos-7 /tmp/centos-7/

RUN rsync -a /tmp/centos-7/etc/ /etc/ 

EXPOSE 80 443

# Simple startup script to avoid some issues observed with container restart
ADD conf/run-httpd.sh /run-httpd.sh
RUN chmod -v +x /run-httpd.sh

ADD conf/mail.ini /etc/php.d/mail.ini
RUN chmod 644 /etc/php.d/mail.ini

# RUN rpm -ivh http://repo.okay.com.mx/centos/7/x86_64/release/okay-release-1-5.el7.noarch.rpm && \

CMD ["/run-httpd.sh"]
