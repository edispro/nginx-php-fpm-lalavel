user $NGINX_USER;
worker_processes auto;
pid /run/nginx.pid;

events {
	worker_connections 20000;
	use                 epoll;
	multi_accept        on;

}

http {
	sendfile on;
	tcp_nopush on;
	tcp_nodelay on;
	keepalive_timeout 65;
	types_hash_max_size 2048;
	client_header_timeout 3m;
	client_body_timeout 3m;
	client_max_body_size 256m;
	client_header_buffer_size 4k;
	client_body_buffer_size 256k;
	large_client_header_buffers 4 32k;
	send_timeout 3m;
	reset_timedout_connection       on;
	server_names_hash_max_size 1024;
	server_names_hash_bucket_size 1024;
	ignore_invalid_headers on;
	connection_pool_size 256;
	request_pool_size 4k;
	output_buffers 4 32k;
	postpone_output 1460;

fastcgi_buffer_size 128k;
fastcgi_buffers 256 16k;
fastcgi_busy_buffers_size 256k;
fastcgi_temp_file_write_size 256k;
fastcgi_send_timeout 120;
fastcgi_read_timeout 120;
fastcgi_intercept_errors on;
fastcgi_param HTTP_PROXY "";

	include /etc/nginx/mime.types;
	default_type application/octet-stream;

	ssl_protocols TLSv1 TLSv1.1 TLSv1.2; # Dropping SSLv3, ref: POODLE
	ssl_prefer_server_ciphers on;

	access_log /var/log/nginx/access.log;
	error_log /var/log/nginx/error.log;
	access_log off;
	gzip on;
	gzip_disable "msie6";

	include /etc/nginx/conf.d/*.conf;
	#include /etc/nginx/sites-enabled/*;

	server {
		listen 80  default_server;
		root $NGINX_WEB_ROOT;

		location / {
		    try_files $uri $NGINX_PHP_FALLBACK$is_args$args;
		}
		location ~ $NGINX_PHP_LOCATION {
		    fastcgi_pass unix:$PHP_SOCK_FILE;
		    fastcgi_split_path_info ^(.+\.php)(/.*)$;
		    include fastcgi_params;
		    fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
		    fastcgi_param DOCUMENT_ROOT $realpath_root;

		    internal;
		}

		# return 404 for all other php files not matching the front controller
		# this prevents access to other php files you don't want to be accessible.
		location ~ \.php$ {
		  return 404;
		}
    	}
}
