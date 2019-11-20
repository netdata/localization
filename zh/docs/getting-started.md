# 入门指南

感谢你使用 Netdata ！在本指南中，我们将快速引导你完成获取后应采取的第一步已安装Netdata。

Netdata无需任何配置即可实时收集数千个指标，但是有一些有价值的东西要知道根据你的需求充分利用Netdata。

>如果尚未安装Netdata，请访问[安装说明](../packaging/installer)了解详细信息，
>包括我们的单行脚本，该脚本会在几乎所有 Linux 发行版上自动安装 Netdata。

## 访问 Netdata 仪表板
****
打开你选择的Web浏览器，然后导航到http://YOUR-HOST:19999。欢迎使用 Netdata ！

![导航到仪表板的GIF动画](https://user-images.githubusercontent.com/1153921/63463901-fcb9c800-c412-11e9-8f67-8fe182e8b0d2.gif)

**下一步是什么？**:

-   阅读有关[标准Netdata仪表板](../web/gui/)的更多信息。

-   了解[使用图表](../web/README.md#using-charts)的所有细节或[图表，上下文和族谱](../web/README.md#charts-contexts-families)

##基本配置

Netdata主要使用`netdata.conf`文件进行自定义配置。

在大多数系统上，你可以在`/etc/netdata/netdata.conf`中找到该文件。

>有些操作系统会将你的`netdata.conf`放置在`/opt/netdata/etc/netdata/netdata.conf`中，因此请检查是否存在
>你在`/etc/netdata/netdata.conf`中找不到任何内容。

`netdata.conf`文件分为多个部分，例如`[global]`，`[web]`，`[registry]`等。 通过
默认情况下，大多数选项都带有注释，因此你必须取消注释（删除`＃`），Netdata 才能识别你的
更改。

保存更改后，请[重新启动 Netdata](＃start-stop-and-restart-netdata)加载新配置。

**下一步是什么？**：

-   通过增加`历史记录`来[更改Netdata存储指标的时间](＃change-how-long-netdata-stores-metrics)选项或切换到数据库引擎。
-   将 Netdata 的仪表板移至[不同端口](https://docs.netdata.cloud/web/server/)或启用TLS / HTTPS加密。
-   请参阅我们的[daemon配置文档](../daemon/config/)中的所有`netdata.conf`选项。
-   运行自己的[注册表](../registry/README.md#run-your-own-registry)。

##从更多来源收集数据

当Netdata启动时，它将自动检测数十个`数据源`，例如数据库服务器，Web服务器等。 要从刚刚安装的服务或应用程序中自动检测并收集指标，你需要[重新启动Netdata](＃start-stop-and-restart-netdata)。

>有一个例外：Netdata在主机上运行时（例如不在容器本身中运行），它将始终自动检测容器和虚拟机。

但是，仅当你使用源的标准安装过程安装了源时，自动检测才有效。 如果是Netdata
重新启动后未收集指标，则你的来源可能配置不正确。 看一下[外部插件
文档](../collectors/plugins.d/)找到适合你的源代码的模块。 这些页面将包含更多
有关如何配置源以进行自动检测的信息。

某些模块（例如chrony）在默认情况下处于禁用状态，必须手动启用才能自动检测工作。

Netdata一旦检测到有效的数据源，它将继续尝试从中收集数据。 例如，如果Netdata正在从Nginx Web服务器收集数据，并且你关闭了Nginx，则Netdata将在你启动Web服务器备份时立即收集新数据-无需重新启动。

###配置插件

即使Netdata自动检测你的服务/应用程序，你也可能需要配置Netdata的内容或频率
收集数据。

Netdata使用**内部**和**外部**插件来收集数据。内部插件在Netdata守护进程中运行，而外部插件是独立的进程，可通过管道将指标发送到Netdata。还有一些插件**编排器**，它们是具有一个或多个数据收集**模块**的外部插件。

你可以同时配置内部和外部插件以及各个模块。 有很多方法可以做到这一点：

-   在`netdata.conf`中的`[plugins]`部分,使用`yes`或`no`启用或禁用内部或外部插件。
-   在`netdata.conf`中的[plugin:XXX]部分中，每个插件都有一个部分，用于更改收集频率或将选项传递给该插件。
-   在每个外部插件的`.conf`文件中,例如:在`/etc/netdata/python.d.conf`中。
-   在每个模块的`conf`文件中,例如：在`/etc/netdata/python.d/nginx.conf`中。

它很复杂，因此让我们来看一个示例。各个.conf文件负责使用nginx模块和python.d插件Orchestrator从Nginx Web服务器收集数据。

首先，你可以完全在`netdata.conf`中启用或禁用`python.d`插件。

```conf
[plugins]
    # Enabled
    python.d = yes
    # Disabled
    python.d = no
```

你还可以通过netdata.conf中的`[plugin:python.d]`部分来配置整个`python.d`外部插件。
在这里，你可以更改Netdata使用`python.d`收集度量标准或传递其他命令选项的频率：

```conf
[plugin:python.d]
    update every = 1
    command options = 
```

`python.d`插件在`/etc/netdata/python.d.conf`中具有一个单独的配置文件，用于启用和禁用模块。 你可以使用`edit-config`脚本来编辑文件，或者使用你选择的文本编辑器打开文件：

```bash
sudo /etc/netdata/edit-config python.d.conf
```

最后，nginx模块在`python.d`文件夹中有一个名为`nginx.conf`的配置文件。 同样，使用`edit-config`或你选择的编辑器：

```bash
sudo /etc/netdata/edit-config python.d/nginx.conf
```

在`nginx.conf`文件中，你会找到其他选项。 默认设置适用于大多数情况，但是你可能需要根据特定的Nginx设置进行更改。

**下一步是什么？**：

-   查看[数据收集模块的完整列表](Add-more-charts-to-netdata.md#available-data-collection-modules)，以配置用于自动检测和监视的源。
-   提高Netdata在低内存系统上的[性能](Performance.md)。
-   配置`systemd`以自动公开[系统服务利用率](../collectors/cgroups.plugin/README.md#monitoring-systemd-services) 指标。
-   `netdata.conf`中的[重新配置单个图表](../daemon/config/README.md#per-chart-configuration)。

##健康监控和警报

Netdata带有数百种运行状况监视警报，用于检测生产服务器上的异常。 如果你在工作站上运行Netdata，则可能要禁用Netdata的警报。

编辑你的`/etc/netdata/netdata.conf`文件并设置以下内容：

```conf
[health]
    enabled = no
```

如果你想保持健康监控功能，但关闭电子邮件通知，请使用`edit-config`或你选择的文本编辑器编辑`health_alarm_notify.conf`文件：

```bash
sudo /etc/netdata/edit-config health_alarm_notify.conf
```

查找`SEND_EMAIL="YES"` 行将其改为`SEND_EMAIL="NO"`。

**下一步是什么？**：

-   使用[示例](../health/README.md#examples)编写你自己的健康警报。
-   添加新的通知方法，例如[Slack](../health/notifications/slack/)。

## Change how long Netdata stores metrics
## 更改Netdata存储指标的时间

默认情况下，Netdata使用自定义数据库，该数据库同时使用RAM和磁盘来存储指标。 最近的度量标准存储在系统的RAM中，以保持快速访问，而历史度量标准则“堆积”到磁盘上，以保持较低的RAM使用率。

这个自定义数据库（我们称为_database engine_）使您可以存储比系统可用RAM大得多的数据集。

如果不确定使用数据库引擎还是要调整默认设置来存储更多历史指标，请查看我们的教程：[**更改Netdata存储指标的时间**](../docs/tutorials/longer-metrics-storage.md)。

**What's next?**:

-   了解有关[数据库引擎的内存要求](../database/engine/README.md#memory-requirements)的更多信息，以了解应承诺多少RAM或者磁盘空间来存储历史指标。
-   阅读有关[循环数据库](../database/)的内存要求，或弄清楚您的系统是否启用了KSM，这可以[减少默认数据库的内存使用量](../database/README.md#ksm)的大约60％。

## 使用Netdata监视多个系统

如果您在多个系统上安装了Netdata，则可以将它们全部显示在仪表板左上角的**我的节点**菜单中。

要在该菜单中显示所有服务器，您需要[注册或登录](../docs/netdata-cloud/signing-in.md)到[Netdata Cloud](../docs/netdata-cloud/)。然后，每个系统将显示在“我的节点”菜单中，您可以使用该菜单在系统之间快速导航。

![的我的节点菜单中的GIF动画](https://user-images.githubusercontent.com/1153921/64389938-9aa7b800-cff9-11e9-9653-a77e791811ad.gif)

每当平移，缩放，突出显示，选择或暂停图表时，Netdata都会通过我的节点菜单将这些设置与您访问的任何其他代理进行同步。即使滚动位置也已同步，所以您将看到相同的图表和相应的数据，以便进行比较或根本原因分析。

现在，您可以无缝跟踪整个基础架构中的性能异常！

**下一步是什么？**：

-   阅读有关[Netdata Cloud注册表的工作原理](../registry/)，以及它存储并发送到Web浏览器的数据类型的信息。
-   熟悉[节点视图](../docs/netdata-cloud/nodes-view.md)

## Start, stop, and restart Netdata
## 启动，停止和重新启动Netdata

安装Netdata时，它被配置为在引导时启动，然后停止并重新启动/关闭。 您不需要手动启动或停止Netdata，但是您可能需要在某个时候重新启动Netdata。

-   要**启动** Netdata，请打开一个终端并运行`service netdata start`。
-   要**停止** Netdata，运行`service netdata stop`。
-   要**重新启动** Netdata，请运行`service netdata restart`。

`service`命令是一个包装器脚本，它尝试使用系统首选的基于系统启动或停止Netdata的方法。 但是，如果这些命令中的任何一个失败，请尝试对`systemd`和`init.d`使用等效命令：

-   **systemd**：`systemctl start netdata`，`systemctl stop netdata`，`systemctl restart netdata`。
-   **init.d**: `/etc/init.d/netdata start`, `/etc/init.d/netdata stop`, `/etc/init.d/netdata restart`。

##下一步是什么？

即使您已经配置了`netdata.conf`，调整了警报，了解了性能疑难解答的基本知识并将所有系统添加到**我的节点**菜单中，您才刚刚开始使用Netdata。

看一些更高级的功能和配置：

-   使用[流](../streaming)集中来自许多系统的Netdata指标
-   通过[后端](../backends)到时间序列数据库启用Netdata指标的长期归档。
-   通过将Netdata放在[带有SSL的Nginx代理](Running-behind-nginx.md)的后面来提高安全性。

或者，了解更多有关如何为[Netdata core](../CONTRIBUTING.md)或我们的[documentation](../docs/contributing/contributing-documentation.md)做出贡献的信息！

[![analytics](https://www.google-analytics.com/collect?v=1&aip=1&t=pageview&_s=1&ds=github&dr=https%3A%2F%2Fgithub.com%2Fnetdata%2Fnetdata&dl=https%3A%2F%2Fmy-netdata.io%2Fgithub%2Fdocs%2FGettingStarted&_u=MAC~&cid=5792dfd7-8dc4-476b-af31-da2fdb9f93d2&tid=UA-64295674-3)](<>)

