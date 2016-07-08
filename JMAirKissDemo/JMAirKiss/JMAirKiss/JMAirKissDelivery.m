//
//  JMAirKissDelivery.m
//  JMAirKiss
//
//  Created by shengxiao on 16/3/28.
//  Copyright © 2016年 shengxiao. All rights reserved.
//

#import "JMAirKissDelivery.h"
#import "GCDAsyncSocket.h"
#import "Defines.h"
#import "JMAirKissUtils.h"

@interface JMAirKissDelivery()<GCDAsyncSocketDelegate>
{
    GCDAsyncSocket      *_tcpSocket;
    NSMutableData       *_senderData;
    uint16_t            _port;
    NSString            *_host;
    int                 _tag;
    NSMutableData       *_calcCmdData;
}
@end

@implementation JMAirKissDelivery

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initDatas];
    }
    return self;
}

- (void)initDatas {
    _host = @"";
    _port = 0;
    _tag  = 1000;
    
    _calcCmdData = [NSMutableData data];
    UInt8 ssInt8[kCMD_Bytes_Num] = {
        kCMD_User_Dev_Ser_Resp_0,kCMD_User_Dev_Ser_Resp_1,kCMD_User_Dev_Ser_Resp_2,kCMD_User_Dev_Ser_Resp_3,
    };
    
    for (int i = 0; i < kCMD_Bytes_Num; i++) {
        [_calcCmdData appendBytes:&ssInt8[i] length:1];
    }
}

- (void)deliverData:(NSData *)data
           withHost:(NSString *)host
               port:(uint16_t)port {
    UInt8 ssInt8[kPrefix_Data_Length] = {
        kMagic_Num_0,kMagic_Num_1,kMagic_Num_2,kMagic_Num_3,
        kHead_Length_0,kHead_Length_1,kProto_Version_0,kProto_Version_1,
        0x00,0x00,0x00,0x00,    // 0x00,0x00,0x00,0x5b
        kCMD_User_Dev_Ser_Req_0,kCMD_User_Dev_Ser_Req_1,kCMD_User_Dev_Ser_Req_2,kCMD_User_Dev_Ser_Req_3,
        0x00,0x00,0x00,0x01,
        0x00,0x00,0x00,0x00,    // 0xb5,0x46,0xbf,0x96,
        0x00,0x00,0x00,0x00,
        0x00,0x00,0x00,0x00,
    };

    UInt8 *newSSInt8 = [JMAirKissUtils calcTotalLenInt8:(data.length + kPrefix_Data_Length)
                                             prefixData:ssInt8];
    newSSInt8        = [JMAirKissUtils calcCheckNumInt8:data
                                             prefixData:newSSInt8];
    
    _senderData = [NSMutableData data];
    for (int i = 0; i < kPrefix_Data_Length; i++) {
        [_senderData appendBytes:&newSSInt8[i] length:1];
    }
    
    [_senderData appendData:data];
    
    _host       = host;
    _port       = port;
    
    if (!_tcpSocket) {
        _tcpSocket = [[GCDAsyncSocket alloc]initWithDelegate:self
                                               delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    }
    
    [self reConnection];
}

- (void)reConnection {
    if (_host == nil || [_host isEqualToString:@""] || _port == 0) {
        return;
    }
    
    if ([_tcpSocket isConnected]) {
        if (_senderData) {
            [_tcpSocket writeData:_senderData
                      withTimeout:-1
                              tag:_tag];
        }
        
        return;
    }
    
    NSError *error = nil;
    [_tcpSocket connectToHost:_host
                       onPort:_port
                        error:&error];
    
    if (error) {
        if (_airKissDeliveryWithConErr) {
            _airKissDeliveryWithConErr(error);
        }
    }
}

#pragma mark - GCDAsyncSocketDelegate
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    if (_senderData) {
        [_tcpSocket writeData:_senderData
                  withTimeout:-1
                          tag:_tag];
    }
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    if (_airKissDeliveryWithDisConErr) {
        _airKissDeliveryWithDisConErr(err);
    }
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
    [sock readDataWithTimeout:-1 tag:tag];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    if (tag == _tag) {
        if (data != nil && data.length != 0) {
            NSData *respCmdData  = [data subdataWithRange:NSMakeRange(kCMD_Start_Index, kCMD_Bytes_Num)];
            NSData *respCheckNum = [data subdataWithRange:NSMakeRange(kCheckNum_Start_Index, kCheckNum_Bytes_Num)];
            NSData *respTotalLen  = [data subdataWithRange:NSMakeRange(kTotalLength_Start_Index, kTotalLength_Bytes_Num)];
            
            NSData *resJsonData = [data subdataWithRange:NSMakeRange(kPrefix_Data_Length, data.length - kPrefix_Data_Length)];
            NSDictionary *resJsonDic = [NSJSONSerialization JSONObjectWithData:resJsonData options:kNilOptions error:nil];
            
            NSData *calcCheckNum = [JMAirKissUtils calcCheckNumData:resJsonData];
            NSData *calcTotalLen = [JMAirKissUtils calcTotalLenData:data.length];
            
            if ([respCheckNum isEqualToData:calcCheckNum] && [respCmdData isEqualToData:_calcCmdData] && [respTotalLen isEqualToData:calcTotalLen]) {
                if (_airKissDeliveryWithSuc) {
                    _airKissDeliveryWithSuc(resJsonDic);
                }
            }
        }
    }
}

@end
