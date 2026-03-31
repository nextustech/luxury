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

# Install packages
RUN apk add --no-cache \
    nginx \
    bash \
    curl \
    git \
    unzip \
    libzip-dev \
    oniguruma-dev \
    icu-dev

# Install PHP extensions
RUN docker-php-ext-install \
    pdo \
    pdo_mysql \
    zip \
    intl

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working dir
WORKDIR /var/www

# Copy project
COPY . .

# Copy built frontend from stage 1
COPY --from=frontend /app/public/build ./public/build

# Install Laravel deps
RUN composer install --no-dev --optimize-autoloader

# Permissions
RUN chown -R www-data:www-data /var/www \
    && chmod -R 775 storage bootstrap/cache

# Nginx config
COPY docker/nginx.conf /etc/nginx/nginx.conf

# Expose port
EXPOSE 80

# Start services
CMD sh -c "php-fpm -D && nginx -g 'daemon off;'"
