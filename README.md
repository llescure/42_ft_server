# 42_ft_server

Discover Docker, Nginx, MySQL

Useful command in shell:

* Build a docker image from a Dockerfile

docker build -t <your image name> <your Dockerfile dir>

* Start an instance of a docker image

docker run -it <your image name>

* Really important if you want to bind some ports on the container to your own computer, use -p option.

docker run -it -p 80:80

* See all images

docker images

* Remove images

docker rmi <image>

* Delete all images

docker rmi $(docker images -a -q)

* Remove a container

docker rm <ID or container name>

* See running containers

docker ps

* List all docker containers (running and stopped).

docker ps -a

* Delete all unused Docker images and cache and free space

docker system prune

------------------------------------------

## Step 1: Make sure docker is installed and that you have the correct permissions
If you get the following error:
> Got permission denied while trying to connect to the Docker daemon socket. 

Use: ` 666 /var/run/docker.sock`

If you have downloaded 42 vm use the following command: `sudo systemctl stop ngnix`
A nginx docker is already running when you download 42 VM

## Step 2: Specify where the docker should run
The subject specifies that the container should run with Debian Buster.  
To do so we have to specifiy in the DockerFile the following command : `FROM debian:buster`

## Step 3 : Install the necessary package 
The -y flag stands for yes and will automatically accept the installation

`RUN apt-get update && apt-get install -y
wget \ #to be able to download phpmyadmin and wordpress
nginx \ #for the server
mariadb-server \ #to launch a sql database
openssl \ #to generate a ssl certificate
php7.3 php-mysql php-fpm php-pdo php-gd php-cli php-mbstring \ #to launch php`

## Step 4: Set nginx
Copy the file default that you can find at etc/nginx/sites-available, in your repository srcs

Edit it following the [official documentation](http://nginx.org/en/docs/beginners_guide.html)

Copy the new file in srcs in you docker: `COPY srcs/[name of the nginx config file] /etc/nginx/sites-enabled`

Create a symbolic link between /etc/nginx/sites-enabled and /etc/nginx/sites-available: `RUN ln -s /etc/nginx/sites-available/nginx_config /etc/nginx/sites-enabled`

Remove the old files default : `RUN rm -rf /etc/nginx/sites-enabled/default` and `RUN rm -rf /etc/nginx/sites-enabled/default`

## Step 5: Set the ssl certificate
Use openssl dowloaded precedently to generate a certificate
`RUN openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out /etc/ssl/localhost.pem -keyout /etc/ssl/localhost.key -subj "/C=FR/ST=Paris/L=Paris/O=42 School/OU=llescure/CN=localhost"`

Don't forget to update your nginx config file

	# SSL configuration
	ssl on;
	ssl_certificate /etc/ssl/localhost.pem;
	ssl_certificate_key /etc/ssl/localhost.key;

## Step 6: Download and set phpmyadmin
Download a phpmyadmin version. I chose 4.9.2
`RUN wget https://files.phpmyadmin.net/phpMyAdmin/4.9.2/phpMyAdmin-4.9.2-english.tar.gz
RUN tar -xzvf phpMyAdmin-4.9.2-english.tar.gz
RUN rm -rf phpMyAdmin-4.9.2-english.tar.gz
RUN mv phpMyAdmin-4.9.2-english phpmyadmin`

Edit the config file config.inc.php as done [here](https://forhjy.medium.com/42-ft-server-how-to-install-lemp-wordpress-on-debian-buster-by-using-dockerfile-2-4042adb2ab2c)

Don't forget to generate a blobfish secret [here](https://phpsolved.com/phpmyadmin-blowfish-secret-generator/)

Copy the edited files in /var/www/phpmyadmin: `COPY srcs/config.inc.php /var/www/phpmyadmin`

Give the rights of the directory : `RUN chown -R www-data: /var/www/phpmyadmin`

## Step 7: Download and set wordpress
Download the latest version of wordpress
`RUN wget https://wordpress.org/latest.tar.gz
RUN tar -xzvf latest.tar.gz
RUN rm -rf latest.tar.gz`

Edit the config file wp-config.php as done [here](https://forhjy.medium.com/42-ft-server-how-to-install-lemp-wordpress-on-debian-buster-by-using-dockerfile-2-4042adb2ab2c)

Don't forget to generate the unique keys [here](https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service)

Copy the edited files in /var/www/wordpress: `COPY srcs/wp-config.php /var/www/wordpress`

Give the rights of the directory : `RUN chown -R www-data: /var/www/wordpress`

## Step 8: Run the services and create a mysql database

Create a file.sh in srcs where you will ask the docker to run nginx service, php service and mysql service
`service nginx start
service php7.3-fpm start
service mysql start`

Use this [tuto] to understand mysql 

Don't forget to add this line at the beggining of your file: `#!/bin/bash` and this one at the end of your file.sh : `/bin/bash`

It will tell the program to interpet the following code with bash.

## Step 9: Set a file.sh which can disable autoindex while the docker is running
We will edit the nginx config file by setting autoindex to off. Remember we set it to on previously.

`if grep "autoindex on" /etc/nginx/sites-enabled/nginx_config; then
	echo "turning off autoindex"
	sed -i 's/autoindex on/autoindex off/' /etc/nginx/sites-enabled/nginx_config
fi
nginx -s reload`

Please note you can use either sites-enabled or sites-available since they are linked by a symbolic link.

If you turn off the autoindex when you type http://localhost and http://localhost/html on your web browser you should see a 403 error
