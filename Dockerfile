# Gunakan image resmi PHP 8.2
FROM php:8.2-fpm

# Update dan install dependensi yang dibutuhkan
RUN apt-get update && apt-get install -y \
    libzip-dev \
    zip \
    unzip \
    git \
    && docker-php-ext-install pdo_mysql zip

# Instal Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set working directory
WORKDIR /var/www/html

# Copy source code ke dalam container
COPY . /var/www/html

# Install dependencies menggunakan Composer
RUN composer install
RUN composer update
# Set permission untuk storage dan cache Laravel
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
RUN chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Expose port 9000 dan jalankan PHP-FPM
#EXPOSE 9000
#CMD ["php-fpm"]

CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]