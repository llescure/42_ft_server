#Start the server, php and the database in the docker
start service nginx
start service php7.3-fpm start
start service mysql

#Initialize nginx : copy the new file nginx_config into the server + create a link between sites-available and sites-enabled + delete the default file
cp root/nginx_config /etc/nginx/sites-available/nginx_config
ln -s /etc/nginx/sites-available/nginx_config /etc/nginx/sites-enabled/nginx_config
rm -rf /etc/nginx/sites-enabled/default
rm -rf /etc/nginx/sites-available/default

#Create a wordpress database and add a new user
echo "CREATE DATABASE wordpress_db;" | mysql --user root
echo "GRANT ALL ON wordpress_db.* TO 'user42'@'localhost' IDENTIFIED BY 'user42' WITH GRANT OPTION" | mysql --user root
echo "FLUSH PRIVILEGES" | mysql --user root
