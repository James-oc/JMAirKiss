//
//  JMAirKissDiscovery.m
//  JMAirKiss
//
//  Created by shengxiao on 16/3/28.
//  Copyright © 2016年 shengxiao. All rights reserved.
//

#import "JMAirKissDiscovery.h"
#import "Defines.h"
#import "GCDAsyncUdpSocket.h"
#import "JMAirKissUtils.h"

#define kAirKiss_Port                    12476
#define kAirKiss_Host                    @"255.255.255.255"

@interface JMAirKissDiscovery()<GCDAsyncUdpSocketDelegate>
{
    NSMutableData       *_firstSenderData;
    NSMutableData       *_secondSenderData;
    
    NSMutableData       *_cmdDisResp;
    NSMutableData       *_cmdProResp;

    GCDAsyncUdpSocket   *_clientUdpSocket;
    GCDAsyncUdpSocket   *_serverUdpSocket;
    
    long                _tag;
    BOOL                _isSender;
}
@end

@implementation JMAirKissDiscovery

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initDatas];
        
        [self setupClientUdpSocket];
        
        [self setupServerUdpSocket];
    }
    return self;
}

#pragma mark - Init
- (void)initDatas {
    _timeInterVal    = 5;
    _firstSenderData = [NSMutableData data];
    _cmdDisResp      = [NSMutableData data];
    _cmdProResp      = [NSMutableData data];
    
    UInt8 fsInt8[kPrefix_Data_Length] = {
        kMagic_Num_0,kMagic_Num_1,kMagic_Num_2,kMagic_Num_3,
        kHead_Length_0,kHead_Length_1,kProto_Version_0,kProto_Version_1,
        0x00,0x00,0x00,0x20,
        kCMD_Discorvery_Req_0,kCMD_Discorvery_Req_1,kCMD_Discorvery_Req_2,kCMD_Discorvery_Req_3,
        0x00,0x00,0x00,0x00,
        0x00,0x00,0x00,0x00,
        0x00,0x00,0x00,0x00,
        0x00,0x00,0x00,0x00,
    };
    
    for (int i = 0; i < kPrefix_Data_Length; i++) {
        [_firstSenderData appendBytes:&fsInt8[i] length:1];
    }

    UInt8 drCMDInt8[kCMD_Bytes_Num] = {
        kCMD_Discorvery_Resp_0,kCMD_Discorvery_Resp_1,kCMD_Discorvery_Resp_2,kCMD_Discorvery_Resp_3,
    };
    
    for (int i = 0; i < kCMD_Bytes_Num; i++) {
        [_cmdDisResp appendBytes:&drCMDInt8[i] length:1];
    }
    
    UInt8 prCMDInt8[kCMD_Bytes_Num] = {
        kCMD_Get_Dev_Pro_Resp_0,kCMD_Get_Dev_Pro_Resp_1,kCMD_Get_Dev_Pro_Resp_2,kCMD_Get_Dev_Pro_Resp_3,
    };
    
    for (int i = 0; i < kCMD_Bytes_Num; i++) {
        [_cmdProResp appendBytes:&prCMDInt8[i] length:1];
    }
    
    NSString *secondSenderJsonStr = @"{\"deviceInfo\":{\"deviceType\":\"wechat\", \"deviceId\":\"wechat\"}}";
    _secondSenderJsonData = [NSMutableData dataWithData:[secondSenderJsonStr dataUsingEncoding:NSUTF8StringEncoding]];
}

#pragma mark - set up udp socket
- (void)setupClientUdpSocket {
    NSError *error = nil;
    
    if (!_clientUdpSocket) {
        _clientUdpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        [_clientUdpSocket enableBroadcast:YES error:&error];
    }
    
    if (![_clientUdpSocket bindToPort:0 error:&error])
    {
        return;
    }
    
    if (![_clientUdpSocket beginReceiving:&error])
    {
        return;
    }
}

- (void)setupServerUdpSocket {
    if (!_serverUdpSocket) {
        _serverUdpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        [_serverUdpSocket enableBroadcast:YES error:nil];
    }
    
    NSError *error = nil;
    
    if (![_serverUdpSocket bindToPort:kAirKiss_Port error:&error])
    {
        return;
    }
    
    if (![_serverUdpSocket beginReceiving:&error])
    {
        return;
    }
}

