[www]

pm = dynamic
pm.max_children = 1000
pm.max_requests = 1000
pm.start_servers = 20
pm.min_spare_servers = 10
pm.max_spare_servers = 1000
pm.process_idle_timeout = 20s
clear_env = no
catch_workers_output=yes

user = $PHP_USER
group = $PHP_GROUP
listen = $PHP_SOCK_FILE
listen.owner = $PHP_USER
listen.group = $PHP_GROUP
listen.mode = $PHP_MODE

rlimit_files = 131072
rlimit_core = unlimited

