# 构建Netdata静态二进制分发包

要构建Netdata静态二进制64位分发包，请运行：

```bash
$ cd /path/to/netdata.git
$ ./packaging/makeself/build-x86_64-static.sh
```

这个脚本会进行以下工作:

1. 使用Alpine Linux设置一个新的Docker容器
2. 安装所需的alpine包（构建环境，依赖等）
3. 下载并编译与Netdata一同打包的第三方应用程序（包括但不限于`bash`，`curl`）
4. 编译Netdata

当其完成后，一个名为`netdata-vX.X.X-gGITHASH-x86_64-DATE-TIME.run`的文件将会在当前目录中被创建。这是Netdata的二进制包，它可以在其他计算机上安装Netdata。

---

## 使用调试信息构建二进制静态分发包

要使用调试/跟踪信息构建Netdata二进制静态分发包，请使用以下命令：

```bash
$ cd /path/to/netdata.git
$ ./packaging/makeself/build-x86_64-static.sh debug
```

这些二进制文件没有进行过优化（它们的运行速度较慢），且它们的某些功能被禁用了（如日志溢出保护），但是，它的其他功能启用（如`debug flags`）并不会被剥离（注意：二进制文件较大，因为它包括了源代码跟踪信息）。

#### 调试Netdata二进制文件

一旦您安装了包含调试信息的二进制分发包，您就必须安装`valgrind`并运行此命令来启动Netdata：

```bash
PATH="/opt/netdata/bin:${PATH}" valgrind --undef-value-errors=no /opt/netdata/bin/srv/netdata -D
```

上面的这条命令，将会在`valgrind`下运行Netdata。即使Netdata在`valgrind`下运行，但是速度还是会慢10倍并且会占用更多的内存。

如果Netdata崩溃，`valgrind`将输出问题的堆栈跟踪。请您打开一个Github问题让我们知道这一问题的发生。

要在`valgrind`下停止运行netdata，请在控制台上按Control-C。

> 如果您在valgrind中省略了参数`--undef-value-errors = no`，您将会获得有关依赖未初始化的数百个错误。这是正常的。Valgrind具有启发式功能，它可以防止系统库打印此类错误，但对于静态Netdata二进制文件，所有必需的库都已经内置于Netdata中。因此，valgrind无法应用其启发式功能。

[![analytics](https://www.google-analytics.com/collect?v=1&aip=1&t=pageview&_s=1&ds=github&dr=https%3A%2F%2Fgithub.com%2Fnetdata%2Fnetdata&dl=https%3A%2F%2Fmy-netdata.io%2Fgithub%2Fmakeself%2FREADME&_u=MAC~&cid=5792dfd7-8dc4-476b-af31-da2fdb9f93d2&tid=UA-64295674-3)]()
