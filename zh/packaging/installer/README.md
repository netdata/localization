# 安装Netdata

Netdata是一个**服务器状态监控显示器**。它可以在所有的系统上安装和运行，包括**物理**和**虚拟**服务器，**Docker容器**，甚至是**物联网（IoT）**中。

安装Netdata的最佳方法是脚本安装。我们的**自动安装程序**将安装任何需要的系统软件包，并在您的系统上编译Netdata。

!!! 注意
    您可以找到由第三方分发的Netdata软件安装包。但是在大多数情况下，这些安装包太旧或不完整。因此，我们强烈建议您按照本说明来安装Netdata。
     **我们正在努力为所有的Linux发行版提供Netdata的二进制包。** 敬请期待     

## Installation

1. [自动安装](#自动安装)，从源代码中安装， **这是默认的安装方法**
2. [在64位的Linux上安装预构建的静态二进制文件](#linux-64bit-pre-built-static-binary)
3. [在Docker容器中运行Netdata](#run-netdata-in-a-docker-container)
4. [手动安装](#install-netdata-on-linux-manually)
5. [在FreeBSD系统上安装](#freebsd)
6. [在pfSense系统上安装](#pfsense)
7. [在FreeNAS Corral中启用](#freenas)
8. [在macOS (OS X)上安装](#macos)
9. [Install on a Kubernetes cluster](https://github.com/netdata/helmchart#netdata-helm-chart-for-kubernetes-deployments)
10. [Install using binary packages](#binary-packages)

另请参阅ASUSTOR NAS，OpenWRT，ReadyNAS等的Netdata软件包维护者列表（它应该在../maintainers）。

---

## 自动安装
## One line installation

> 这种方法在**所有的Linux发行版上都是自动的**。 在首次安装Netdata之前，FreeBSD和MacOS系统需要提前做一些准备工作。有关详细信息，请查看[FreeBSD](#freebsd)和[MacOS](#macos)部分。

要从源代码中安装Netdata并使其自动保持最新，请运行以下命令：

```bash
bash <(curl -Ss https://my-netdata.io/kickstart.sh)
```

*（无须使用`sudo`命令头，它会根据需要自动执行）*

![](https://registry.my-netdata.io/api/v1/badge.svg?chart=web_log_nginx.requests_per_url&options=unaligned&dimensions=kickstart&group=sum&after=-3600&label=last+hour&units=installations&value_color=orange&precision=0) ![](https://registry.my-netdata.io/api/v1/badge.svg?chart=web_log_nginx.requests_per_url&options=unaligned&dimensions=kickstart&group=sum&after=-86400&label=today&units=installations&precision=0)

<details markdown="1"><summary>单击以获取更多信息</summary>

&nbsp;<br/>
Verify the integrity of the script with this:

```bash
[ "b66c99c065abe1cf104c11236d4e8747" = "$(curl -Ss https://my-netdata.io/kickstart.sh | md5sum | cut -d ' ' -f 1)" ] && echo "OK, VALID" || echo "FAILED, INVALID"
```
*It should print `OK, VALID` if the script is the one we ship.*

The `kickstart.sh` script:

- detects the Linux distro and **installs the required system packages** for building Netdata (will ask for confirmation)
- downloads the latest Netdata source tree to `/usr/src/netdata.git`.
- installs Netdata by running `./netdata-installer.sh` from the source tree.
- installs `netdata-updater.sh` to `cron.daily`, so your Netdata installation will be updated daily (you will get a message from cron only if the update fails).
- For QA purposes, this installation method lets us know if it succeed or failed.

The `kickstart.sh` script passes all its parameters to `netdata-installer.sh`, so you can add more parameters to change the installation directory, enable/disable plugins, etc (check below).

For automated installs, append a space + `--dont-wait` to the command line. You can also append `--dont-start-it` to prevent the installer from starting Netdata. Example:

```bash
  bash <(curl -Ss https://my-netdata.io/kickstart.sh) --dont-wait --dont-start-it
```

</details>&nbsp;<br/>

当你安装完成，请前往：[开始使用](../../docs/getting-started.md)

---

## 使用Linux 64的预构建静态二进制文件安装
## Linux 64bit pre-built static binary

您可以在任何Intel/AMD平台上的64位Linux系统上使用预编译静态二进制文件安装Netdata
（即使是那些没有包管理器的系统，也可以使用这一方法来安装，如CoreOS，CirrOS，busybox等）。
您还可以在具有损坏或不受支持的包管理器的系统上使用这些程序包。

要在Linux的发行版上使用二进制包来安装Netdata，对于** Intel/AMD 64位 **的服务器来说，请运行以下命令：


```bash
  bash <(curl -Ss https://my-netdata.io/kickstart-static64.sh)
```

*(没用必要使用`sudo`这个命令头，它会根据需要自动执行；如果服务器没有安装`bash`，请参阅下面的说明：如何在没有`bash`的情况下运行安装程序）*

![](https://registry.my-netdata.io/api/v1/badge.svg?chart=web_log_nginx.requests_per_url&options=unaligned&dimensions=kickstart64&group=sum&after=-3600&label=last+hour&units=installations&value_color=orange&precision=0) ![](https://registry.my-netdata.io/api/v1/badge.svg?chart=web_log_nginx.requests_per_url&options=unaligned&dimensions=kickstart64&group=sum&after=-86400&label=today&units=installations&precision=0)

> The static builds install Netdata at **`/opt/netdata`**

<details markdown="1"><summary>单击以获取更多信息</summary>

&nbsp;<br/>
Verify the integrity of the script with this:

```bash
[ "8e6df9b6f6cc7de0d73f6e5e51a3c8c2" = "$(curl -Ss https://my-netdata.io/kickstart-static64.sh | md5sum | cut -d ' ' -f 1)" ] && echo "OK, VALID" || echo "FAILED, 
INVALID"
```

*It should print `OK, VALID` if the script is the one we ship.*

For automated installs, append a space + `--dont-wait` to the command line. You can also append `--dont-start-it` to prevent the installer from starting Netdata.

Example:

```bash

  bash <(curl -Ss https://my-netdata.io/kickstart-static64.sh) --dont-wait --dont-start-it

```

If your shell fails to handle the above one liner, do this:

```bash
# download the script with curl
curl https://my-netdata.io/kickstart-static64.sh >/tmp/kickstart-static64.sh

# or, download the script with wget
wget -O /tmp/kickstart-static64.sh https://my-netdata.io/kickstart-static64.sh

# run the downloaded script (any sh is fine, no need for bash)
sh /tmp/kickstart-static64.sh
```

- The static binary files are kept in repo [binary-packages](https://github.com/netdata/binary-packages). You can download any of the `.run` files, and run it. These files are self-extracting shell scripts built with [makeself](https://github.com/megastep/makeself).
- The target system does **not** need to have bash installed.
- The same files can be used for updates too.
- For QA purposes, this installation method lets us know if it succeed or failed.

</details>&nbsp;<br/>

当你安装完成，请前往：[开始使用](../../docs/getting-started.md)

---

## 在Docker容器上运行Netdata
## Run netdata in a docker container

你可以[在Docker上安装Netdata](../docker/#install-netdata-with-docker).

---

## 在Linux系统中手动安装Netdata
## Install netdata on Linux manually

要安装最新的Netdata git版本，请按照以下两个步骤操作：

1. [为你的系统作准备](#为你的系统做准备)

   在你的系统中安装Netdata所需的软件包

2. [安装Netdata](#install-netdata)

   下载并安装Netdata。您还可以同样的方法来更新Netdata。

---

### 为你的系统做准备

试试我们的新版安装程序（不要求为root用户）。它会尝试查找已在系统上安装的软件包以编译和运行Netdata。这个程序支持2010年后发布的大多数Linux发行版（如下）：

- **Alpine** Linux及其衍生产品（在使用安装程序之前必须自己安装`bash`）
- **Arch** Linux及其衍生产品
- **Gentoo** Linux及其衍生产品
- **Debian** Linux及其衍生产品（包括 **Ubuntu**, **Mint**）
- **Fedora** 和它的衍生产品 （包括 **Red Hat Enterprise Linux**, **CentOS**, **Amazon Machine Image**）
- **SuSe** Linux及其衍生产品（包括 **openSuSe**）
- **SLE12** 必须让您的系统在Suse客户中心注册或拥有DVD。请参阅[#1162]（https://github.com/netdata/netdata/issues/1162）

请注意：安装包是**基本的Netdata安装**（系统监控和许多应用程序监控，它没有`mysql` /`mariadb`，`postgres`，`named`，`硬件监控`和`SNMP`），请执行以下命令：

```sh
curl -Ss 'https://raw.githubusercontent.com/netdata/netdata-demo-site/master/install-required-packages.sh' >/tmp/kickstart.sh && bash /tmp/kickstart.sh -i netdata
```

如果你想安装**Netdata的完整版本**，请执行以下命令：

```sh
curl -Ss 'https://raw.githubusercontent.com/netdata/netdata-demo-site/master/install-required-packages.sh' >/tmp/kickstart.sh && bash /tmp/kickstart.sh -i netdata-all
```

如果上述内容对您不起作用，请 [提问](https://github.com/netdata/netdata/issues/new?title=packages%20installer%20failed&labels=installation%20help&body=The%20experimental%20packages%20installer%20failed.%0A%0AThis%20is%20what%20it%20says:%0A%0A%60%60%60txt%0A%0Aplease%20paste%20your%20screen%20here%0A%0A%60%60%60) 请附上您在屏幕上看到提示消息。我们正试图让Netdata在任何地方都能运行（这也是提问成功与否 [例子](https://github.com/netdata/netdata/issues/2054) 的原因)。

---

如何在不同的系统中手动完成准备工作？

```sh
# 在Debian/Ubuntu系统中
apt-get install zlib1g-dev uuid-dev libmnl-dev gcc make git autoconf autoconf-archive autogen automake pkg-config curl

# 在Fedora系统中
dnf install zlib-devel libuuid-devel libmnl-devel gcc make git autoconf autoconf-archive autogen automake pkgconfig curl findutils

# 在CentOS/Red Hat Enterprise Linux系统中
yum install autoconf automake curl gcc git libmnl-devel libuuid-devel lm_sensors make MySQL-python nc pkgconfig python python-psycopg2 PyYAML zlib-devel

```

请注意，在RHEL/CentOS系统中，您还可能需要[EPEL](http://www.tecmint.com/how-to-enable-epel-repository-for-rhel-centos-6-5/).

编译Netdata后，要运行它，需要以下软件包（它们应该已经使用上述命令安装）：

软件包名|描述
:-----:|-----------
`libuuid`|用于GUID管理的`util-linux`一部分
`zlib`|Netdata Web内部服务器的Gzip压缩软件包

*如果没用这些软件包，Netdata将无法启动*

Netdata插件和Netdata的其他一些方面可以在安装时启用或禁用（它们是可选的）：

软件包名|描述
:-----:|-----------
`bash`|用于Shell插件和**警报通知**
`curl`|用于Shell插件和**警报通知**
`iproute` 或 `iproute2`|用于监控** Linux流量QoS **<br/>如果`iproute`提示不可用或已过时，请使用`iproute2`
`python`|这对于大多数外部插件来说都是必须的
`python-yaml`|用于监控**beanstalkd**
`python-beanstalkc`|用于监控**beanstalkd**
`python-dnspython`|用于监控DNS的查询时间
`python-ipaddress`|用于监控** DHCPd **</br>只有Python V2才需要此软件包。Python V3已经嵌入了此功能
`python-mysqldb`<br/>或<br/>`python-pymysql`|用于监控**mysql**或**mariadb** 数据库<br/>`python-mysqldb`会运行地更快，所以它是首选
`python-psycopg2`|用于监控**postgresql**数据库
`python-pymongo`|用于监控**mongodb**数据库
`nodejs`|用于`node.js`插件来监控**named**和**SNMP**设备
`lm-sensors`|用于监控**hardware sensors**
`libmnl`|用于收集netfilter指标
`netcat`|用于从远程系统中收集指标的Shell插件

*如果安装了上述软件包，Netdata功能将大大增加，但如果没有它们，Netdata仍然可以正常工作。*

---

### 安装Netdata
### Install Netdata

运行以下命令来安装并运行Netdata：

```sh

# 下载Netdata（同时创建netdata目录）
git clone https://github.com/netdata/netdata.git --depth=100
cd netdata

# 运行具有root权限的脚本来编译安装Netdata并启动它
./netdata-installer.sh

```

* 如果您不想安装完成后启动Netdata，请添加`--dont-start-it`参数

* 如果您不想在默认目录中安装Netdata，请按照这样来输入命令：`./netdata-installer.sh --install /opt`。这条命令会把Netdata安装在`/opt/netdata`中。

当安装完成，文件`/etc/netdata/netdata.conf`会被创建（如果您更改了安装目录，该配置文件也会出现在您指定的目录中）。

您可以编辑此文件以更改设置首选项。一个最常见被调整选项是`history`，它控制Netdata将使用的内存数据库大小。其默认情况下应为“3600”秒（图表中一小时的数据），这使得Netdata将使用大约10-15MB的RAM（取决于系统检测到的图表数量）。请检查**[内存要求]**。

要应用您所做的更改，您必须重新启动Netdata。

---

## 其他系统



##### FreeBSD

您可以从ports或packages中安装Netdata。

此命令会在FreeBSD上安装最新版的Netdata：

```sh
# 安装依赖
pkg install bash e2fsprogs-libuuid git curl autoconf automake pkgconf pidof

# 下载Netdata
git clone https://github.com/netdata/netdata.git --depth=100

# 把Netdata安装在/opt/netdata中
cd netdata
./netdata-installer.sh --install /opt
```

##### pfSense
要在pfSense上安装Netdata，请运行以下命令（在Shell中或在pfSense Web界面中的Diagnostics/Command Prompt）。

根据您的环境更改平台（i386/amd64等）和FreeBSD版本（10/11等），并根据FreeSBD存储库中的最新版本更改Netdata版本（示例中为1.10.0）：

注意：前三个软件包是从pfSense存储库中下载的，用于保持与pfSense系统的兼容性，Netdata是从FreeBSD的存储库中下载的。
```
pkg install pkgconf
pkg install bash
pkg install e2fsprogs-libuuid
pkg add http://pkg.freebsd.org/FreeBSD:11:amd64/latest/All/netdata-1.11.0.txz
```
要运行Netdata，请手动运行这条命令：`service netdata onestart`

要把Netdata添加为启动项，请在pfSense Web界面中添加`service netdata start`为Shellcmd（在**Services/Shellcmd**下，您需要事先在**System/Package Manager/Available Packages**下安装）。
Shellcmd Type应设置为`Shellcmd`。
![](https://user-images.githubusercontent.com/36808164/36930790-4db3aa84-1f0d-11e8-8752-cdc08bb7207c.png)
您可以在这里找到更多信息： https://doc.pfsense.org/index.php/Installing_FreeBSD_Packages ，通过命令行和脚本来实现相同的功能。
如果您在pfSense 2.3或更早版本中遇到`/usr/bin/install` absense问题，请更新pfSense或使用解决方法：[https://redmine.pfsense.org/issues/6643](https://redmine.pfsense.org/issues/6643)

##### FreeNAS
在FreeNAS-Corral-RELEASE（>=10.0.3）上Netdata已经被预先安装。

要使用Netdata，需要启用该服务并从FreeNAS中启动 **[CLI](https://github.com/freenas/cli)**.

启用Netdata服务：
```
service netdata config set enable=true
```

运行Netdata服务：
```
service netdata start
```

##### macOS

macOS上的Netdata仅有一部分监控图表，但外部插件是被允许的。

您可以使用[Homebrew](https://brew.sh/)来安装Netdata

```sh
brew install netdata
```

或者从源中安装

```sh
# 安装Xcode命令行工具
xcode-select --install
```
在软件更新弹出窗口中点击`Install`，然后
```sh
# 安装HomeBrew包管理器
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# 安装依赖
brew install ossp-uuid autoconf automake pkg-config

# 下载Netdata
git clone https://github.com/netdata/netdata.git --depth=100

# 把Netdata安装在/usr/local/netdata中
cd netdata
sudo ./netdata-installer.sh --install /usr/local
```

安装程序还会自动配置plist以在Mac启动时自动启动Netdata。

##### Alpine 3.x

执行以下命令在Alpine Linux 3.x中安装Netdata：

```
# 安装依赖
apk add alpine-sdk bash curl zlib-dev util-linux-dev libmnl-dev gcc make git autoconf automake pkgconfig python logrotate

# 如果您打算运行node.js Netdata插件，请执行此命令，否则请跳过
apk add nodejs

# 下载Netdata（同时创建Netdata更目录）
git clone https://github.com/netdata/netdata.git --depth=100
cd netdata


# 编译，安装，运行Netdata
./netdata-installer.sh


# 将Netdata添加为自启项
echo -e "#!/usr/bin/env bash\n/usr/sbin/netdata" >/etc/local.d/netdata.start
chmod 755 /etc/local.d/netdata.start

# 使Netdata在关机时自动停止
echo -e "#!/usr/bin/env bash\nkillall netdata" >/etc/local.d/netdata.stop
chmod 755 /etc/local.d/netdata.stop

# 启用本地服务以自动启动
rc-update add local
```

##### Synology

该文档以前建议从Synology社区源中安装Debian Chroot包，然后在chroot中运行Netdata。然而，这不起作用，因为chroot环境无法访问`/proc`，所以Netdata几乎无法获取到任何指标。另外，[问题](https://github.com/SynoCommunity/spksrc/issues/2758)，在2018/06/24时被打开，表示Debian Chroot软件包不适用于DSM5以上，并且可能损坏系统库使NAS无法正常启动。

好消息是，如果您的NAS是amd64架构的，那么64位静态安装程序可以地正常工作。它会将内容安装到`/opt/netdata`中，以便将来删除地更加安全和简单。

首次安装Netdata时，它将以_root_用户运行。您可能不想这样做，您或许想使用_netdata_用户来运行，这需要一些额外的工作：

1. 通过Synology用户界面创建一个用户组`netdata`。但请不要给它任何权限。
2. 通过Synology用户界面创建用户`netdata`。但请让它无法访问任何内容和随机密码。请将此用户分配给`netdata`用户组。Netdata将会在运行时为这个用户提供帮助。
3. 更改以下目录的所有权（执行以下命令），如[Netdata安全](../../docs/netdata-security.md#security-design)中所配置的那样：

```
$ chown -R root:netdata /opt/netdata/usr/share/netdata
$ chown -R netdata:netdata /opt/netdata/var/lib/netdata /opt/netdata/var/cache/netdata
$ chown -R netdata:root /opt/netdata/var/log/netdata
```

此外，从2018/06/24起，Netdata安装程序将无法识别DSM为一个操作系统，所以安装程序无法安装任何init脚本。因此，您必须手动执行这些操作：

1. 将[文件](https://gist.github.com/oskapt/055d474d7bfef32c49469c1b53e8225f)添加到`/etc/rc.netdata`中。然后用`chmod 0755 /etc/rc.netdata`命令给予它权限。
2. 编辑`/etc/rc.local`并在末尾添加一行调用：`/etc/rc.netdata`，使其在启动时可以自动启动：

```
# 使Netdata在开机时自动启动
[ -x /etc/rc.netdata ] && /etc/rc.netdata start
```
译者注：请以英语原版为准


## Binary Packages
![](https://raw.githubusercontent.com/netdata/netdata/master/web/gui/images/packaging-beta-tag.svg?sanitize=true)

We provide our own flavour of binary packages for the most common operating systems that comply with .RPM and .DEB packaging formats.

We have currently released packages following the .RPM format with version [1.16.0](https://github.com/netdata/netdata/releases/tag/v1.16.0).
We have planned to release packages following the .DEB format with version [1.17.0](https://github.com/netdata/netdata/releases/tag/v1.17.0).
Early adopters may experiment with our .DEB formatted packages using our nightly releases. Our current packaging infrastructure provider is [Package Cloud](https://packagecloud.io).

Netdata is committed to support installation of our solution to all operating systems. This is a constant battle for Netdata, as we strive to automate and make things easier for our users. For the operating system support matrix, please visit our [distributions](../../packaging/DISTRIBUTIONS.md) support page.

We provide two separate repositories, one for our stable releases and one for our nightly releases.

1. Stable releases: Our stable production releases are hosted in [netdata/netdata](https://packagecloud.io/netdata/netdata) repository of package cloud
2. Nightly releases: Our latest releases are hosted in [netdata/netdata-edge](https://packagecloud.io/netdata/netdata-edge) repository of package cloud

Visit the repository pages and follow the quick set-up instructions to get started.


## Nightly vs. stable releases

The Netdata team maintains two releases of the Netdata agent: **nightly** and **stable**. By default, Netdata's installation scripts will give you **automatic, nightly** updates, as that is our recommended configuration.

**Nightly**: We create nightly builds every 24 hours. They contain fully-tested code that fixes bugs or security flaws, or introduces new features to Netdata. Every nightly release is a candidate for then becoming a stable release—when we're ready, we simply change the release tags on GitHub. That means nightly releases are stable and proven to function correctly in the vast majority of Netdata use cases. That's why nightly is the *best choice for most Netdata users*.

**Stable**: We create stable releases whenever we believe the code has reached a major milestone. Most often, stable releases correlate with the introduction of new, significant features. Stable releases might be a better choice for those who run Netdata in *mission-critical production systems*, as updates will come more infrequently, and only after the community helps fix any bugs that might have been introduced in previous releases.

**Pros of using nightly releases:**

  - Get the latest features and bugfixes as soon as they're available
  - Receive security-related fixes immediately
  - Use stable, fully-tested code that's always improving
  - Leverage the same Netdata experience our community is using

**Pros of using stable releases:**

  - Protect yourself from the rare instance when major bugs slip through our testing and negatively affect a Netdata installation
  - Retain more control over the Netdata version you use


## Automatic updates

By default, Netdata's installation scripts enable automatic updates for both nightly and stable release channels.

If you would prefer to manually update your Netdata agent, you can disable automatic updates by using the `--no-updates` option when you install or update Netdata using the [one-line installation script](#one-line-installation).

```bash
bash <(curl -Ss https://my-netdata.io/kickstart.sh) --no-updates
```

With automatic updates disabled, you can choose exactly when and how you [update Netdata](UPDATE.md).

[![analytics](https://www.google-analytics.com/collect?v=1&aip=1&t=pageview&_s=1&ds=github&dr=https%3A%2F%2Fgithub.com%2Fnetdata%2Fnetdata&dl=https%3A%2F%2Fmy-netdata.io%2Fgithub%2Finstaller%2FREADME&_u=MAC~&cid=5792dfd7-8dc4-476b-af31-da2fdb9f93d2&tid=UA-64295674-3)]()
