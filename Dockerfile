# Используем официальный образ PHP с поддержкой Apache
FROM php:8.3-apache

# Устанавливаем необходимые расширения PHP
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    unzip \
    git \
    mc \
    npm  \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd \
    && docker-php-ext-install zip \
    && docker-php-ext-install pdo pdo_mysql



# Устанавливаем Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
RUN pecl install xdebug \
    && docker-php-ext-enable xdebug
# Копируем код приложения в контейнер
COPY app /var/www/html

# Устанавливаем рабочую директорию
WORKDIR /var/www/html

# Устанавливаем зависимости Laravel
RUN composer install
# Устанавливаем права доступа
RUN #chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Настраиваем виртуальный хост (опционально)
#COPY ./000-default.conf /etc/apache2/sites-available/000-default.conf

# Включаем модуль mod_rewrite
RUN a2enmod rewrite

# Открываем порт 80
EXPOSE 80