## 卸载Netdata

Netdata包含了自动卸载程序，它可以把Netdata从您的服务器中完整地删除。卸载程序仅需要“.environment”文件，这个文件是被安装程序创建的，它应在${NETDATA_USER_CONFIG_DIR} 中(其默认位置应为： /etc/netdata/.environment)。此文件包含一些安装程序留下的参数，这些参数在卸载过程中是必需的。其主要有两个参数：
```
NETDATA_PREFIX
NETDATA_ADDED_TO_GROUPS
```

卸载流程如下：

1. 找到你的“.environment”文件
2. 如果您找不到该文件，请创建包含以下内容的新文件：
```
NETDATA_PREFIX="<installation prefix>"   # put what you used as a parameter to shell installed `--install` flag. Otherwise it should be empty
NETDATA_ADDED_TO_GROUPS="<additional groups>"  # Additional groups for a user running netdata process
```
3. 运行： ./packaging/installer/netdata-uninstaller.sh --yes --env <path_to_environment_file>
4. 卸载完成

注意：此卸载方法是为“使用netdata-installer.sh或kickstart脚本进行安装”的用户而编写的。如果您使用的是包管理器来安装Netdata，使用这一方法可能无法成功地卸载。

译者注：请以英语原版为准

[![analytics](https://www.google-analytics.com/collect?v=1&aip=1&t=pageview&_s=1&ds=github&dr=https%3A%2F%2Fgithub.com%2Fnetdata%2Fnetdata&dl=https%3A%2F%2Fmy-netdata.io%2Fgithub%2Finstaller%2FUNINSTALL&_u=MAC~&cid=5792dfd7-8dc4-476b-af31-da2fdb9f93d2&tid=UA-64295674-3)]()
