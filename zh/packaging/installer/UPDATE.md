# 如何在安装后更新Netdata？

![image8](https://cloud.githubusercontent.com/assets/2662304/14253735/536f4580-fa95-11e5-9f7b-99112b31a5d7.gif)

我们强烈建议您使用最新的版本，因为我们正在不断地开发并完善它。

更新方法取决于你如何安装的Netdata：

## 如果你是使用Git从我们的GitHub储存库中下载安装的

### 手动更新

在`v1.12.0-rc2-52`版本前，我们使用`netdata-updater.sh`脚本以获取更新，但它现在已被弃用了。现在我们使用`netdata-installer.sh`脚本。安装程序会保留您的设置，并在用户配置目录下的`.environment`文件中更新安装信息。

```sh
# 转到下载目录
cd /path/to/git/downloaded/netdata

# 下载最新的版本
git pull

# 运行Netdata安装程序
sudo ./netdata-installer.sh
```

_Netdata将会以最新的版本为你服务_

请注意：Netdata现在可能有新的功能，或者某些旧的功能现在表现不同。在更新后请注意这些变化。

### 手动获取每日更新

如果运行如下命令，`kickstart.sh`one-liner将对最新的每日更新进行一次性更新：
```
bash <(curl -Ss https://my-netdata.io/kickstart.sh) --no-updates
```

### 自动升级

_请您慎重考虑自动更新的风险。有些事情或许会出错。请密切关注它，如果自动更新出现了故障，请手动进行更新。_

如果你运行`netdata-installer.sh`脚本并带上`--auto-update`或`-u`参数时，它会在`/etc/cron.daily/`或`/etc/periodic/daily/`处生成`netdata-updater`脚本。每当`netdata-updater`被执行时，它会检查是否有更新的每日更新，然后下载并安装它们。

请注意，2019年1月之后，`kickstart.sh`one liner` bash<（curl-ss https://my netdata.io/kickstart.sh）`使用自动更新选项调用`netdata installer.sh`。因此，如果你只运行了一次没有参数的命令，你的Netdata仍将保持自动更新。

## 如果是您使用二进制包安装的

如果您使用二进制包安装了Netdata，最好的方法是从分发商中**获取一个更新的**安装副本（注意：这包括通过`kickstart-base64.sh`进行的二进制安装，它需要被再次执行）。

如果您从源代码中找不到更新版本的Netdata，我们建议您卸载您现在的版本，并按照[安装文档](README.md)中的说明安装新版本的Netdata。

译者注：请以英语原版为准

[![analytics](https://www.google-analytics.com/collect?v=1&aip=1&t=pageview&_s=1&ds=github&dr=https%3A%2F%2Fgithub.com%2Fnetdata%2Fnetdata&dl=https%3A%2F%2Fmy-netdata.io%2Fgithub%2Finstaller%2FUPDATE&_u=MAC~&cid=5792dfd7-8dc4-476b-af31-da2fdb9f93d2&tid=UA-64295674-3)]()
