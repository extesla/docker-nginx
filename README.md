

* see: http://wiki.nginx.org/Symfony
* see: http://www.farinspace.com/nginx-virtual-host/
* see: http://blog.sgconsulting.it/2010/12/02/running-symfony-on-nginx.html
* see: http://ihaveabackup.net/2012/11/17/nginx-configuration-for-symfony2/

If you want to run the nginx server manually (without linking):
```
$ docker run -it --rm -h localhost -v /vagrant/tools/docker/nginx/localhost/sites-enabled:/etc/nginx/sites-enabled -v /vagrant/resources/certificates/cacert.org:/data/ssl/certs -v /vagrant/wwwroot:/data/web -v /logs:/var/log/nginx  -p 80:80 -p 443:443 lorecall/nginx /bin/bash
```

We need to modify the /etc/nginx/nginx.conf and include the line:
```
include /etc/nginx/sites-enabled/*;
```
```
location / {
  # If file exists as is static serve it directly
  if (-f $request_filename) {
    expires max;
    break;
  }
  if ($request_filename !~ "\.(js|ico|gif|jpg|png|css)$") {
    rewrite ^(.*) /app_dev.php last;
  }
}

location ~ \.php($|/) {
  set $script     $uri;
  set $path_info  "";
  if ($uri ~ "^(.+\.php)($|/)") {
    set $script $1;
  }
  if ($uri ~ "^(.+\.php)(/.+)") {
    set $script     $1;
    set $path_info  $2;
  }

  #fastcgi_pass   127.0.0.1:9000;

  #include /etc/nginx/fastcgi_params;

  #fastcgi_param  SCRIPT_FILENAME  /data/web/web$script;
  #fastcgi_param  PATH_INFO        $path_info;
}
```



`SYMFONY_CACHE_DIR` and `SYMFONY_LOGS_DIR`