#pragma mark - Discovery
- (void)discoverDevices {
    _tag              = 0;
    _isSender         = true;
    _secondSenderData = [NSMutableData data];

    UInt8 ssInt8[kPrefix_Data_Length] = {
        kMagic_Num_0,kMagic_Num_1,kMagic_Num_2,kMagic_Num_3,
        kHead_Length_0,kHead_Length_1,kProto_Version_0,kProto_Version_1,
        0x00,0x00,0x00,0x00,    // 0x00,0x00,0x00,0x5b
        kCMD_Get_Dev_Pro_Req_0,kCMD_Get_Dev_Pro_Req_1,kCMD_Get_Dev_Pro_Req_2,kCMD_Get_Dev_Pro_Req_3,
        0x00,0x00,0x00,0x01,
        0x00,0x00,0x00,0x00,    // 0xb5,0x46,0xbf,0x96,
        0x00,0x00,0x00,0x00,
        0x00,0x00,0x00,0x00,
    };
    
    UInt8 *newSSInt8 = [JMAirKissUtils calcTotalLenInt8:(_secondSenderJsonData.length + kPrefix_Data_Length)
                                             prefixData:ssInt8];
    newSSInt8        = [JMAirKissUtils calcCheckNumInt8:_secondSenderJsonData
                                             prefixData:newSSInt8];
    
    for (int i = 0; i < kPrefix_Data_Length; i++) {
        [_secondSenderData appendBytes:&newSSInt8[i] length:1];
    }
    
    [_secondSenderData appendData:_secondSenderJsonData];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while (_isSender) {
            [_clientUdpSocket sendData:_firstSenderData
                                toHost:kAirKiss_Host
                                  port:kAirKiss_Port
                           withTimeout:-1 tag:_tag];
            
            [NSThread sleepForTimeInterval:_timeInterVal];
            
            _tag++;
        }
    });
}

- (void)closeDiscovery {
    _isSender = NO;
    
    [_clientUdpSocket close];
    [_serverUdpSocket close];
    
    _clientUdpSocket = nil;
    _serverUdpSocket = nil;
}

#pragma mark - GCDAsyncUdpSocketDelegate
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
    // You could add checks here
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
    // You could add checks here
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data
      fromAddress:(NSData *)address
withFilterContext:(id)filterContext
{
    if (_serverUdpSocket == sock) {
        if (data != nil && data.length > kPrefix_Data_Length) {
            NSData *jsonData         = [data subdataWithRange:NSMakeRange(kPrefix_Data_Length, data.length - kPrefix_Data_Length)];
            NSData *respCmdData      = [data subdataWithRange:NSMakeRange(kCMD_Start_Index, kCMD_Bytes_Num)];

            NSData *respTotalLenData = [data subdataWithRange:NSMakeRange(kTotalLength_Start_Index, kTotalLength_Bytes_Num)];
            NSData *calcTotalLenData = [JMAirKissUtils calcTotalLenData:data.length];// 长度

            NSData *respCheckNum     = [data subdataWithRange:NSMakeRange(kCheckNum_Start_Index, kCheckNum_Bytes_Num)];
            NSData *calcCheckNum     = [JMAirKissUtils calcCheckNumData:jsonData];
            
            if (([respCheckNum isEqualToData:calcCheckNum]) && ([respTotalLenData isEqualToData:calcTotalLenData])) {
                NSString *host = nil;
                uint16_t port  = 0;
                
                [GCDAsyncUdpSocket getHost:&host
                                      port:&port
                               fromAddress:address];
                
                NSDictionary *jsonInfo      = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
                JMAirKissDisDevSucType type = JMAirKissDisDevSucTypeWithNone;
                
                if ([respCmdData isEqualToData:_cmdDisResp]) {
                    // CMD_DISCOVER_RESP
                    type = JMAirKissDisDevSucTypeWithDisResp;
                    
                    [_serverUdpSocket sendData:_secondSenderData toHost:host port:kAirKiss_Port withTimeout:-1 tag:_tag];
                    _tag++;
                }else if ([respCmdData isEqualToData:_cmdProResp]) {
                    // CMD_GET_DEVICE_PROFILE_RESP
                    type = JMAirKissDisDevSucTypeWithProResp;
                }
                
                if (_airKissDiscoveryDeviceSuc != nil) {
                    _airKissDiscoveryDeviceSuc(jsonInfo,host,type);
                }
            }
        }
    }
}

@end
