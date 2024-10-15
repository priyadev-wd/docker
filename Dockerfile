# Dockerfile

FROM php:7.4-apache

# Enable Apache Rewrite Module
RUN a2enmod rewrite

# Install dependencies
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libicu-dev \
    libzip-dev \
    zip \
    unzip \
    g++ \
    && docker-php-ext-configure intl \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql zip intl

    # Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer


# Install PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install gd pdo pdo_mysql zip

# Set the working directory
WORKDIR /var/www/html

# Copy project files into the container
COPY . /var/www/html

# Grant proper permissions to storage and logs directories (CakePHP-specific)
RUN chown -R www-data:www-data /var/www/html/tmp /var/www/html/logs

# Expose port 80 to access the application
EXPOSE 80

# Update Composer
RUN composer self-update
