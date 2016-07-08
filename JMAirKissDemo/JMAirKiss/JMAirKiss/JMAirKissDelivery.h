//
//  JMAirKissDelivery.h
//  JMAirKiss
//
//  Created by shengxiao on 16/3/28.
//  Copyright © 2016年 shengxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^AirKissDeliveryWithConErr)(NSError *error);
typedef void (^AirKissDeliveryWithDisConErr)(NSError *error);
typedef void (^AirKissDeliveryWithSuc)(NSDictionary *resDic);

@interface JMAirKissDelivery : NSObject

@property (nonatomic,strong) AirKissDeliveryWithConErr    airKissDeliveryWithConErr;
@property (nonatomic,strong) AirKissDeliveryWithDisConErr airKissDeliveryWithDisConErr;
@property (nonatomic,strong) AirKissDeliveryWithSuc       airKissDeliveryWithSuc;

- (void)deliverData:(NSData *)data
           withHost:(NSString *)host
               port:(uint16_t)port;

- (void)reConnection;

@end
