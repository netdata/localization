＃通过Caddy的Netdata

要通过[Caddy的代理](https://caddyserver.com/docs/proxy)运行Netdata,如下设置Caddyfile：

```caddyfile
netdata.domain.tld {
    proxy / localhost:19999
}
```

可以根据需要在大括号之间添加其他指令。

要在子文件夹中运行Netdata：

```caddyfile
netdata.domain.tld {
    proxy /netdata/ localhost:19999 {
        without /netdata
    }
}
```

##限制直接访问Netdata

您还需要指示Netdata仅监听 `127.0.0.1` or `::1`。

要限制仅从本地主机访问Netdata，请将`/etc/netdata/netdata.conf`中的 `bind socket to IP = 127.0.0.1` or `或`bind socket to IP = ::1`设置。

[![analytics](https://www.google-analytics.com/collect?v=1&aip=1&t=pageview&_s=1&ds=github&dr=https%3A%2F%2Fgithub.com%2Fnetdata%2Fnetdata&dl=https%3A%2F%2Fmy-netdata.io%2Fgithub%2Fdocs%2FRunning-behind-caddy&_u=MAC~&cid=5792dfd7-8dc4-476b-af31-da2fdb9f93d2&tid=UA-64295674-3)](<>)