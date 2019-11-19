# ＃通过lighttpd v1.4.x运行Netdata
# Netdata via lighttpd v1.4.x

这是用于通过lighttpd 1.4.46及更高版本访问子URL中的Netdata的配置：

```txt
$HTTP["url"] =~ "^/netdata/" {
    proxy.server  = ( "" => ("netdata" => ( "host" => "127.0.0.1", "port" => 19999 )))
    proxy.header = ( "map-urlpath" => ( "/netdata/" => "/") )
}
```

如果你使用的是较旧的lighttpd，则必须使用链路（例如bellow），如[在stackoverflow解答中所述](http://stackoverflow.com/questions/14536554/lighttpd-configuration-to-proxy-rewrite-from-one-domain-to-another)。

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

如果服务器通过Web公开的唯一内容是Netdata（因此不需要重写子URL），那么你就可以不用写

```
proxy.server  = ( "" => ( ( "host" => "127.0.0.1", "port" => 19999 )))
```

但是，如果它是公开的，则可能需要在其上进行身份验证。 htdigest支持如下的配置：

```
auth.backend = "htdigest"
auth.backend.htdigest.userfile = "/etc/lighttpd/lighttpd.htdigest"
auth.require = ( "" => ( "method" => "digest", 
                         "realm" => "netdata", 
                         "require" => "valid-user" 
                       )
               )
```

其他身份验证方法以及有关htdigest的更多信息，可以在lighttpd的[mod_auth docs](http://redmine.lighttpd.net/projects/lighttpd/wiki/Docs_ModAuth)中找到。

---

似乎lighttpd（或其某些版本）无法代理压缩的Web响应。要解决此问题，请在Netdata中禁用Web响应压缩。

打开`/etc/netdata/netdata.conf` 并设置[global]\:

```
enable web responses gzip compression = no
```

##限制直接访问Netdata

你还需要指示Netdata仅监听`127.0.0.1`或`:: 1`。

要限制仅从本地主机访问Netdata，请将`/etc/netdata/netdata.conf`中的`bind socket to IP = 127.0.0.1`或`bind socket to IP = :: 1`设置。

[![analytics](https://www.google-analytics.com/collect?v=1&aip=1&t=pageview&_s=1&ds=github&dr=https%3A%2F%2Fgithub.com%2Fnetdata%2Fnetdata&dl=https%3A%2F%2Fmy-netdata.io%2Fgithub%2Fdocs%2FRunning-behind-lighttpd&_u=MAC~&cid=5792dfd7-8dc4-476b-af31-da2fdb9f93d2&tid=UA-64295674-3)](<>)
