# 入门

这是您**安装后**的第一步。如果您还没有安装完成，请查阅：[安装教程](../packaging/installer).

## 访问Netdata仪表板

要访问Netdata仪表板，请使用浏览器导航至：

```
http://your.server.ip:19999/
```

<details markdown="1"><summary>如果这不起作用，请单击此处</summary>

**检查Netdata是否正在运行**

首先，请连接到您的服务器，然后执行`sudo ps -e|grep netdata`命令。它应该打印出Netdata守护进程的PID。如果其没有被打印，则Netdata没有在运行。请查阅[安装教程](../packaging/installer)来重新安装Netdata。

**检查Netdata是否响应HTTP请求。**

执行命令：`curl -Ss http://localhost:19999`。它应该在你的屏幕上打印出（输出）Netdata仪表板的`index.html`页面。如果您运行了这条命令却没有任何反应，请查阅[安装教程](../packaging/installer)来重新安装Netdata。

**检查Netdata是否收到HTTP请求。**

执行命令：`tail -f /var/log/netdata/access.log`（如果安装了静态64位软件包，请使用：`tail -f /opt/netdata/var/log/netdata/access.log`）。此命令将在屏幕上打印Netdata收到的所有HTTP请求。

接下来，请尝试使用您的Web浏览器来访问Netdata仪表板。如果您的屏幕上没有任何内容，则HTTP请求没有被传送到Netdata。

如果您不确定您的服务器IP，请运行以下命令：`ip route get 8.8.8.8 | grep -oP " src [0-9\.]+ "`。这将会把您服务器的IP地址打印出来。

如果Netdata仍未收到HTTP请求，那或许是有一些东西阻止了数据的传输。这可能是防火墙，也可能是其它安全策略。请检查您的网络后重试。

</details>&nbsp;<br/>

当您安装了多个Netdata服务器时，所有的服务器都将被显示在仪表板左上角的“my-netdata”菜单中。因此，您必须手动访问每个Netdata服务器的仪表板。

`my-netdata`菜单不仅仅是一个仪表盘导航。当从该菜单中切换其它的Netdata服务器时，当前Netdata仪表盘中的任何设置都将被传播到其他的Netdata服务器：

- 当前数据图表的平移（向左或向右拖动图表）
- 当前数据图表的缩放（把鼠标移动到图表上：按住`SHIFT`并滚动`鼠标滚轮`）
- 突出显示的时间范围（按住`ALT`并选择图表上的某一个区域）
- 仪表板的滚动位置
- 你使用的主题
- _以及更多其它的设置_

这些数据都被发送到其他的Netdata服务器，以便您可以轻松地解决跨服务器的性能问题。

## 启动和停止Netdata

Netdata安装程序已经将Netdata集成到您的init/systemd环境中了。

要启动/停止Netdata，您应该根据您的环境来选择不同的命令：

- `systemctl start netdata`和`systemctl stop netdata`
- `service netdata start`和`service netdata stop`
- `/etc/init.d/netdata start`和`/etc/init.d/netdata stop`

安装程序已将Netdata配置为在服务器启动时自动启动并在关闭服务器时自动停止。

有关这些命令的更多信息，请参阅您的系统文档。

## 调整Netdata设置

Netdata的默认安装是为小型服务器配置的：只储存1个小时的数据。您应该根据您的系统所具有的内存以及可以专用于Netdata的数据储存容量来对此进行调整。在RAM有限的服务器上，我们建议将其设置为3-4小时。为了获得最佳效果，您可以将其设置为24小时或48小时。

对于存储1小时的数据，Netdata仅需要大约25MB的RAM。如果您可以将大约100MB的RAM专用于Netdata，则可以将储存历史数据的时间设置为4个小时（依此类推）。

为此，您应该编辑`/etc/netdata/netdata.conf`（或`/opt/netdata/etc/netdata/netdata.conf`）并设置：

```
[global]
    history = SECONDS
```

请确保`history`行没有被注释（注释行以`＃`开头）。

1小时=3600秒，因此您设置的值应为`HOURS*3600`的结果。

!!! 请注意
    在生产系统上设置时要尤其小心，如果将这个值设置得太高，内存可能会被耗尽。在默认的情况下，当内存快被消耗完毕时，Netdata会被系统强制停止，但最好还是避免这一个问题的发生。

有关Netdata内存需求的更多信息，请[查看此页面](../database)。

