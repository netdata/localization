# 在Docker中安装Netdata

> 警告：截至2018年9月9日，我们发布了[新的Docker Build](https://github.com/netdata/netdata/pull/3995)，在Docker中使用[ENTRYPOINT](https://docs.docker.com/engine/reference/builder/#entrypoint)运行Netdata指令，而不是使用COMMAND指令。请相应地调整您的脚本。有关ENTRYPOINT vs COMMAND的更多信息，请参阅[这个](http://goinbigdata.com/docker-run-vs-cmd-vs-entrypoint/)和[Docker文档](https://docs.docker.com/engine/reference/builder/#understand-how-cmd-and-entrypoint-interact)。
>
> 此外, 最新版（`latest`）现在也已基于alpine, 所以**`alpine`不会再有更新**，还有，`armv7hf`也已经被取代为`armhf` （遵循https://github.com/multiarch规则命名）, 所以，**`armv7hf`也同样不会再有更新**。

## 限制

在容器中运行Netdata以监控整个服务器主机，可能会不尽人意。因为某些数据无法访问或不像在服务器主机本身上运行时那样详细。

## 包将在运行时被编码（x84_64架构）

默认的情况下，在x86_64架构中，我们的Docker镜像使用Polymorphic Polyverse Linux软件包加载。为了提高安全性，您可以在运行时启用程序包时重新编码。您需要在启动Netdata docker容器时设置一个环境变量：`RESCRAMBLE = true`。

请去往[Polyverse site](https://polyverse.io/how-it-works/)查看更多信息

## 使用Docker命令运行Netdata

使用Docker命令行以快速启动Netdata。
然后您就可以去到http://host:19999来访问您的Netdata

这适用于内部网络或快速分析主机。

```bash
docker run -d --name=netdata \
  -p 19999:19999 \
  -v /proc:/host/proc:ro \
  -v /sys:/host/sys:ro \
  -v /var/run/docker.sock:/var/run/docker.sock:ro \
  --cap-add SYS_PTRACE \
  --security-opt apparmor=unconfined \
  netdata/netdata
```

以上内容可以转换为docker-compose文件，以便于管理：

```yaml
version: '3'
services:
  netdata:
    image: netdata/netdata
    hostname: example.com # set to fqdn of host
    ports:
      - 19999:19999
    cap_add:
      - SYS_PTRACE
    security_opt:
      - apparmor:unconfined
    volumes:
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
      - /var/run/docker.sock:/var/run/docker.sock:ro
```

### Docker容器名称解析

如果您想通过Netdata解析容器名称，则需要访问Docker组。您只需要将环境变量`PGID=999`添加到Netdata容器中，其中`999`是来自主机的Docker组ID。这个ID可以通过运行以下命令来找到：
```bash
grep docker /etc/group | cut -d ':' -f 3
```

### 将命令行参数传递给Netdata

由于我们使用[ENTRYPOINT](https://docs.docker.com/engine/reference/builder/#entrypoint)指令，您可以使用[command instruction](https://docs.docker.com/engine/reference/builder/#cmd)提供的[Netdata守护程序命令行选项](https://docs.netdata.cloud/daemon/#command-line-options)，例如：将要运行Netdata的IP。

## 使用Docker Compose来安装Netdata（同时启用HTTP代理和SSL/TLS）

对于在公共服务器上的永久安装，您应该查阅[保护Netdata](../../docs/netdata-security.md)。<br/> 本节包括如何使用SSL反向代理的教程和关于使用基本身份验证限制访问权限的教程

您可以使用以下docker-compose.yml和Caddyfile文件以达到在Docker中运行Netdata的目的。在开始之前，您需要替换[Letsencrypt](https://letsencrypt.org/)中的域名和电子邮件地址。

### 先决条件
* [Docker](https://docs.docker.com/install/#server)
* [Docker Compose](https://docs.docker.com/compose/install/)
* 注意：您需要在您的域名服务商中把域名指向您的IP地址

### Caddyfile

此文件必须被放在/opt中，其名称应被设置为“Caddyfile”。在这里，您可以设置您的域名，同时，您需要填入您的电子邮件地址以获取Letsencrypt证书。证书将会自动颁发，并由Caddy服务器在后台执行。

```
netdata.example.org {
  proxy / netdata:19999
  tls admin@example.org
}
```

### docker-compose.yml

在设置Caddyfile以后，使用命令`docker-compose up -d`来运行它，以便在HTTP反向代理后建立功能完备的Netdata。

```yaml
version: '3'
volumes:
  caddy:

services:
  caddy:
    image: abiosoft/caddy
    ports:
      - 80:80
      - 443:443
    volumes:
      - /opt/Caddyfile:/etc/Caddyfile
      - caddy:/root/.caddy
    environment:
      ACME_AGREE: 'true'
  netdata:
    restart: always
    hostname: netdata.example.org
    image: netdata/netdata
    cap_add:
      - SYS_PTRACE
    security_opt:
      - apparmor:unconfined
    volumes:
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
      - /var/run/docker.sock:/var/run/docker.sock:ro
```

### 使用基本身份验证限制访问权限

您可以按照[official caddy guide](https://caddyserver.com/docs/basicauth)来配置Candy文件并向其添加几条命令来限制它的访问。

[![analytics](https://www.google-analytics.com/collect?v=1&aip=1&t=pageview&_s=1&ds=github&dr=https%3A%2F%2Fgithub.com%2Fnetdata%2Fnetdata&dl=https%3A%2F%2Fmy-netdata.io%2Fgithub%2Fpackaging%2Fdocker%2FREADME&_u=MAC~&cid=5792dfd7-8dc4-476b-af31-da2fdb9f93d2&tid=UA-64295674-3)]()
