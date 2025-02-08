# SBOX的一些配置注释

## Tun

使用Tun模式配置简单，只需要配置 `/etc/config/network` 和 `/etc/config/firewall` 即可。
然后在 /tmp/sing-box里面下载文件，启动 `/tmp/sing-box/sing-box run -c /tmp/sing-box/config.json` 即可。

  
:::{attention}

`/tmp`一般是挂在到内存中的，使用 tmpfs 文件系统。
tmpfs是一种基于内存的虚拟文件系统,它最大的特点就是它的存储空间在VM(virtual memory)里面,VM是由linux内核里面的vm子系统管理，现在大多数操作系统都采用了虚拟内存管理机制。

使用tmpfs设备（内存）挂载到 /tmp目录，
主要是为了让log之类的散碎文件在内存中读写，
一是加快速度，二是减小对flash/tf/emmc/hdd等存储设备的读写…

:::

因此，需要编写一个脚本，能够定时的检测是否挂掉了, 并且更新配置。


```{literalinclude} ../../files/etc/sbox/sbox_tun.sh
```

### 安装步骤

使用本固件，很多的默认配置已经完成了，因此不需要再配置 接口和防火墙了 （如果需要配置，查看 References)

需要添加的配置：

1. `/etc/sbox/sbox_tun.sh` 中的 `SBOX_URL`
2. `/etc/sbox/sbox_tun.sh` 中的 `SBOX_CONFIG_URL`
3. `/etc/crontabs/root` 中启用 `0 1 * * * sh /etc/sbox/sbox_tun.sh` (删除 `#`， 这样就会每天1点更新, 使用 `crontab -l` 查看是否生效)
4. 添加开机脚本：`sh /etc/sbox/sbox_tun.sh` (为了确保开机后运行)


### Issues

但是这个Tun模式有一个核心的问题，以MTK7961A为例，只能跑到20Mbps左右，并且由于所有的流量都走tun，所以直连的速度也起不来。

而大哥亚瑟虽然变强了很多，IPQ6000，但是仍然只能跑到100Mbps，这简直无法用啊。遂放弃，改用Tproxy。



## Tproxy

使用Tproxy的最大问题就是需要配置 nftables 或者 iptables.

查看了References的一些配置，完成了如下的两个文件，可以实现。

```{literalinclude} ../../files/etc/sbox/sbox_tproxy_start.sh
```

```{literalinclude} ../../files/etc/sbox/sbox_tproxy_stop.sh
```

为了减少复杂配置，所以就不去修改 `/etc/init.d/sing-box` 中的配置了，而是修改 `sbox_tproxy.sh`文件，将上述两个网络操作的脚本放到监控脚本中执行。


### 安装步骤

需要添加的配置：

1. `/etc/sbox/sbox_tproxy.sh` 中的 `SBOX_URL`
2. `/etc/sbox/sbox_tproxy.sh` 中的 `SBOX_CONFIG_URL`
3. `/etc/crontabs/root` 中启用 `0 1 * * * sh /etc/sbox/sbox_tproxy.sh` (删除 `#`， 这样就会每天1点更新, 使用 `crontab -l` 查看是否生效)
4. 添加开机脚本：`sh /etc/sbox/sbox_tproxy.sh` (为了确保开机后运行, 也可以 `sleep 100` 然后再执行 `sh /etc/sbox/sbox_tproxy.sh`)


## References


1. [(tun模式)进行路由代理](https://www.aprdec.top/openwrt-%E4%BD%BF%E7%94%A8sing-boxtun%E6%A8%A1%E5%BC%8F%E8%BF%9B%E8%A1%8C%E8%B7%AF%E7%94%B1%E4%BB%A3%E7%90%86/)
2. [Tproxy代理-恩山](https://www.right.com.cn/forum/thread-8387992-1-1.html)
3. [tun代理-恩山](https://www.right.com.cn/forum/thread-8387992-1-1.html)
4. [Sing-box自动订阅运行脚本](https://github.com/qichiyuhub/EasySingbox)
