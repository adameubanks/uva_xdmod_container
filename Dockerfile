FROM php:7.4-apache

# Install system dependencies, including expect
RUN apt-get update && apt-get install -y \
    libzip-dev \
    unzip \
    wget \
    tar \
    default-mysql-client \
    expect \
    && docker-php-ext-install zip pdo_mysql mysqli

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

# Automate the XDMoD setup using expect
COPY setup-xdmod.expect /usr/local/bin/setup-xdmod.expect
RUN chmod +x /usr/local/bin/setup-xdmod.expect

# Run the Apache server and XDMoD setup
CMD ["bash", "-c", "/usr/local/bin/setup-xdmod.expect && apache2-foreground"]
