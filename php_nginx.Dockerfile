################## php_nginx ##################
FROM ghcr.io/vkoori/php:8.4-fpm-alpine3.22 AS php_nginx

# Install and config Nginx
RUN apk update && apk add --no-cache \
    nginx \
    nginx-mod-http-vts \
    && rm -rf /var/cache/apk/* \
    && chown -R www-data:www-data /var/lib/nginx \
    && sed -i 's/user nginx;/user www-data;/' /etc/nginx/nginx.conf \
    && sed -i 's/client_header_buffer_size/# client_header_buffer_size/' /etc/nginx/nginx.conf \
    && sed -i '/^http {/a \    client_header_buffer_size 8k;' /etc/nginx/nginx.conf \
    && sed -i '/^http {/a \    vhost_traffic_status_zone;' /etc/nginx/nginx.conf \
    && sed -i '/^http {/a \    fastcgi_read_timeout 300;' /etc/nginx/nginx.conf \
    && sed -i '/^http {/a \    proxy_read_timeout 300;' /etc/nginx/nginx.conf \
    && sed -i 's/#gzip on;/gzip on;/' /etc/nginx/nginx.conf \
    && sed -i '/^http {/a \    log_format access '\''$remote_addr - $remote_user [$time_local] "$request" '\''\n                 '\''$status $body_bytes_sent "$http_referer" '\''\n                 '\''"$http_user_agent" "$http_x_forwarded_for" '\''\n                 '\''$request_time'\'';' /etc/nginx/nginx.conf \
    && sed -i 's/access_log \/var\/log\/nginx\/access.log main;/access_log \/var\/log\/nginx\/access.log access;/' /etc/nginx/nginx.conf

# update PHP-fpm configuration
RUN touch /var/run/fpm.sock \
    && chown www-data:www-data /var/run/fpm.sock \
    && sed -i 's/listen/;listen/' /usr/local/etc/php-fpm.d/zz-docker.conf \
    && echo 'listen = /var/run/fpm.sock' >> /usr/local/etc/php-fpm.d/zz-docker.conf \
    && echo 'listen.owner = www-data' >> /usr/local/etc/php-fpm.d/zz-docker.conf \
    && echo 'listen.group = www-data' >> /usr/local/etc/php-fpm.d/zz-docker.conf \
    && echo 'listen.mode = 0660' >> /usr/local/etc/php-fpm.d/zz-docker.conf \
    && echo 'pm.status_path = /php-fpm' >> /usr/local/etc/php-fpm.d/zz-docker.conf
