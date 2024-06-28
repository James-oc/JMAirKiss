# JMAirKiss
### iOS App集成AirKiss技术实现智能设备快速联网（基于GCDAsyncUdpSocket）
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

[_airKissConnection connectAirKissWithSSID:<＃WiFi_SSID＃> 
                                  password:<＃WiFI_Password＃>];
```
## 通用SDK生成
### 切换到JMAirKissAggregate，CMD + B生成通用SDK
<img src="https://github.com/James-oc/JMShareSource/raw/master/screenshots/OC/JMAirKiss/Img_Aggregate.png?raw=true" height="480">

## 作者
James.xiao

