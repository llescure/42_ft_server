#Tell Docker where to start
FROM debian:buster

#Install the needed tools and make sure they are updated
RUN apt-get update && apt-get -y install \
wget \
nginx \
mariadb-server \
php7.3 php-mysql php-fpm php-pdo php-gd php-cli php-mbstring

#Set nginx congif
COPY srcs/nginx_config /etc/nginx/sites-available
RUN ln -s /etc/nginx/sites-available/nginx_config /etc/nginx/sites-enabled
RUN rm -rf /etc/nginx/sites-enabled/default
RUN rm -rf /etc/nginx/sites-available/default

#Set the directory where to download phpmyadmin and wordpress
#WORKDIR /var/www/html

#Download phpmyadmin
#RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.1.0/phpMyAdmin-5.1.0-english.tar.gz
#RUN tar -xzvf phpMyAdmin-5.1.0-english.tar.gz
#RUN rm -rf phpMyAdmin-5.1.0-english.tar.gz
#RUN mv phpMyAdmin-5.1.0-english phpmyadmin
#COPY srcs/php_config.php /var/www/html/phpmyadmin

#Download wordpress
#RUN wget https://wordpress.org/latest.tar.gz
#RUN tar -xzvf latest.tar.gz
#RUN rm -rf latest.tar.gz
#COPY srcs/wordpress_config.php /var/www/html/wordpress

#Give permission to nginx
#RUN chown -R www-data:www-data /var/www/html/*

#Specify the port
#EXPOSE 80 443

#Run my .sh with bash that interprets shell command
#COPY srcs/init_docker.sh ./
#CMD bash init_docker.sh
