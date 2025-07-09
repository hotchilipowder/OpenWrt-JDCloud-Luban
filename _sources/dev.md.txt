# How to include sbox

鲁班的CPU是 MT7621AT+512M运存。
官方的配置不包括, 需要自己编译。


> linux-mipsle-softfloat，linux-mipsle-hardfloat
  着两个都行，
  一个是硬件运算，另一个是软件运算

>   你只能选择 linux-mipsle-softfloat
MT7621 没有硬件浮点计算的指令集

添加了相关的github脚本，可以成功的编译，然后看到可以用 `upx`，继续尝试。

```
GOARCH=mipsle GOMIPS=softfloat GOOS=linux CGO_ENABLED=0 go build -trimpath -ldflags '-X "github.com/sagernet/sing-box/constant.Version=${{ needs.calculate_version.outputs.version }}" -s -buildid=' -tags "with_gvisor with_quic with_dhcp with_ech with_utls with_reality_server with_clash_api" -o dist/sing-box ./cmd/sing-box
```

see [my sing-box for 7621](https://github.com/hotchilipowder/sing-box)





## Useful Links:

+ https://github.com/qichiyuhub/EasySingbox
+ https://memo.xuchen.wang/archives/144.html
+ https://github.com/yichya/openwrt-xray/issues/3
+ https://www.right.com.cn/forum/thread-8387992-1-1.html


What I have tried
-----------------

1.   
1. 试过了在一个没有安装如下的系统上进行


