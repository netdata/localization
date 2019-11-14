＃通过HAProxy进行Netdata

> HAProxy是一种免费，非常快速且可靠的解决方案，可提供高可用性，负载平衡，并代理基于TCP和HTTP的应用程序。它特别适合于流量很高的网站并为世界上访问量最大的国家提供支持。

如果Netdata在运行HAProxy的主机上运行，​​而不是从端口号，域名连接到Netdata 
可以指向HAProxy，并且HAProxy可以将连接重定向到Netdata端口。这可以使
通过<https://example.com>或<https://example.com/netdata/>连接到Netdata，这比<http://example.com:19999>更好。

要将[HAProxy](https://github.com/haproxy/haproxy)的请求代理到Netdata， 
可以使用以下配置：

##默认配置

对于所有示例，将模式设置为`http`

```conf
defaults
    mode    http
```

##简单配置

一个简单的示例，其中使用基本URL(例如<http://example.com>)而没有子路径：

###前端

创建一个前端来接收请求。

```conf
frontend http_frontend
    ## HTTP ipv4 and ipv6 on all ips ##
    bind :::80 v4v6

    default_backend     netdata_backend
```

###后端

创建Netdata后端，该后端将向端口`19999`发送请求。

```conf
backend netdata_backend
    option       forwardfor
    server       netdata_local     127.0.0.1:19999

    http-request set-header Host %[src]
    http-request set-header X-Forwarded-For %[src]
    http-request set-header X-Forwarded-Port %[dst_port]
    http-request set-header Connection "keep-alive"
```

##配置子路径

将基本URL与子路径`/ netdata /`结合使用的示例：

###前端

要使用子路径，请创建一个ACL，该ACL将基于子路径设置变量。

```conf
frontend http_frontend
    ## HTTP ipv4 and ipv6 on all ips ##
    bind :::80 v4v6

    # URL begins with /netdata
    acl is_netdata url_beg  /netdata

    # if trailing slash is missing, redirect to /netdata/
    http-request redirect scheme https drop-query append-slash if is_netdata ! { path_beg /netdata/ }

    ## Backends ##
    use_backend     netdata_backend       if is_netdata

    # Other requests go here (optional)
    # put netdata_backend here if no others are used
    default_backend www_backend
```

###后端

与简单示例相同，只是使用正则表达式删除`/netdata/`。

```conf
backend netdata_backend
    option      forwardfor
    server      netdata_local     127.0.0.1:19999

    http-request set-path %[path,regsub(^/netdata/,/)]

    http-request set-header Host %[src]
    http-request set-header X-Forwarded-For %[src]
    http-request set-header X-Forwarded-Port %[dst_port]
    http-request set-header Connection "keep-alive"
```

##使用TLS通讯

可以通过在前端添加端口443和证书来使用TLS。
如果主机匹配example.com（用您的域替换），则此示例将仅使用Netdata。

###前端

该前端使用证书列表。

```conf
frontend https_frontend
    ## HTTP ##
    bind :::80 v4v6
    # Redirect all HTTP traffic to HTTPS with 301 redirect
    redirect scheme https code 301 if !{ ssl_fc }

    ## HTTPS ##
    # Bind to all v4/v6 addresses, use a list of certs in file
    bind :::443 v4v6 ssl crt-list /etc/letsencrypt/certslist.txt

    ## ACL ##
    # Optionally check host for Netdata
    acl is_example_host  hdr_sub(host) -i example.com

    ## Backends ##
    use_backend     netdata_backend       if is_example_host
    # Other requests go here (optional)
    default_backend www_backend
```

在证书列表文件中，放置从证书文件到所使用域的映射：

`/etc/letsencrypt/certslist.txt`:

```txt
example.com /etc/letsencrypt/live/example.com/example.com.pem
```

文件`/etc/letsencrypt/live/example.com/example.com.pem`应该包含按顺序连接到`.pem`文件中的密钥和证书。

```sh
cat /etc/letsencrypt/live/example.com/fullchain.pem \
    /etc/letsencrypt/live/example.com/privkey.pem > \
    /etc/letsencrypt/live/example.com/example.com.pem
```

###后端

除了设置协议`https`之外，其他与简单相同。

```conf
backend netdata_backend
    option forwardfor
    server      netdata_local     127.0.0.1:19999

    http-request add-header X-Forwarded-Proto https
    http-request set-header Host %[src]
    http-request set-header X-Forwarded-For %[src]
    http-request set-header X-Forwarded-Port %[dst_port]
    http-request set-header Connection "keep-alive"
```

##启用身份验证

要使用基本的HTTP身份验证，请创建一个身份验证列表：

```conf
# HTTP Auth
userlist basic-auth-list
  group is-admin
  # Plaintext password
  user admin password passwordhere groups is-admin
```

您可以使用`mkpassword`实用程序创建一个哈希密码。

```sh
 printf "passwordhere" | mkpasswd --stdin --method=sha-256
$5$l7Gk0VPIpKO$f5iEcxvjfdF11khw.utzSKqP7W.0oq8wX9nJwPLwzy1
```

用hash替换`passwordhere`：

```conf
user admin password $5$l7Gk0VPIpKO$f5iEcxvjfdF11khw.utzSKqP7W.0oq8wX9nJwPLwzy1 groups is-admin
```

现在在后端顶部添加：

```conf
acl devops-auth http_auth_group(basic-auth-list) is-admin
http-request auth realm netdata_local unless devops-auth
```

##完整示例

带有子路径的TLS上的HTTP身份验证的完整示例配置：

```conf
global
    maxconn     20000

    log         /dev/log local0
    log         /dev/log local1 notice
    user        haproxy
    group       haproxy
    pidfile     /run/haproxy.pid

    stats socket /run/haproxy/admin.sock mode 660 level admin expose-fd listeners
    stats timeout 30s
    daemon

    tune.ssl.default-dh-param 4096  # Max size of DHE key

    # Default ciphers to use on SSL-enabled listening sockets.
    ssl-default-bind-ciphers ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:RSA+AESGCM:RSA+AES:!aNULL:!MD5:!DSS
    ssl-default-bind-options no-sslv3

defaults
    log     global
    mode    http
    option  httplog
    option  dontlognull
    timeout connect 5000
    timeout client  50000
    timeout server  50000
    errorfile 400 /etc/haproxy/errors/400.http
    errorfile 403 /etc/haproxy/errors/403.http
    errorfile 408 /etc/haproxy/errors/408.http
    errorfile 500 /etc/haproxy/errors/500.http
    errorfile 502 /etc/haproxy/errors/502.http
    errorfile 503 /etc/haproxy/errors/503.http
    errorfile 504 /etc/haproxy/errors/504.http

frontend https_frontend
    ## HTTP ##
    bind :::80 v4v6
    # Redirect all HTTP traffic to HTTPS with 301 redirect
    redirect scheme https code 301 if !{ ssl_fc }

    ## HTTPS ##
    # Bind to all v4/v6 addresses, use a list of certs in file
    bind :::443 v4v6 ssl crt-list /etc/letsencrypt/certslist.txt

    ## ACL ##
    # Optionally check host for Netdata
    acl is_example_host  hdr_sub(host) -i example.com
    acl is_netdata       url_beg  /netdata

    http-request redirect scheme https drop-query append-slash if is_netdata ! { path_beg /netdata/ }

    ## Backends ##
    use_backend     netdata_backend       if is_example_host is_netdata
    default_backend www_backend

# HTTP Auth
userlist basic-auth-list
    group is-admin
    # Hashed password
    user admin password $5$l7Gk0VPIpKO$f5iEcxvjfdF11khw.utzSKqP7W.0oq8wX9nJwPLwzy1 groups is-admin

## Default server(s) (optional)##
backend www_backend
    mode        http
    balance     roundrobin
    timeout     connect 5s
    timeout     server  30s
    timeout     queue   30s

    http-request add-header 'X-Forwarded-Proto: https'
    server      other_server 111.111.111.111:80 check

backend netdata_backend
    acl devops-auth http_auth_group(basic-auth-list) is-admin
    http-request auth realm netdata_local unless devops-auth

    option forwardfor
    server      netdata_local     127.0.0.1:19999

    http-request set-path %[path,regsub(^/netdata/,/)]

    http-request add-header X-Forwarded-Proto https
    http-request set-header Host %[src]
    http-request set-header X-Forwarded-For %[src]
    http-request set-header X-Forwarded-Port %[dst_port]
    http-request set-header Connection "keep-alive"
```

[![analytics](https://www.google-analytics.com/collect?v=1&aip=1&t=pageview&_s=1&ds=github&dr=https%3A%2F%2Fgithub.com%2Fnetdata%2Fnetdata&dl=https%3A%2F%2Fmy-netdata.io%2Fgithub%2Fdocs%2FRunning-behind-haproxy&_u=MAC~&cid=5792dfd7-8dc4-476b-af31-da2fdb9f93d2&tid=UA-64295674-3)](<>)