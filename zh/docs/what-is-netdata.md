# Netdata概述

[![Build Status](https://travis-ci.com/netdata/netdata.svg?branch=master)](https://travis-ci.com/netdata/netdata) [![CII Best Practices](https://bestpractices.coreinfrastructure.org/projects/2231/badge)](https://bestpractices.coreinfrastructure.org/projects/2231) [![License: GPL v3+](https://img.shields.io/badge/License-GPL%20v3%2B-blue.svg)](https://www.gnu.org/licenses/gpl-3.0) [![analytics](https://www.google-analytics.com/collect?v=1&aip=1&t=pageview&_s=1&ds=github&dr=https%3A%2F%2Fgithub.com%2Fnetdata%2Fnetdata&dl=https%3A%2F%2Fmy-netdata.io%2Fgithub%2Freadme&_u=MAC~&cid=5792dfd7-8dc4-476b-af31-da2fdb9f93d2&tid=UA-64295674-3)]()

[![Code Climate](https://codeclimate.com/github/netdata/netdata/badges/gpa.svg)](https://codeclimate.com/github/netdata/netdata) [![Codacy Badge](https://api.codacy.com/project/badge/Grade/a994873f30d045b9b4b83606c3eb3498)](https://www.codacy.com/app/netdata/netdata?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=netdata/netdata&amp;utm_campaign=Badge_Grade) [![LGTM C](https://img.shields.io/lgtm/grade/cpp/g/netdata/netdata.svg?logo=lgtm)](https://lgtm.com/projects/g/netdata/netdata/context:cpp) [![LGTM JS](https://img.shields.io/lgtm/grade/javascript/g/netdata/netdata.svg?logo=lgtm)](https://lgtm.com/projects/g/netdata/netdata/context:javascript) [![LGTM PYTHON](https://img.shields.io/lgtm/grade/python/g/netdata/netdata.svg?logo=lgtm)](https://lgtm.com/projects/g/netdata/netdata/context:python)

---

**Netdata** 是一个用于**监测系统及应用性能和健康状况**的监控工具，有**分布式**、**实时性**等特点，经过了高度优化，并可安装到各种系统和容器之上。

Netdata可以**实时且无与伦比地洞察**系统内运行的所有程序的运行状况，包括网络服务器、数据库、应用程序等。它既可以独立运行而不依靠其他第三方组件，也可以整合到现有的监控工具链之中，如Prometheus，Graphite，OpenTSDB，Kafka，Grafana等。

_Netdata的设计宗旨在于**快速性**和**高效性**，要保证它能够永久性地在所有系统上运行——包括**物理**及**虚拟**服务器、**容器**、**物联网**设备等，同时要避免所在系统的核心功能受到它的阻碍。_

Netdata是**免费的开源软件**，目前支持的系统包括**Linux**，**FreeBSD**和**MacOS**。

---

## 用户界面

下面的GIF动图是一个Netdata控制板界面的示例。

![peek 2018-11-11 02-40](https://user-images.githubusercontent.com/2662304/48307727-9175c800-e55b-11e8-92d8-a581d60a4889.gif)

*上图为以正常速度运行的Netdata控制板示例。用户可以通过拖动来平移图表，也可以按住`SHIFT`键后利用鼠标滚轮来对图表进行缩放；如需放大图表上某一特定区域，则可按住`SHIFT`键后用鼠标选出该区域。Netdata具有高度可互动性和**实时性**，专为完成工作而优化！*

> *对Netdata用户体验有兴趣者请参见我们网站上的在线演示：[https://www.netdata.cloud](https://www.netdata.cloud/#live-demo)*

## 用户群

Netdata的用户来自世界各地，有成千上万之众。
具体请查看我们在[Github上的观察者名单](https://github.com/netdata/netdata/watchers)。
这些人来自不同的企业及组织，包括**亚马逊**、**源讯**、**百度**、**思科**、**思杰**、**德国电信**、**爱立信**、**谷歌**、**惠普**、**华为**、**微软**、**英伟达**，以及**DigitalOcean**，**Elastic**，**EPAM Systems**，**Groupon**，**Hortonworks**，**IBM**，**NewRelic**，**Red Hat**，**SAP**，**Selectel**，**TicketMaster**，**Vimeo**等众多企业。

### Docker镜像

我们对多数架构都提供了对应的Docker镜像，以下是来自Docker Hub仓库的统计数据：

[![netdata/netdata (official)](https://img.shields.io/docker/pulls/netdata/netdata.svg?label=netdata/netdata+%28official%29)](https://hub.docker.com/r/netdata/netdata/) [![firehol/netdata (deprecated)](https://img.shields.io/docker/pulls/firehol/netdata.svg?label=firehol/netdata+%28deprecated%29)](https://hub.docker.com/r/firehol/netdata/) [![titpetric/netdata (donated)](https://img.shields.io/docker/pulls/titpetric/netdata.svg?label=titpetric/netdata+%28third+party%29)](https://hub.docker.com/r/titpetric/netdata/)

### 注册站

当你安装了多个Netdata程序的时候，它们会被[Netdata注册站](../registry/#registry)整合为一个**分布式应用**。注册站是网页浏览器上的功能，可以让我们对用户及安装的Netdata服务器进行计数。下列数据来自我们运行的全球公共Netdata注册站：

[![User Base](https://registry.my-netdata.io/api/v1/badge.svg?chart=netdata.registry_entries&dimensions=persons&label=user%20base&units=M&value_color=blue&precision=2&divide=1000000&v43)](https://registry.my-netdata.io/#menu_netdata_submenu_registry) [![Monitored Servers](https://registry.my-netdata.io/api/v1/badge.svg?chart=netdata.registry_entries&dimensions=machines&label=servers%20monitored&units=k&divide=1000&value_color=orange&precision=2&v43)](https://registry.my-netdata.io/#menu_netdata_submenu_registry) [![Sessions Served](https://registry.my-netdata.io/api/v1/badge.svg?chart=netdata.registry_sessions&label=sessions%20served&units=M&value_color=yellowgreen&precision=2&divide=1000000&v43)](https://registry.my-netdata.io/#menu_netdata_submenu_registry)

*过去24小时内的数据:*\
[![New Users Today](https://registry.my-netdata.io/api/v1/badge.svg?chart=netdata.registry_entries&dimensions=persons&after=-86400&options=unaligned&group=incremental-sum&label=new%20users%20today&units=null&value_color=blue&precision=0&v42)](https://registry.my-netdata.io/#menu_netdata_submenu_registry) [![New Machines Today](https://registry.my-netdata.io/api/v1/badge.svg?chart=netdata.registry_entries&dimensions=machines&group=incremental-sum&after=-86400&options=unaligned&label=servers%20added%20today&units=null&value_color=orange&precision=0&v42)](https://registry.my-netdata.io/#menu_netdata_submenu_registry) [![Sessions Today](https://registry.my-netdata.io/api/v1/badge.svg?chart=netdata.registry_sessions&after=-86400&group=incremental-sum&options=unaligned&label=sessions%20served%20today&units=null&value_color=yellowgreen&precision=0&v42)](https://registry.my-netdata.io/#menu_netdata_submenu_registry)

## 为什么要选择Netdata

对于系统监控，Netdata选择了一条不一样的道路。

Netdata能够安装到各种系统之上，并可以用作：

- **指标收集器**： 可整理系统及应用程序（如网络服务器、数据库、容器等）的指标度量数据
- **时间序列数据库**： 可将所有数据都存储在内存中（且不会在运行过程中进行磁盘读写）
- **可视化工具**： 可实现快捷、可互动、现代化的异常检测
- **预警装置**：可及时发现性能及可用性方面的问题

所有以上功能都整合在了这样一个高度灵活、模块化、分布式的应用之中。

下表显示了Netdata与其他系统监测工具的对比：

Netdata|其他工具（开源或商业软件）
:---:|:---:
**高精度度量**（可精确到1秒）|低精度度量（最多可精确到10秒）
可监测一切，**每个节点上千个指标**|只能监测少数几个指标
超高速的用户界面，专为**异常检测**而优化|抽象的用户界面
利用**直观的展示方式**帮助你理解各项指标|需要你提前学习各项指标的含义
安装完成**之刻**即为得到结果**之时**|得到结果前需要做耗时的准备工作
可用于**排除故障**，以解决性能问题|只可用于*统计过去的性能表现*
**无需控制界面**即可追踪性能表现|只有利用控制界面才能排查性能故障
**无需专有资源**|需要大量专有资源

Netdata是**免费**的**开源**软件，具有**高速性**、**易用性**、**公开性**、**灵活性**等优势，并可方便地整合到各种框架之中。

Netdata的设计团队拥有**系统管理**、**运维（DevOps）**及**开发**的背景，其设计宗旨在与解决性能问题，而不仅仅是让性能指标可视化。

## 运作流程

Netdata是一个高效率、高模块化的指标管理引擎，它的无锁设计使其成为对性能指标进行并发操作的理想工具。

![image](https://user-images.githubusercontent.com/2662304/48323827-b4c17580-e636-11e8-842c-0ee72fcb4115.png)

以下是其运作流程:

功能|概述|文档
:---:|:---|:---:
**收集**|性能指标由多个独立的计算节点来平行处理，它们在各自的数据源上会利用对每个程序最优的协议来收集并推送性能指标数据到底层数据库。每个数据收集节点对其所收集的性能指标数据拥有无锁的写入权限。|[`收集器`](../collectors/#data-collection-plugins)
**存储**|性能指标数据会以圆形队列形式存储在主存之中，形成一个轮询调度型数据库。为减小内存占用量，数据会以一种自定义的浮点数形式进行存储。|[`数据库`](../database/#database)
**检查**|一个独立且无锁的“监控员”会对性能指标数据进行**健康检查**，同时负责触发警报、记录有关性能健康状况的事务日志，以及配发报警通知等任务。|[`健康状况`](../health/#health-monitoring)
**成流**|一个独立且无锁的计算节点会将收集上来的性能指标的详细信息实时地转为数据流并发送给Netdata的远程服务器。|[`数据流`](../streaming/#streaming-and-replication)
**归档**|一个独立且无锁的计算节点会对性能指标数据进行下采样，并将其推送至**后端**时序数据库中。|[`后端`](../backends/)
**查询**|[内部网络服务器](../web/server/#web-server)下属的多个独立计算节点会处理API请求，包括[数据查询请求](../web/api/queries/#database-queries)。|[`网络API`](../web/api/#api)

这样我们就能得到一个高效率、低延迟的系统，以保证每项指标上有多个计算节点拥有读取权限，单个计算节点拥有写入权限。

## 信息图

下图为Netdata功能及架构的概念图，你可以通过点击图片上不同区域来阅读相关文档。

[![image](https://user-images.githubusercontent.com/43294513/60951037-8ba5d180-a2f8-11e9-906e-e27356f168bc.png)](https://my-netdata.io/infographic.html)

## Features

![finger-video](https://user-images.githubusercontent.com/2662304/48346998-96cf3180-e685-11e8-9f4e-059d23aa3aa5.gif)

This is what you should expect from Netdata:

### General
- **1s granularity** - the highest possible resolution for all metrics.
- **Unlimited metrics** - collects all the available metrics, the more the better.
- **1% CPU utilization of a single core** - it is super fast, unbelievably optimized.
- **A few MB of RAM** - by default it uses 25MB RAM. [You size it](../database).
- **Zero disk I/O** - while it runs, it does not load or save anything (except `error` and `access` logs).
- **Zero configuration** - auto-detects everything, it can collect up to 10000 metrics per server out of the box.
- **Zero maintenance** - You just run it, it does the rest.
- **Zero dependencies** - it is even its own web server, for its static web files and its web API (though its plugins may require additional libraries, depending on the applications monitored).
- **Scales to infinity** - you can install it on all your servers, containers, VMs and IoTs. Metrics are not centralized by default, so there is no limit.
- **Several operating modes** - Autonomous host monitoring (the default), headless data collector, forwarding proxy, store and forward proxy, central multi-host monitoring, in all possible configurations. Each node may have different metrics retention policy and run with or without health monitoring.

### Health Monitoring & Alarms
- **Sophisticated alerting** - comes with hundreds of alarms, **out of the box**! Supports dynamic thresholds, hysteresis, alarm templates, multiple role-based notification methods.
- **Notifications**: [alerta.io](../health/notifications/alerta/), [amazon sns](../health/notifications/awssns/), [discordapp.com](../health/notifications/discord/), [email](../health/notifications/email/), [flock.com](../health/notifications/flock/), [irc](../health/notifications/irc/), [kavenegar.com](../health/notifications/kavenegar/), [messagebird.com](../health/notifications/messagebird/), [pagerduty.com](../health/notifications/pagerduty/), [prowl](../health/notifications/prowl/), [pushbullet.com](../health/notifications/pushbullet/), [pushover.net](../health/notifications/pushover/), [rocket.chat](../health/notifications/rocketchat/), [slack.com](../health/notifications/slack/), [smstools3](../health/notifications/smstools3/), [syslog](../health/notifications/syslog/), [telegram.org](../health/notifications/telegram/), [twilio.com](../health/notifications/twilio/), [web](../health/notifications/web/) and [custom notifications](../health/notifications/custom/).

### Integrations
- **time-series dbs** - can archive its metrics to **Graphite**, **OpenTSDB**, **Prometheus**, **AWS Kinesis**, **JSON document DBs**, in the same or lower resolution (lower: to prevent it from congesting these servers due to the amount of data collected). Netdata also supports **Prometheus remote write API** which allows storing metrics to **Elasticsearch**, **Gnocchi**, **InfluxDB**, **Kafka**, **PostgreSQL/TimescaleDB**, **Splunk**, **VictoriaMetrics** and a lot of other [storage providers](https://prometheus.io/docs/operating/integrations/#remote-endpoints-and-storage).

## Visualization

- **Stunning interactive dashboards** - mouse, touchpad and touch-screen friendly in 2 themes: `slate` (dark) and `white`.
- **Amazingly fast visualization** - responds to all queries in less than 1 ms per metric, even on low-end hardware.
- **Visual anomaly detection** - the dashboards are optimized for detecting anomalies visually.
- **Embeddable** - its charts can be embedded on your web pages, wikis and blogs. You can even use [Atlassian's Confluence as a monitoring dashboard](../web/gui/confluence/).
- **Customizable** - custom dashboards can be built using simple HTML (no javascript necessary).

### Positive and negative values

To improve clarity on charts, Netdata dashboards present **positive** values for metrics representing `read`, `input`, `inbound`, `received` and **negative** values for metrics representing `write`, `output`, `outbound`, `sent`.

![positive-and-negative-values](https://user-images.githubusercontent.com/2662304/48309090-7c5c6180-e57a-11e8-8e03-3a7538c14223.gif)

*Netdata charts showing the bandwidth and packets of a network interface. `received` is positive and `sent` is negative.*

### Autoscaled y-axis

Netdata charts automatically zoom vertically, to visualize the variation of each metric within the visible time-frame.

![non-zero-based](https://user-images.githubusercontent.com/2662304/48309139-3d2f1000-e57c-11e8-9a44-b91758134b00.gif)

*A zero based `stacked` chart, automatically switches to an auto-scaled `area` chart when a single dimension is selected.*

### Charts are synchronized

Charts on Netdata dashboards are synchronized to each other. There is no master chart. Any chart can be panned or zoomed at any time, and all other charts will follow.

![charts-are-synchronized](https://user-images.githubusercontent.com/2662304/48309003-b4fb3b80-e578-11e8-86f6-f505c7059c15.gif)

*Charts are panned by dragging them with the mouse. Charts can be zoomed in/out with`SHIFT` + `mouse wheel` while the mouse pointer is over a chart.*

> The visible time-frame (pan and zoom) is propagated from Netdata server to Netdata server, when navigating via the [node menu](../registry#registry).

### Highlighted time-frame

To improve visual anomaly detection across charts, the user can highlight a time-frame (by pressing `ALT` + `mouse selection`) on all charts.

![highlighted-timeframe](https://user-images.githubusercontent.com/2662304/48311876-f9093300-e5ae-11e8-9c74-e3e291741990.gif)

*A highlighted time-frame can be given by pressing `ALT` + `mouse selection` on any chart. Netdata will highlight the same range on all charts.*

> Highlighted ranges are propagated from Netdata server to Netdata server, when navigating via the [node menu](../registry#registry).


## What does it monitor

Netdata data collection is **extensible** - you can monitor anything you can get a metric for.
Its [Plugin API](../collectors/plugins.d/) supports all programing languages (anything can be a Netdata plugin, BASH, python, perl, node.js, java, Go, ruby, etc).

- For better performance, most system related plugins (cpu, memory, disks, filesystems, networking, etc) have been written in `C`.
- For faster development and easier contributions, most application related plugins (databases, web servers, etc) have been written in `python`.

#### APM (Application Performance Monitoring)
- **[statsd](../collectors/statsd.plugin/)** - Netdata is a fully featured statsd server.
- **[Go expvar](../collectors/python.d.plugin/go_expvar/)** - collects metrics exposed by applications written in the Go programming language using the expvar package.
- **[Spring Boot](../collectors/python.d.plugin/springboot/)** - monitors running Java Spring Boot applications that expose their metrics with the use of the Spring Boot Actuator included in Spring Boot library.
- **[uWSGI](../collectors/python.d.plugin/uwsgi/)** - collects performance metrics from uWSGI applications.

#### System Resources
- **[CPU Utilization](../collectors/proc.plugin/)** - total and per core CPU usage.
- **[Interrupts](../collectors/proc.plugin/)** - total and per core CPU interrupts.
- **[SoftIRQs](../collectors/proc.plugin/)** - total and per core SoftIRQs.
- **[SoftNet](../collectors/proc.plugin/)** - total and per core SoftIRQs related to network activity.
- **[CPU Throttling](../collectors/proc.plugin/)** - collects per core CPU throttling.
- **[CPU Frequency](../collectors/proc.plugin/)** - collects the current CPU frequency.
- **[CPU Idle](../collectors/proc.plugin/)** - collects the time spent per processor state.
- **[IdleJitter](../collectors/idlejitter.plugin/)** - measures CPU latency.
- **[Entropy](../collectors/proc.plugin/)** - random numbers pool, using in cryptography.
- **[Interprocess Communication - IPC](../collectors/proc.plugin/)** - such as semaphores and semaphores arrays.

#### Memory
- **[ram](../collectors/proc.plugin/)** - collects info about RAM usage.
- **[swap](../collectors/proc.plugin/)** - collects info about swap memory usage.
- **[available memory](../collectors/proc.plugin/)** - collects the amount of RAM available for userspace processes.
- **[committed memory](../collectors/proc.plugin/)** - collects the amount of RAM committed to userspace processes.
- **[Page Faults](../collectors/proc.plugin/)** - collects the system page faults (major and minor).
- **[writeback memory](../collectors/proc.plugin/)** - collects the system dirty memory and writeback activity.
- **[huge pages](../collectors/proc.plugin/)** - collects the amount of RAM used for huge pages.
- **[KSM](../collectors/proc.plugin/)** - collects info about Kernel Same Merging (memory dedupper).
- **[Numa](../collectors/proc.plugin/)** - collects Numa info on systems that support it.
- **[slab](../collectors/proc.plugin/)** - collects info about the Linux kernel memory usage.

#### Disks
- **[block devices](../collectors/proc.plugin/)** - per disk: I/O, operations, backlog, utilization, space, etc.
- **[BCACHE](../collectors/proc.plugin/)** - detailed performance of SSD caching devices.
- **[DiskSpace](../collectors/proc.plugin/)** - monitors disk space usage.
- **[mdstat](../collectors/proc.plugin/)** - software RAID.
- **[hddtemp](../collectors/python.d.plugin/hddtemp/)** - disk temperatures.
- **[smartd](../collectors/python.d.plugin/smartd_log/)** - disk S.M.A.R.T. values.
- **[device mapper](../collectors/proc.plugin/)** - naming disks.
- **[Veritas Volume Manager](../collectors/proc.plugin/)** - naming disks.
- **[megacli](../collectors/python.d.plugin/megacli/)** - adapter, physical drives and battery stats.
- **[adaptec_raid](../collectors/python.d.plugin/adaptec_raid/)** -  logical and physical devices health metrics.
- **[ioping](../collectors/ioping.plugin/)** - to measure disk read/write latency.

#### Filesystems
- **[BTRFS](../collectors/proc.plugin/)** - detailed disk space allocation and usage.
- **[Ceph](../collectors/python.d.plugin/ceph/)** - OSD usage, Pool usage, number of objects, etc.
- **[NFS file servers and clients](../collectors/proc.plugin/)** - NFS v2, v3, v4: I/O, cache, read ahead, RPC calls
- **[Samba](../collectors/python.d.plugin/samba/)** - performance metrics of Samba SMB2 file sharing.
- **[ZFS](../collectors/proc.plugin/)** - detailed performance and resource usage.

#### Networking
- **[Network Stack](../collectors/proc.plugin/)** - everything about the networking stack (both IPv4 and IPv6 for all protocols: TCP, UDP, SCTP, UDPLite, ICMP, Multicast, Broadcast, etc), and all network interfaces (per interface: bandwidth, packets, errors, drops).
- **[Netfilter](../collectors/proc.plugin/)** - everything about the netfilter connection tracker.
- **[SynProxy](../collectors/proc.plugin/)** - collects performance data about the linux SYNPROXY (DDoS).
- **[NFacct](../collectors/nfacct.plugin/)** - collects accounting data from iptables.
- **[Network QoS](../collectors/tc.plugin/)** - the only tool that visualizes network `tc` classes in real-time
- **[FPing](../collectors/fping.plugin/)** - to measure latency and packet loss between any number of hosts.
- **[ISC dhcpd](../collectors/python.d.plugin/isc_dhcpd/)** - pools utilization, leases, etc.
- **[AP](../collectors/charts.d.plugin/ap/)** - collects Linux access point performance data (`hostapd`).
- **[SNMP](../collectors/node.d.plugin/snmp/)** - SNMP devices can be monitored too (although you will need to configure these).
- **[port_check](../collectors/python.d.plugin/portcheck/)** - checks TCP ports for availability and response time.

#### Virtual Private Networks
- **[OpenVPN](../collectors/python.d.plugin/ovpn_status_log/)** - collects status per tunnel.
- **[LibreSwan](../collectors/charts.d.plugin/libreswan/)** - collects metrics per IPSEC tunnel.
- **[Tor](../collectors/python.d.plugin/tor/)** - collects Tor traffic statistics.

#### Processes
- **[System Processes](../collectors/proc.plugin/)** - running, blocked, forks, active.
- **[Applications](../collectors/apps.plugin/)** - by grouping the process tree and reporting CPU, memory, disk reads, disk writes, swap, threads, pipes, sockets - per process group.
- **[systemd](../collectors/cgroups.plugin/)** - monitors systemd services using CGROUPS.

#### Users
- **[Users and User Groups resource usage](../collectors/apps.plugin/)** - by summarizing the process tree per user and group, reporting: CPU, memory, disk reads, disk writes, swap, threads, pipes, sockets
- **[logind](../collectors/python.d.plugin/logind/)** - collects sessions, users and seats connected.

#### Containers and VMs
- **[Containers](../collectors/cgroups.plugin/)** - collects resource usage for all kinds of containers, using CGROUPS (systemd-nspawn, lxc, lxd, docker, kubernetes, etc).
- **[libvirt VMs](../collectors/cgroups.plugin/)** - collects resource usage for all kinds of VMs, using CGROUPS.
- **[dockerd](../collectors/python.d.plugin/dockerd/)** - collects docker health metrics.

#### Web Servers
- **[Apache and lighttpd](../collectors/python.d.plugin/apache/)** - `mod-status` (v2.2, v2.4) and cache log statistics, for multiple servers.
- **[IPFS](../collectors/python.d.plugin/ipfs/)** - bandwidth, peers.
- **[LiteSpeed](../collectors/python.d.plugin/litespeed/)** - reads the litespeed rtreport files to collect metrics.
- **[Nginx](../collectors/python.d.plugin/nginx/)** - `stub-status`, for multiple servers.
- **[Nginx+](../collectors/python.d.plugin/nginx_plus/)** - connects to multiple nginx_plus servers (local or remote) to collect real-time performance metrics.
- **[PHP-FPM](../collectors/python.d.plugin/phpfpm/)** - multiple instances, each reporting connections, requests, performance, etc.
- **[Tomcat](../collectors/python.d.plugin/tomcat/)** - accesses, threads, free memory, volume, etc.
- **[web server `access.log` files](../collectors/python.d.plugin/web_log/)** - extracting in real-time, web server and proxy performance metrics and applying several health checks, etc.
- **[HTTP check](../collectors/python.d.plugin/httpcheck/)** - checks one or more web servers for HTTP status code and returned content.

#### Proxies, Balancers, Accelerators
- **[HAproxy](../collectors/python.d.plugin/haproxy/)** - bandwidth, sessions, backends, etc.
- **[Squid](../collectors/python.d.plugin/squid/)** - multiple servers, each showing: clients bandwidth and requests, servers bandwidth and requests.
- **[Traefik](../collectors/python.d.plugin/traefik/)** - connects to multiple traefik instances (local or remote) to collect API metrics (response status code, response time, average response time and server uptime).
- **[Varnish](../collectors/python.d.plugin/varnish/)** - threads, sessions, hits, objects, backends, etc.
- **[IPVS](../collectors/proc.plugin/)** - collects metrics from the Linux IPVS load balancer.

#### Database Servers
- **[CouchDB](../collectors/python.d.plugin/couchdb/)** - reads/writes, request methods, status codes, tasks, replication, per-db, etc.
- **[MemCached](../collectors/python.d.plugin/memcached/)** - multiple servers, each showing: bandwidth, connections, items, etc.
- **[MongoDB](../collectors/python.d.plugin/mongodb/)** - operations, clients, transactions, cursors, connections, asserts, locks, etc.
- **[MySQL and mariadb](../collectors/python.d.plugin/mysql/)** - multiple servers, each showing: bandwidth, queries/s, handlers, locks, issues, tmp operations, connections, binlog metrics, threads, innodb metrics, and more.
- **[PostgreSQL](../collectors/python.d.plugin/postgres/)** - multiple servers, each showing: per database statistics (connections, tuples read - written - returned, transactions, locks), backend processes, indexes, tables, write ahead, background writer and more.
- **[Proxy SQL](../collectors/python.d.plugin/proxysql/)** - collects Proxy SQL backend and frontend performance metrics.
- **[Redis](../collectors/python.d.plugin/redis/)** - multiple servers, each showing: operations, hit rate, memory, keys, clients, slaves.
- **[RethinkDB](../collectors/python.d.plugin/rethinkdbs/)** - connects to multiple rethinkdb servers (local or remote) to collect real-time metrics.

#### Message Brokers
- **[beanstalkd](../collectors/python.d.plugin/beanstalk/)** - global and per tube monitoring.
- **[RabbitMQ](../collectors/python.d.plugin/rabbitmq/)** - performance and health metrics.

#### Search and Indexing
- **[ElasticSearch](../collectors/python.d.plugin/elasticsearch/)** - search and index performance, latency, timings, cluster statistics, threads statistics, etc.

#### DNS Servers
- **[bind_rndc](../collectors/python.d.plugin/bind_rndc/)** - parses `named.stats` dump file to collect real-time performance metrics. All versions of bind after 9.6 are supported.
- **[dnsdist](../collectors/python.d.plugin/dnsdist/)** - performance and health metrics.
- **[ISC Bind (named)](../collectors/node.d.plugin/named/)** - multiple servers, each showing: clients, requests, queries, updates, failures and several per view metrics. All versions of bind after 9.9.10 are supported.
- **[NSD](../collectors/python.d.plugin/nsd/)** - queries, zones, protocols, query types, transfers, etc.
- **[PowerDNS](../collectors/python.d.plugin/powerdns/)** - queries, answers, cache, latency, etc.
- **[unbound](../collectors/python.d.plugin/unbound/)** - performance and resource usage metrics.
- **[dns_query_time](../collectors/python.d.plugin/dns_query_time/)** - DNS query time statistics.

#### Time Servers
- **[chrony](../collectors/python.d.plugin/chrony/)** - uses the `chronyc` command to collect chrony statistics (Frequency, Last offset, RMS offset, Residual freq, Root delay, Root dispersion, Skew, System time).
- **[ntpd](../collectors/python.d.plugin/ntpd/)** - connects to multiple ntpd servers (local or remote) to provide statistics of system variables and optional also peer variables.

#### Mail Servers
- **[Dovecot](../collectors/python.d.plugin/dovecot/)** - POP3/IMAP servers.
- **[Exim](../collectors/python.d.plugin/exim/)** - message queue (emails queued).
- **[Postfix](../collectors/python.d.plugin/postfix/)** - message queue (entries, size).

#### Hardware Sensors
- **[IPMI](../collectors/freeipmi.plugin/)** - enterprise hardware sensors and events.
- **[lm-sensors](../collectors/python.d.plugin/sensors/)** - temperature, voltage, fans, power, humidity, etc.
- **[Nvidia](../collectors/python.d.plugin/nvidia_smi/)** - collects information for Nvidia GPUs.
- **[RPi](../collectors/charts.d.plugin/sensors/)** - Raspberry Pi temperature sensors.
- **[w1sensor](../collectors/python.d.plugin/w1sensor/)** - collects data from connected 1-Wire sensors.

#### UPSes
- **[apcupsd](../collectors/charts.d.plugin/apcupsd/)** - load, charge, battery voltage, temperature, utility metrics, output metrics
- **[NUT](../collectors/charts.d.plugin/nut/)** - load, charge, battery voltage, temperature, utility metrics, output metrics
- **[Linux Power Supply](../collectors/proc.plugin/)** - collects metrics reported by power supply drivers on Linux.

#### Social Sharing Servers
- **[RetroShare](../collectors/python.d.plugin/retroshare/)** - connects to multiple retroshare servers (local or remote) to collect real-time performance metrics.

#### Security
- **[Fail2Ban](../collectors/python.d.plugin/fail2ban/)** - monitors the fail2ban log file to check all bans for all active jails.

#### Authentication, Authorization, Accounting (AAA, RADIUS, LDAP) Servers
- **[FreeRadius](../collectors/python.d.plugin/freeradius/)** - uses the `radclient` command to provide freeradius statistics (authentication, accounting, proxy-authentication, proxy-accounting).

#### Telephony Servers
- **[opensips](../collectors/charts.d.plugin/opensips/)** - connects to an opensips server (localhost only) to collect real-time performance metrics.

#### Household Appliances
- **[SMA webbox](../collectors/node.d.plugin/sma_webbox/)** - connects to multiple remote SMA webboxes to collect real-time performance metrics of the photovoltaic (solar) power generation.
- **[Fronius](../collectors/node.d.plugin/fronius/)** - connects to multiple remote Fronius Symo servers to collect real-time performance metrics of the photovoltaic (solar) power generation.
- **[StiebelEltron](../collectors/node.d.plugin/stiebeleltron/)** - collects the temperatures and other metrics from your Stiebel Eltron heating system using their Internet Service Gateway (ISG web).

#### Game Servers
- **[SpigotMC](../collectors/python.d.plugin/spigotmc/)** - monitors Spigot Minecraft server ticks per second and number of online players using the Minecraft remote console.

#### Distributed Computing
- **[BOINC](../collectors/python.d.plugin/boinc/)** - monitors task states for local and remote BOINC client software using the remote GUI RPC interface. Also provides alarms for a handful of error conditions.

#### Media Streaming Servers
- **[IceCast](../collectors/python.d.plugin/icecast/)** - collects the number of listeners for active sources.

### Monitoring Systems
- **[Monit](../collectors/python.d.plugin/monit/)** - collects metrics about monit targets (filesystems, applications, networks).

#### Provisioning Systems
- **[Puppet](../collectors/python.d.plugin/puppet/)** - connects to multiple Puppet Server and Puppet DB instances (local or remote) to collect real-time status metrics.

You can easily extend Netdata, by writing plugins that collect data from any source, using any computer language.

## Community

We welcome [contributions](../CONTRIBUTING.md). So, feel free to join the team.

To report bugs, or get help, use [GitHub Issues](https://github.com/netdata/netdata/issues).

You can also find Netdata on:

- [Facebook](https://www.facebook.com/linuxnetdata/)
- [Twitter](https://twitter.com/linuxnetdata)
- [OpenHub](https://www.openhub.net/p/netdata)
- [Repology](https://repology.org/metapackage/netdata/versions)
- [StackShare](https://stackshare.io/netdata)

## License

Netdata is [GPLv3+](../LICENSE).

Netdata re-distributes other open-source tools and libraries. Please check the [third party licenses](../REDISTRIBUTED.md).