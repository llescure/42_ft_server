if grep "autoindex on" /etc/nginx/sites-enabled/nginx_config; then
	echo "turning off autoindex"
	sed -i 's/autoindex on/autoindex off/' /etc/nginx/sites-enabled/nginx_config
fi
nginx -s reload
