FROM php:8.0.2-fpm

#setting the arguments defined in docker-compose.yaml
ARG slag
ARG 1000

# Installation of the system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Installation of PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Getting latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Creating the system user to run Composer and Artisan Commands
RUN useradd -G www-data,root -u $uid -d /home/$user $user
RUN mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user

# Setting the working directory
WORKDIR /var/www

USER $user
