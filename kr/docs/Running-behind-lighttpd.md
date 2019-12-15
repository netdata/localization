# lighttpd v1.4.x를 이용한 Netdata

이번 장은 lighttpd 1.4.46 버전과 그 이상의 버전으로 하위 URL로 Netdata에 접근하기 위한 설정을 설명합니다.:

```txt
$HTTP["url"] =~ "^/netdata/" {
    proxy.server  = ( "" => ("netdata" => ( "host" => "127.0.0.1", "port" => 19999 )))
    proxy.header = ( "map-urlpath" => ( "/netdata/" => "/") )
}
```

1.4.46 이전 버전의 lighttpd를 사용 중 이라면 [at this stackoverflow answer](http://stackoverflow.com/questions/14536554/lighttpd-configuration-to-proxy-rewrite-from-one-domain-to-another)에 설명된 것을 따라 아래와 같이 chain을 사용해야 합니다.

```txt
$HTTP["url"] =~ "^/netdata/" {
    proxy.server  = ( "" => ("" => ( "host" => "127.0.0.1", "port" => 19998 )))
}

$SERVER["socket"] == ":19998" {
    url.rewrite-once = ( "^/netdata(.*)$" => "/$1" )
    proxy.server = ( "" => ( "" => ( "host" => "127.0.0.1", "port" => 19999 )))
}
```

---

서버가 웹을 통해 노출하는 컨텐츠가 Netdata 뿐이라면 (하위 경로를 다시 쓸 필요가 없는 경우라면) 작성할 필요가 없습니다.

```
proxy.server  = ( "" => ( ( "host" => "127.0.0.1", "port" => 19999 )))
```

하지만 Netdata가 공개적인 경우 인증이 필요할 수 있습니다. htdigest 지원은 아래와 같습니다:

```
auth.backend = "htdigest"
auth.backend.htdigest.userfile = "/etc/lighttpd/lighttpd.htdigest"
auth.require = ( "" => ( "method" => "digest", 
                         "realm" => "netdata", 
                         "require" => "valid-user" 
                       )
               )
```

다른 인증 방식이나 htdigest에 대한 더 많은 정보는 lighttpd의 [mod_auth docs](http://redmine.lighttpd.net/projects/lighttpd/wiki/Docs_ModAuth) 에서 찾아볼 수 있습니다.

---

lighttpd (전체 혹은 일부 버전)에서 압축된 웹 응답을 프록시 하는데 실패하는 것 같습니다.
이 문제를 해결하려면 Netdata에서 웹 응답 압축을 비활성화 하십시오.

`/etc/netdata/netdata.conf`를 열어 다음과 같이 [global]을 설정하십시오.:

```
enable web responses gzip compression = no
```

## Netdata에 직접 접근 제한 

`127.0.0.1`나 `::1`를 통해서만 Netdata에 접근하도록 할 수 있습니다.

localhost에서만 Netdata에 접근 가능하도록 제한하려면, `/etc/netdata/netdata.conf` 파일을 `bind socket to IP = 127.0.0.1` 나 `bind socket to IP = ::1`와 같이 설정하십시오.

[![analytics](https://www.google-analytics.com/collect?v=1&aip=1&t=pageview&_s=1&ds=github&dr=https%3A%2F%2Fgithub.com%2Fnetdata%2Fnetdata&dl=https%3A%2F%2Fmy-netdata.io%2Fgithub%2Fdocs%2FRunning-behind-lighttpd&_u=MAC~&cid=5792dfd7-8dc4-476b-af31-da2fdb9f93d2&tid=UA-64295674-3)](<>)
