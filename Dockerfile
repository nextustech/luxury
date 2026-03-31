# =========================
# Stage 1: Build frontend
# =========================
FROM node:18 AS frontend

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build


# =========================
# Stage 2: PHP + Nginx
# =========================
FROM php:8.2-fpm-alpine

# Install system packages (Alpine)
RUN apk add --no-cache \
    nginx \
    bash \
    curl \
    git \
    unzip \
    libzip-dev \
    oniguruma-dev \
    icu-dev \
    libpng-dev \
    libjpeg-turbo-dev \
    freetype-dev

# Install PHP extensions
RUN docker-php-ext-install \
    pdo \
    pdo_mysql \
    zip \
    intl \
    exif

# Install GD (image support)
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd

# Install dependencies required for pecl_http
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libevent-dev \
    pkg-config \
    libssl-dev

# Install required PECL extensions
RUN pecl install raphf \
    && docker-php-ext-enable raphf

RUN pecl install pecl_http \
    && docker-php-ext-enable http
    
# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www

# Copy project files
COPY . .

# Copy built frontend
COPY --from=frontend /app/public/build ./public/build

# Install Laravel dependencies
RUN composer install --no-dev --optimize-autoloader

# Set correct permissions
RUN chown -R www-data:www-data /var/www \
    && chmod -R 775 storage bootstrap/cache

# Copy Nginx config
COPY docker/nginx.conf /etc/nginx/nginx.conf

# Expose port
EXPOSE 80

# Start PHP-FPM + Nginx
CMD ["sh", "-c", "php-fpm -D && nginx -g 'daemon off;'"]
