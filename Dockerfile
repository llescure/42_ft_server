#Tell Docker where to start
FROM debian:buster

#Install the needed tools and make sure they are updated
RUN apt-get update && apt-get -y install \
wget \
nginx \
mariadb-server \
openssl \
php7.3 php-mysql php-fpm php-pdo php-gd php-cli php-mbstring

#Set nginx congif
COPY srcs/nginx_config /etc/nginx/sites-available
RUN ln -s /etc/nginx/sites-available/nginx_config /etc/nginx/sites-enabled
RUN rm -rf /etc/nginx/sites-enabled/default
RUN rm -rf /etc/nginx/sites-available/default

#Generate a SSL certificate
RUN openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out /etc/ssl/localhost.pem -keyout /etc/ssl/localhost.key -subj "/C=FR/ST=Paris/L=Paris/O=42 School/OU=llescure/CN=localhost"

#Set the directory where to download phpmyadmin and wordpress
WORKDIR /var/www/

#Download phpmyadmin
RUN wget https://files.phpmyadmin.net/phpMyAdmin/4.9.2/phpMyAdmin-4.9.2-english.tar.gz
RUN tar -xzvf phpMyAdmin-4.9.2-english.tar.gz
RUN rm -rf phpMyAdmin-4.9.2-english.tar.gz
RUN mv phpMyAdmin-4.9.2-english phpmyadmin
COPY srcs/config.inc.php /var/www/phpmyadmin
RUN chown -R www-data: /var/www/phpmyadmin

#Download wordpress
RUN wget https://wordpress.org/latest.tar.gz
RUN tar -xzvf latest.tar.gz
RUN rm -rf latest.tar.gz
COPY srcs/wp-config.php /var/www/wordpress
RUN chown -R www-data: /var/www/wordpress

#Give permission to nginx
WORKDIR /.
#RUN chown -R www-data:www-data /var/www/*

#Specify the port
EXPOSE 80 443

#Run my .sh with bash that interprets shell command
COPY srcs/*.sh ./
CMD bash init_docker.sh
