# JMAirKiss
### iOS App集成AirKiss技术（基于GCDAsyncUdpSocket）
---

## 设置

以下是示例参考代码：

```OC
_airKissConnection = [[JMAirKissConnection alloc] init];
_airKissConnection.connectionSuccess = ^() {
    // 连接成功操作
};
        
_airKissConnection.connectionFailure = ^() {
    // 连接失败操作
 };

[_airKissConnection connectAirKissWithSSID:<＃WiFi_SSID＃> withPSW:<＃WiFI_Password＃>];
```

## 作者
James.xiao

