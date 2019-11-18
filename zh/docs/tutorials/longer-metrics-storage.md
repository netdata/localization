# 更改Netdata存储指标的时间


Netdata可帮助你每秒收集数千个系统和应用程序指标，但长期存储又如何呢？

许多人认为Netdata只能存储大约一个小时的实时指标，但这只是当今的默认配置。通过正确的设置，Netdata能够有效地存储价值数小时或数天的每秒历史数据，而不必依赖[后端](https://github.com/trisasnava/netdata/blob/master/backends)。

本教程提供了两个选项，用于配置Netdata以存储更多指标。 **我们建议使用[默认的数据库引擎](https://github.com/trisasnava/netdata/blob/master/docs/tutorials/longer-metrics-storage.md#using-the-database-engine)**，但是如果你愿意，可以坚持使用或切换到循环数据库。

让我们开始吧。

## 使用数据库引擎

数据库引擎使用RAM来存储最新指标，同时还使用“溢出到磁盘”功能，该功能利用可用磁盘空间来长期存储指标。数据库引擎的此功能使你可以存储比系统可用RAM大得多的数据集。

当前，数据库引擎是存储指标的默认方法，但是如果不确定使用的是哪个数据库，请检查 `netdata.conf` 文件并查找 ` memory mode ` 设置：

```
[global]
    memory mode = dbengine
```

如果将 `memory mode` 设置为 `dbengine` 以外的任何模式，请对其进行更改，然后使用标准命令重新启动Netdata以重新启动系统上的服务。你现在正在使用数据库引擎！

> 在我们的博客上了解有关我们如何实现数据库引擎及其未来愿景的更多信息：[如何以及为何将长期存储带入Netdata](https://blog.netdata.cloud/posts/db-engine/)。

是什么使数据库引擎高效？尽管其结构类似于传统数据库，但数据库引擎在RAM和磁盘之间拆分数据。数据库引擎在RAM上缓存和索引数据以保持较低的内存使用率，然后将较旧的指标压缩到磁盘上以进行长期存储。

当Netdata仪表板查询历史指标时，数据库引擎将使用存储在RAM中的缓存来返回相关指标以在图表中可视化。

现在，假设数据库引擎同时使用RAM和磁盘，则需要考虑其他两个设置：页面高速缓存大小和dbengine磁盘空间。

```
[global]
    page cache size = 32
    dbengine disk space = 256
```

` page cache size ` 设置数据库引擎将用于缓存和索引的最大RAM量（以MiB为单位）。  `dbengine disk space` 设置数据库引擎将用于存储压缩指标的最大磁盘空间（同样在MiB中）。

根据我们的测试，当Netdata每秒收集大约4,000个指标时，这些默认设置将保留大约一天的指标。如果增加 ` page cache size ` 或 ` dbengine disk space `，Netdata将保留更多历史指标。

但是，在你过分地更改这些选项之前，请先阅读[数据库引擎的内存占用量](https://github.com/trisasnava/netdata/blob/master/database/engine/README.md#memory-requirements)。

在数据库引擎处于活动状态的情况下，你可以将 ` /var/cache/netdata/dbengine/ ` 文件夹备份到另一个位置以实现冗余。

现在你已经知道如何切换到数据库引擎，下面为那些尚未准备好采取行动的用户介绍默认的轮询数据库。

## 使用轮询数据库


在以前的版本中，Netdata使用循环数据库来存储1小时的每秒指标。

要查看你是否仍在使用该数据库，或者是否要切换到该数据库，请打开 ` netdata.conf ` 文件，然后查看是否将 ` memory mode ` 选项设置为 ` save `。

```
[global]
    memory mode = save
```

如果将 ` memory mode ` 设置为 ` save `，那么你正在使用循环数据库。如果是这样，` history ` 选项将设置为3600，相当于3600秒或一小时。

要增加历史指标，可以将 ` history ` 增加到要存储的秒数：

```
[global]
    # 2 hours = 2 * 60 * 60 = 7200 seconds
    history = 7200
    # 4 hours = 4 * 60 * 60 = 14440 seconds
    history = 14440
    # 24 hours = 24 * 60 * 60 = 86400 seconds
    history = 86400
```

等等。

接下来，检查Netdata在你的系统上收集了多少度量，以及使用了多少RAM。然后访问Netdata仪表板，查看界面的右下角。你会发现类似于以下内容的句子：

> Netdata每秒收集1938个指标，将其显示在299个图表中，并通过81个警报进行监视。 Netdata在 **netdata-linux**上使用25 MB的内存以提供		1小时6分36秒的实时历史记录。

在此台式机系统上，使用Ryzen 5 1600和16GB RAM，循环数据库使用25 MB RAM来存储一个小时的数据，可用于近2,000个指标。

要增加 ` history ` 选项，你需要编辑 `netdata.conf` 文件并增加历史记录设置。在大多数安装中，可以在 `/etc/netdata/netdata.conf` 中找到它，但是某些操作系统将其放在 `/opt/netdata/etc/netdata/netdata.conf` 中。

使用 ` /etc/netdata/edit-config netdata.conf ` 或你喜欢的文本编辑器，将 `3600` 替换为你要存储的秒数。

你应该基于两件事来确定此数字：你的用例需要多少历史记录，以及你愿意为Netdata分配多少RAM。

> 在生产系统上更改 ` history ` 选项时请多加注意。 Netdata配置为在系统开始用完RAM时停止其进程，但是永远不要太小心。 内存不足的情况非常糟糕。

较长的历史记录将使用多少RAM？ 让我们使用一些数学。

Netdata收集的每个值循环数据库需要4个字节。 如果Netdata每秒收集一次指标，则每个指标每秒4个字节。

```
4 bytes * X seconds * Y metrics = RAM使用量（以字节为单位）
```

假设你的系统每秒收集1,000个指标。

```
4 bytes * 3600 seconds * 1,000 metrics = 14400000 bytes = 14.4 MB RAM
```

使用该公式，你可以计算更大历史记录设置的RAM使用率。

```
# 2小时,每秒1,000个指标
4 bytes * 7200 seconds * 1,000 metrics = 28800000 bytes = 28.8 MB RAM
# 2小时,每秒2,000个指标
4 bytes * 7200 seconds * 2,000 metrics = 57600000 bytes = 57.6 MB RAM
# 4小时，每秒2,000个指标
4 bytes * 14440 seconds * 2,000 metrics = 115520000 bytes = 115.52 MB RAM
# 24小时，每秒1,000个指标
4 bytes * 86400 seconds * 1,000 metrics = 345600000 bytes = 345.6 MB RAM
```

## 下一步是什么？


现在，你已经配置了数据库引擎或循环数据库引擎来存储更多指标，你可能希望看到它的实际效果！

有关如何平移图表以查看历史指标的更多信息，请参阅有关使用[图表](https://github.com/trisasnava/netdata/blob/master/web/README.md#using-charts)的文档。

而且，如果你现在想减少Netdata的资源使用，请查看我们的[性能指南](https://github.com/trisasnava/netdata/blob/master/docs/Performance.md)，以获取有关优化的最佳实践。