如果您的内核支持KSM（大部分的内核都支持），您可以查阅：[启用KSM让Netdata的内存使用减半](../database#ksm)。

## 服务发现和自动检测

Netdata支持自动检测数据源。它可以自动检测几乎所有内容，例如：数据库服务器，Web服务器，DNS服务器等。

当Netdata启动时，此自动检测过程仅发生**一次**。要让Netdata重新检测数据源，您需要重新启动它。但是，这里有一些例外：

- 容器和VM将永久自动检测（当Netdata在主机上运行时都会执行）
- 虽然Netdata收集了许多数据源，但在默认情况下是静默的，直到我们收集到一些有用的信息（例如网络接口丢弃了数据包，将在数据包被丢弃后出现）
- 按照默认设置，Netdata会忽略一些无法稳定收集信息的服务
- 我们收到用户反馈的服务。这些服务在监控时会引发一些问题，在默认情况下也会被禁用（例如，默认情况下会禁用`chrony`服务，因为当数据被收集时，CentOS会发布一个CPU使用率为100%的假数据）

当Netdata检测到新的数据源时，我们不会马上从中开始收集数据，直到Netdata被重新启动。因此，如果您停止了Web服务器，Netdata将在再次启动时开始收集它的数据。

由于Netdata安装在您的系统上（或者在容器内里），因此自动检测仅运行于`localhost`上。这大大简化了Netdata监控基础架构的安全模型，因为大多数的应用程序默认允许`localhost`的访问。

一些众所周知但需要配置的的数据源是：

- 在大多数系统中，默认情况下不会公开[systemd services utilization](../collectors/cgroups.plugin/#monitoring-systemd-services)，因此必须配置`systemd`以公开这些指标。

## 配置快速启动

在Netdata中我们有：

- **internal**数据收集插件（在Netdata守护进程内运行）
- **external**数据收集插件（独立进程，通过一些方法将数据传输到Netdata）
- 模块化插件**orchestrators**（具有多个数据收集模块的外部插件）

您可以通过``[plugins]`部分的`netdata.conf`来启用和禁用插件（内部和外部的插件）。

所有插件都在`netdata.conf`中都有专门的一部分，比如`[plugin:XXX]`，用于设置它们的数据收集频率并为它们编写额外的命令行选项。

所有外部插件都有自己的`.conf`文件。

所有模块化插件在`/etc/netdata`中都有一个专门的目录，每个模块都有一个`.conf`文件。

这很复杂。那么，让我们来看一下`python.d.plugin`的`nginx`模块的整个配置树：

在`[plugins]`部分的`netdata.conf`中，可以启用或禁用`python.d.plugin`：

```
[plugins]
    python.d = yes
```

在`[plugin:python.d]`部分的`netdata.conf`中，我们可以为`python.d.plugin`编写额外的命令行选项，并设置它的数据收集频率：

```
[plugin:python.d]
	update every = 1
	command options = 
```

`python.d.plugin`有自己的配置文件，用于启用和禁用它的一些模块（例如，您可以禁用`nginx`模块）：

```bash
sudo /etc/netdata/edit-config python.d.conf
```

然后，`nginx`有自己的配置文件来配置它的数据收集作业（大多数的模块可以从多个数据源来收集数据，因此`nginx`模块可以从多个服务器，本地或远程的`nginx`服务器中来收集指标）：

```bash
sudo /etc/netdata/edit-config python.d/nginx.conf
```

## 运行状况监视和警报

Netdata提供了数百个的运行状况监视提醒，用于检测异常的情况。并且，它们针对生产服务器进行了优化

许多用户在工作站上安装Netdata，并且对Netdata自带的默认警报感到厌烦。在这种情况下，我们建议您禁用健康监测。

要禁用它，请编辑`/etc/netdata/netdata.conf`（如果您是使用静态64位软件分发包来安装Netdata的，则请编辑`/opt/netdata/etc/netdata/netdata.conf`）并设置：

```
[health]
    enabled = no
```

以上设置将完全禁用运行状况监视。

如果您要为仪表板启用运行状况监视，但要禁用电子邮件通知，请运行以下命令：

```bash
sudo /etc/netdata/edit-config health_alarm_notify.conf
```

并且设定`SEND_EMAIL="NO"`.

(如果您是使用静态64位软件分发包来安装Netdata的，请执行`sudo /opt/netdata/etc/netdata/edit-config health_alarm_notify.conf`).

## 接下来有什么？

- 查阅[数据收集](../collectors)以配置数据收集插件
- 查阅[运行状况监控](../health)以配置自己的警报或设置警报通知。
- 查阅[Streaming](../streaming)以集中Netdata指标。
- 查阅[后端](../backends)，以便将Netdata指标储存到数据库中。

[![analytics](https://www.google-analytics.com/collect?v=1&aip=1&t=pageview&_s=1&ds=github&dr=https%3A%2F%2Fgithub.com%2Fnetdata%2Fnetdata&dl=https%3A%2F%2Fmy-netdata.io%2Fgithub%2Fdocs%2FGettingStarted&_u=MAC~&cid=5792dfd7-8dc4-476b-af31-da2fdb9f93d2&tid=UA-64295674-3)]()
