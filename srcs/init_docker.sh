#!/bin/bash

#Start the server, php and the database in the docker
service nginx start
service php7.3-fpm start
service mysql start

#Create a wordpress database and add a new user
echo "CREATE DATABASE wordpress;" | mysql --user root
echo "GRANT ALL ON wordpress.* TO 'user42'@'localhost' IDENTIFIED BY 'password' WITH GRANT OPTION" | mysql --user root

service nginx restart
/bin/bash
