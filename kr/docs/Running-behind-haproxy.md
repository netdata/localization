# HAProxy를 이용한 Netdata

> HAProxy는 TCP, HTTP 기반의 응용 프로그램을 위한 고가용성, 로드 밸런싱, 프록시를제공하는 빠르고 안정적인 무료 솔루션입니다. 트래픽이 많은 웹 사이트에 적합합니다.

HAProxy를 실행하는 호스트에서 Netdata를 실행 중인 경우 포트 번호를 Netdata에 연결하지 않고, 도메인 네임을 HAProxy에 연결하고 HAProxy가 Netdata 포트를 리다이렉션으로 연결시킬 수 있습니다. 이를 통해 Netdata를 <http://example.com:19999>와 같이 포트를 입력하여 접속할 필요 없이 <https://example.com>나 <https://example.com/netdata/> 와 같이 주소로 접속할 수 있게 됩니다.

[HAProxy](https://github.com/haproxy/haproxy)에서 Netdata로 프록시 요청하기 위해, 다음 설정을 사용할 수 있습니다.:

## 기본 설정

모든 예제에서 모드는 `http`로 설정합니다.

```conf
defaults
    mode    http
```

## 간단한 설정

(<http://example.com>와 같이) 하위 경로 없이 기본 URL로 사용하는 간단한 예제:

### 프론트엔드

요청을 받기 위해 프론트엔드를 생성하세요.

```conf
frontend http_frontend
    ## HTTP ipv4 and ipv6 on all ips ##
    bind :::80 v4v6

    default_backend     netdata_backend
```

### 백엔드

`19999`를 통해 요청을 보내기 위해 Netdata 백엔드를 생성하세요.

```conf
backend netdata_backend
    option       forwardfor
    server       netdata_local     127.0.0.1:19999

    http-request set-header Host %[src]
    http-request set-header X-Forwarded-For %[src]
    http-request set-header X-Forwarded-Port %[dst_port]
    http-request set-header Connection "keep-alive"
```

## 하위 경로를 사용하기 위한 설정

기본 URL에 `/netdata/`를 하위경로로 사용하는 예제:

### 프론트엔드

하위 경로를 사용하기 위해 하위 경로를 기반으로 변수를 설정하는 접근 제어 목록(ACL)을 생성하세요.

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

### 백엔드

정규식으로 `/netdata/`를 추가해주는 것을 제외하면 간단한 설정에서 했던 것과 동일합니다.:

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

## TLS 통신 사용

`443`포트와 인증서를 프론트엔드에 추가하면 TLS를 사용할 수 있습니다.
이 예시는 당신의 도메인(아래 예시에서는 example.com)과 호스트가 일치하는 경우에만 사용합니다.

### 프론트엔드

이 프론트엔드에서는 인증서 목록을 사용합니다.

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

인증서 목록 파일 안에서 인증서 파일에서 사용된 도메인으로 매핑을 배치해야합니다.:

`/etc/letsencrypt/certslist.txt`:

```txt
example.com /etc/letsencrypt/live/example.com/example.com.pem
```

`/etc/letsencrypt/live/example.com/example.com.pem`파일은 `.pem` 파일에 연결된 키와 인증서가 포함되어야 합니다.:

```sh
cat /etc/letsencrypt/live/example.com/fullchain.pem \
    /etc/letsencrypt/live/example.com/privkey.pem > \
    /etc/letsencrypt/live/example.com/example.com.pem
```

### 백엔드

프로토콜을 `https`로 설정하는 것을 제외하면 간단한 예제에서와 동일합니다.

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

## 인증 활성화

기본적인 HTTP 인증을 사용하기 위해 다음과 같이 인증 목록을 사용하십시오.:

```conf
# HTTP Auth
userlist basic-auth-list
  group is-admin
  # Plaintext password
  user admin password passwordhere groups is-admin
```

`mkpassword` 유틸리티를 이용하여 해시된 암호를 생성할 수 있습니다. :

```sh
 printf "passwordhere" | mkpasswd --stdin --method=sha-256
$5$l7Gk0VPIpKO$f5iEcxvjfdF11khw.utzSKqP7W.0oq8wX9nJwPLwzy1
```

`passwordhere`를 해시로 바꾸십시오. :

```conf
user admin password $5$l7Gk0VPIpKO$f5iEcxvjfdF11khw.utzSKqP7W.0oq8wX9nJwPLwzy1 groups is-admin
```

이제 백엔드 상단에 추가히십시오. :

```conf
acl devops-auth http_auth_group(basic-auth-list) is-admin
http-request auth realm netdata_local unless devops-auth
```

## 전체 예제

하위 경로가 있는 TLS를 통한 HTTP 인증을 사용하는 전체 설정 예제 :

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
