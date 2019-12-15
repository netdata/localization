# Caddy를 통한 Netdata

[Caddy의 프록시 기능](https://caddyserver.com/docs/proxy)을 이용해 Netdata를 작동시키기 위해 아래와 같이 Caddyfile을 설정하세요.

```caddyfile
netdata.domain.tld {
    proxy / localhost:19999
}
```

필요에 따라 다른 지시문을 중괄호 간에 추가할 수 있습니다.

하위 폴더에서 Netdata를 실행시키려면 아래를 참고하세요.

```caddyfile
netdata.domain.tld {
    proxy /netdata/ localhost:19999 {
        without /netdata
    }
}
```

## Netdata에 직접 접근 제한

`127.0.0.1`이나 `::1`에서만 Netdata에 접근 가능하도록 지시할 수 있습니다.

localhost에서만 Netdata를 접속 가능하게 제한하기 위해 `/etc/netdata/netdata.conf` 파일에서 `bind socket to IP = 127.0.0.1`로 설정하거나 `bind socket to IP = ::1`로 설정하십시오.

[![analytics](https://www.google-analytics.com/collect?v=1&aip=1&t=pageview&_s=1&ds=github&dr=https%3A%2F%2Fgithub.com%2Fnetdata%2Fnetdata&dl=https%3A%2F%2Fmy-netdata.io%2Fgithub%2Fdocs%2FRunning-behind-caddy&_u=MAC~&cid=5792dfd7-8dc4-476b-af31-da2fdb9f93d2&tid=UA-64295674-3)](<>)
