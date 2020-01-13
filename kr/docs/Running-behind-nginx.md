 # Nginx에서 Netdata 동작

## 서문

[Nginx](https://nginx.org/en/)는 HTTP, 리버스 프록시 서버, 메일 프록시 서버 및 모든 크기의 응용 프로그램이나 웹 사이트를 호스팅 하는데 사용되는 generic TCP/UDP 프록시 서버입니다.

이 소프트웨어는 메모리 자원에 미치는 영향이 적고, 높은 확장성을 지니며, 안전하고 예측 가능한 성능을 제공할 수 있는 모듈식 이벤트 중심 아키텍처로 알려져 있습니다.

## 왜 Nginx를 사용해야 하는가

-   기본적으로 Nginx는 빠르고 가볍습니다.

-   Nginx는 단일 서버에서 다른 Netdata 인스턴스에 접근하려는 경우 유용합니다.

-   Netdata 클라우드 로그인 메커니즘을 통해 분산 시스템이 적용될 때 까지 Netdata으로 접근할 때 비밀번호로 보호할 수 있습니다.

-   TLS(HTTPS)를 지원하는 Netdata v1.16.0 이전에는 Netdata에 대한 통신을 암호화 하기위해 프록시가 필수적이었습니다.

## Nginx 설정 파일

모든 Nginx 설정은 `/etc/nginx/` 디렉토리에서 찾을 수 있습니다. 기본 설정 파일은 `/etc/nginx/nginx.conf`입니다. 웹사이트나 앱 별 설정은 `/etc/nginx/site-available/` 디렉토리에서 찾을 수 있습니다.

Nginx의 설정 옵션을 지시어(directives)라고 합니다. 지시어는 블록이나 컨텍스트와 같은 그룹으로 구성 되어있습니다. 두 용어는 서로 바꿔 사용할 수 있습니다.

설치 소스에 따라 예제 설정 파일이 `/etc/nginx/conf.d/default.conf`나 `etc/nginx/sites-enabled/default`에 위치해 있습니다. 경우에 따라 `sites-available`와 `sites-enabled` 디렉토리를 수동으로 생성해야할 수 있습니다. 

Nginx 설정 파일은 Nano, Vim이나 기타 선호하는 텍스트 에디터에서 편집할 수 있습니다.

설정 파일을 변경한 후에:

-   `nginx -t`를 입력하여 Nginx 설정을 테스트할 수 있습니다.

-   변경 사항 적용을 위해 `/etc/init.d/nginx restart`나 `service nginx restart`를 입력하여 Nginx를 재시작하십시오.

## Nginx를 통한 Netdata 접근

### 가상 호스트로

`SERVER_IP_ADDRESS:19999` 대신 아래의 방법을 이용하면 아래 설정의 `netdata.example.com`와 같이 사람이 읽을 수 있는 URL을 통해 Netdata 대쉬보드에 접속할 수 있습니다.

```conf
upstream backend {
    # the Netdata server
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

### 기존의 가상 호스트의 하위 폴더로

이 방법은 Netdata가 하위 폴더 (혹은 디렉토리)에서 제공될 때 권장합니다.
이 경우 가상 호스트 `netdata.example.com`가 이미 존재하여야 하며, Netdata는 `netdata.example.com/netdata/`를 통해 접속해야 합니다.

```conf
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

### 1개의 Nginx를 통한 다수의 Netdata 서버의 하위 폴더로

이 방법은 한 개의 Nginx로 하위폴더를 통해 다수의 Netdata 서버를 관리할 떄 권장합니다.

```conf
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

원하는 만큼 백엔드 서버를 추가할 수 있습니다.

위의 경우 아래와 같이 백엔드 서버에서 Netdata에 접속합니다.:

-   `http://netdata.example.com/netdata/server1/` to reach `backend-server1`
-   `http://netdata.example.com/netdata/server2/` to reach `backend-server2`

### Nginx - Netdata 간의 통신 암호화 

Netdata의 웹서버가 [TLS를 사용하도록 설정](../web/server/#enabling-tls-support)된 경우 마지막 목적지(final destination)로 TLS를 사용하도록 Nginx 설정을 작성해야 합니다. 이를 위해서 `nginx.conf`에 다음과 같은 파라미터를 추가하십시오. :

```conf
proxy_set_header X-Forwarded-Proto https;
proxy_pass https://localhost:19999;
```

선택적으로 [Nginx에서 TLS/SSL를 활성화](http://nginx.org/en/docs/http/configuring_https_servers.html)할 수 있습니다. 이렇게 하면 사용자는 Nginx - Netdata 간 통신의 암호화 뿐 아니라, Nginx - 사용자 간 통신 또한 암호화할 수 있습니다.

여기에 기술된 것 처럼 설정하지 않은 경우 `SSL_ERROR_RX_RECORD_TOO_LONG` 오류가 표시될 수 있습니다.

### 인증 활성화

Nginx를 통한 기본 인증 활성화를 위한 인증 파일을 생성하면 Netdata 대쉬보드를 보호할 수 있습니다.

인증 파일이 없다면 아래의 명령어를 사용할 수 있습니다. :

```sh
printf "yourusername:$(openssl passwd -apr1)" > /etc/nginx/passwords
```

그 후 아래의 방법과 같이 서버 지시문 내의 인증을 활성화 하십시오. :

```conf
server {
    # ...
    auth_basic "Protected";
    auth_basic_user_file passwords;
    # ...
}
```

## Netdata에 직접 접근 제한

당신의 Nginx가 `localhost`에 있으면 Netdata 보호를 위해 아래와 같은 방법을 사용할 수 있습니다. :

```
[web]
    bind to = 127.0.0.1 ::1
```

---

또한 유닉스 도메인 소켓을 사용할 수 있습니다. 유닉스 도메인 소켓은 Nginx - Netdata 간 더 빠른 루트를 제공합니다.

```
[web]
    bind to = unix:/var/run/netdata/netdata.sock
```

*note: Netdata v1.8+ 에서 unix domain sockets을 지원합니다.*

Nginx 쪽에서 동일한 유닉스 도메인 소켓을 사용하기 위해 아래와 같이 설정하십시오. :

```conf
upstream backend {
    server unix:/var/run/netdata/netdata.sock;
    keepalive 64;
}
```

---

Nginx 서버가 localhost에 있지 않으면 다음과 같이 설정하십시오. : 

```
[web]
    bind to = *
    allow connections from = IP_OF_NGINX_SERVER
```

*note: Netdata v1.9+ 에서 `allow connections from`를 지원합니다.*

`allow connections from`은 연결 IP 주소와 일치하는 [Netdata simple patterns](../libnetdata/simple_pattern/)을 허용합니다.

## 이중 access.log 방지

Nginx, Netdata 모두 엑세스를 기록합니다. `/etc/netdata/netdata.conf`에서 아래와 같이 설정하여 Netata가 엑세스 로그를 생성하지 않도록 막을 수 있습니다. :

```
[global]
      access log = none
```

## SELinux

만약 502 Bad Gateway error가 발생한 경우 Nginx 에러 로그를 확인하십시오. :

```sh
# cat /var/log/nginx/error.log:
2016/09/09 12:34:05 [crit] 5731#5731: *1 connect() to 127.0.0.1:19999 failed (13: Permission denied) while connecting to upstream, client: 1.2.3.4, server: netdata.example.com, request: "GET / HTTP/2.0", upstream: "http://127.0.0.1:19999/", host: "netdata.example.com"
```

위와 같은 것이 보이면 SELinux가 Nginx를 백엔드 서버에 연결하지 못하도록 막고있을 가능성이 높습니다. 이를 해결하기 위해 `setsebool -P httpd_can_network_connect true` 정책을 사용하십시오.

[![analytics](https://www.google-analytics.com/collect?v=1&aip=1&t=pageview&_s=1&ds=github&dr=https%3A%2F%2Fgithub.com%2Fnetdata%2Fnetdata&dl=https%3A%2F%2Fmy-netdata.io%2Fgithub%2Fdocs%2FRunning-behind-nginx&_u=MAC~&cid=5792dfd7-8dc4-476b-af31-da2fdb9f93d2&tid=UA-64295674-3)](<>)
