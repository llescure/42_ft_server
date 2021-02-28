#Tell Docker where to start
FROM debian:buster

#Check update
RUN apt-get update && apt-get -y install \
nginx \
mariadb-server \
php7.3 php-mysql php-fpm php-pdo php-gd php-cli php-mbstring

COPY ./srcs root/
