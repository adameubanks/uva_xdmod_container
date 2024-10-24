FROM php:7.4-apache

# Install dependencies and add Sury repository for PHP extensions
RUN apt-get update && apt-get install -y \
    lsb-release \
    apt-transport-https \
    ca-certificates \
    wget \
    gnupg \
    && wget -qO - https://packages.sury.org/php/apt.gpg | apt-key add - \
    && echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/sury-php.list \
    && apt-get update && apt-get install -y \
    libzip-dev \
    unzip \
    tar \
    default-mysql-client \
    expect \
    chromium \
    sendmail \
    nodejs npm \
    libcurl4-openssl-dev \
    libicu-dev \
    libonig-dev # Add this line to install Oniguruma

# Install PHP extensions using docker-php-ext-install
RUN docker-php-ext-install bcmath curl intl mbstring mysqli pdo_mysql zip

# Install GD extension with specific configuration
RUN apt-get install -y libpng-dev libjpeg-dev libfreetype6-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd

# Install APCu using PECL
RUN apt-get install -y gcc make autoconf libc-dev pkg-config \
    && pecl install apcu \
    && docker-php-ext-enable apcu

# Download and install XDMoD
RUN wget https://github.com/ubccr/xdmod/releases/download/v10.5.0-1.0/xdmod-10.5.0-el8.tar.gz \
    && tar -xzvf xdmod-10.5.0-el8.tar.gz \
    && cd xdmod-10.5.0 \
    && ./install --prefix=/opt/xdmod

# Set up XDMoD user and group
RUN groupadd -r xdmod \
    && useradd -r -M -c "Open XDMoD" -g xdmod -d /opt/xdmod/lib -s /sbin/nologin xdmod

# Set permissions
RUN chmod 440 /opt/xdmod/etc/portal_settings.ini \
    && chown www-data:xdmod /opt/xdmod/etc/portal_settings.ini \
    && chmod 750 /opt/xdmod/bin/*

# Add XDMoD bin to PATH
ENV PATH="/opt/xdmod/bin:${PATH}"

# Set the working directory
WORKDIR /opt/xdmod/bin

# Expose port 80
EXPOSE 80

# Copy the Expect script for automating XDMoD setup
COPY setup-xdmod.expect /usr/local/bin/setup-xdmod.expect
RUN chmod +x /usr/local/bin/setup-xdmod.expect

# Run the Apache server and XDMoD setup
CMD ["bash", "-c", "/usr/local/bin/setup-xdmod.expect && apache2-foreground"]