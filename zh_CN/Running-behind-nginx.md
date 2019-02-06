# 通过Nginx访问Netdata

要通过Nginx访问Netdata，请使用以下配置文件：

### 作为一个虚拟主机

```
upstream backend {
    # the netdata server
    server 127.0.0.1:19999;
    keepalive 64;
}

server {
    # nginx listens to this
    listen 80;

    # the virtual host name of this
    server_name netdata.example.com;

    location / {
        proxy_set_header X-Forwarded-Host $host;
        proxy_set_header X-Forwarded-Server $host;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_pass http://backend;
        proxy_http_version 1.1;
        proxy_pass_request_headers on;
        proxy_set_header Connection "keep-alive";
        proxy_store off;
    }
}
```

### 作为已有虚拟主机的子文件夹

```
upstream netdata {
    server 127.0.0.1:19999;
    keepalive 64;
}

server {
   listen 80;

   # the virtual host name of this subfolder should be exposed
   #server_name netdata.example.com;

   location = /netdata {
        return 301 /netdata/;
   }

   location ~ /netdata/(?<ndpath>.*) {
        proxy_redirect off;
        proxy_set_header Host $host;

        proxy_set_header X-Forwarded-Host $host;
        proxy_set_header X-Forwarded-Server $host;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_http_version 1.1;
        proxy_pass_request_headers on;
        proxy_set_header Connection "keep-alive";
        proxy_store off;
        proxy_pass http://netdata/$ndpath$is_args$args;

        gzip on;
        gzip_proxied any;
        gzip_types *;
    }
}
```

### 通过一个Nginx访问多个Netdata服务器

```
upstream backend-server1 {
    server 10.1.1.103:19999;
    keepalive 64;
}
upstream backend-server2 {
    server 10.1.1.104:19999;
    keepalive 64;
}

server {
    listen 80;

    # the virtual host name of this subfolder should be exposed
    #server_name netdata.example.com;

    location ~ /netdata/(?<behost>.*)/(?<ndpath>.*) {
        proxy_set_header X-Forwarded-Host $host;
        proxy_set_header X-Forwarded-Server $host;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_http_version 1.1;
        proxy_pass_request_headers on;
        proxy_set_header Connection "keep-alive";
        proxy_store off;
        proxy_pass http://backend-$behost/$ndpath$is_args$args;

        gzip on;
        gzip_proxied any;
        gzip_types *;
    }

    # make sure there is a trailing slash at the browser
    # or the URLs will be wrong
    location ~ /netdata/(?<behost>.*) {
        return 301 /netdata/$behost/;
    }
}
```

当然，您可以根据需要添加任意数量的后端服务器。

使用上面的方法，您可以访问后端服务器上的Netdata，下面是使用方法：

- 通过链接`http://nginx.server/netdata/server1/`来访问`backend-server1`
- 通过链接`http://nginx.server/netdata/server2/`来访问`backend-server2`


### 启用身份验证

创建身份验证文件以启用Nginx基本身份验证。不使用SSL/TLS时请不要使用身份验证！
如果您没有这一个文件，您可以通过以下命令创建一个：

```
printf "yourusername:$(openssl passwd -apr1)" > /etc/nginx/passwords
```

并在服务器配置文件中启用身份验证：

```
server {
    # ...
    auth_basic "Protected";
    auth_basic_user_file passwords;
    # ...
}
```

## 限制直接访问Netdata

如果你的Nginx在`localhost`上，你可以使用它来保护你的Netdata：

```
[web]
    bind to = 127.0.0.1 ::1
```

---

您还可以使用unix域套接字。 这也将提供Nginx和Netdata之间更快的路由：

```
[web]
    bind to = unix:/tmp/netdata.sock
```
_注意：Netdata v1.8+才支持unix域套接字_

在Nginx端，使用类似的东西来使用相同的unix域套接字：

```
upstream backend {
    server unix:/tmp/netdata.sock;
    keepalive 64;
}
```

---

如果你的Nginx不在`localhost`上，你可以这样设置：

```
[web]
    bind to = *
    allow connections from = IP_OF_NGINX_SERVER
```

_注意：Netdata v1.9+才支持`allow connections from`的连接_

`allow connections from`通过接受[netdata simple patterns](../libnetdata/simple_pattern/)来匹配连接的IP地址。

## 防止重复的access.log

Nginx记录访问信息，Netdata也记录它们。您可以通过设置来防止Netdata产生访问日志`/etc/netdata/netdata.conf`:

```
[global]
      access log = none
```

## SELinux

如果您收到502网关错误提示，您应该检查您的Nginx错误日志：

```sh
# cat /var/log/nginx/error.log:
2016/09/09 12:34:05 [crit] 5731#5731: *1 connect() to 127.0.0.1:19999 failed (13: Permission denied) while connecting to upstream, client: 1.2.3.4, server: netdata.example.com, request: "GET / HTTP/2.0", upstream: "http://127.0.0.1:19999/", host: "netdata.example.com"
```

如果你看到类似上面的内容，则SELinux阻止了Nginx连接到后端服务器。
要解决这个问题，只需要执行命令：`setsebool -P httpd_can_network_connect true`。

[![analytics](https://www.google-analytics.com/collect?v=1&aip=1&t=pageview&_s=1&ds=github&dr=https%3A%2F%2Fgithub.com%2Fnetdata%2Fnetdata&dl=https%3A%2F%2Fmy-netdata.io%2Fgithub%2Fdocs%2FRunning-behind-nginx&_u=MAC~&cid=5792dfd7-8dc4-476b-af31-da2fdb9f93d2&tid=UA-64295674-3)]()
