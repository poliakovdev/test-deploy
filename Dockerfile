FROM php:8.5-fpm

# ----------------------------
# System dependencies
# ----------------------------
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    curl \
    libzip-dev \
    libpq-dev \
    libicu-dev \
    libonig-dev \
    && docker-php-ext-install \
        pdo \
        pdo_pgsql \
        zip \
        intl \
        mbstring

# ----------------------------
# Composer
# ----------------------------
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# ----------------------------
# Workdir
# ----------------------------
WORKDIR /var/www

# ----------------------------
# Copy project
# ----------------------------
COPY . .

# ----------------------------
# Install dependencies
# ----------------------------
RUN composer install --no-dev --optimize-autoloader

# ----------------------------
# Permissions (Laravel fix)
# ----------------------------
RUN chown -R www-data:www-data /var/www \
    && chmod -R 775 storage bootstrap/cache

# ----------------------------
# Start PHP-FPM
# ----------------------------
CMD ["php-fpm"]
