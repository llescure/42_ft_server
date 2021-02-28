#Tell Docker where to start
FROM debian:buster

#Install the needed tools and make sure they are updated
RUN apt-get update && apt-get -y install \
wget \
nginx \
mariadb-server \
php7.3 php-mysql php-fpm php-pdo php-gd php-cli php-mbstring

#Copy the files in srcs to a file root in the docker
COPY ./srcs root/

#Set the directory where to dowload phpmyadmin and wordpress
WORKDIR /var/www/

#Download phpmyadmin
RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.1.0/phpMyAdmin-5.1.0-english.tar.gz
RUN tar -xzvf phpMyAdmin-5.1.0-english.tar.gz
RUN rm -rf phpMyAdmin-5.1.0-english.tar.gz
RUN mv phpMyAdmin-5.1.0-english phpmyadmin

#Download wordpress
RUN wget https://wordpress.org/latest.tar.gz
RUN tar -xzvf latest.tar.gz
RUN rm -rf latest.tar.gz

#Run my .sh with bash that interprets shell command
#CMD bash /root/init_docker.sh
