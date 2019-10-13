# ---------------------------------------------------------------------------
# Build Time Arguments
# ---------------------------------------------------------------------------
ARG PHP_VERSION="7.4"
ARG NGINX_VERSION="1.17.4"
ARG NODE_VERSION="12"

# ---------------------------------------------------------------------------
# Composer Build Stage
# ---------------------------------------------------------------------------
FROM szainmehdi/php:${PHP_VERSION}-dev as vendor

WORKDIR /var/www
ENV COMPOSER_ALLOW_SUPERUSER 1

# Quicken Composer Installation by paralleizing downloads
RUN composer global require hirak/prestissimo --prefer-dist

# Copy Dependencies files
COPY composer.json composer.lock ./

RUN composer install -n --no-dev --prefer-dist --no-scripts --no-autoloader
# ---------------------------------------------------------------------------
# Node Build Stage
# ---------------------------------------------------------------------------
FROM szainmehdi/node:${NODE_VERSION} as assets

WORKDIR /var/www
COPY package-lock.json package.json webpack.mix.js ./
COPY resources ./resources
COPY public ./public

RUN npm install && npm run production
# ---------------------------------------------------------------------------
# Final Production Images
# ---------------------------------------------------------------------------
FROM szainmehdi/nginx:${NGINX_VERSION} AS web-prod

COPY public /var/www/public
COPY --from=assets /var/www/public/css /var/www/public/css
COPY --from=assets /var/www/public/js /var/www/public/js
COPY docker/nginx/local.conf /etc/nginx/conf.d/default.conf
VOLUME ["/etc/nginx/certs"]
EXPOSE 80 443

# ---------------------------------------------------------------------------

FROM szainmehdi/php:${PHP_VERSION} as app-prod

ENV COMPOSER_ALLOW_SUPERUSER 1
WORKDIR /var/www
COPY --from=vendor /var/www/vendor /var/www/vendor
COPY --from=vendor /usr/local/bin/composer /usr/local/bin/composer
COPY . .
COPY .env.production .env

RUN composer dump-autoload -n -o --no-dev \
    && composer check-platform-reqs \
    && php artisan config:cache

RUN chown -R www-data: /var/www









