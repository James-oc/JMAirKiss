//
//  JMAirKissDiscovery.h
//  JMAirKiss
//
//  Created by shengxiao on 16/3/28.
//  Copyright © 2016年 shengxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,JMAirKissDisDevSucType) {
    JMAirKissDisDevSucTypeWithNone,
    JMAirKissDisDevSucTypeWithDisResp,
    JMAirKissDisDevSucTypeWithProResp
};

typedef void (^AirKissDiscoveryDeviceSuc)(NSDictionary *info,NSString *host,JMAirKissDisDevSucType type);

@interface JMAirKissDiscovery : NSObject

@property (nonatomic,assign) float                     timeInterVal;// 默认1.5s
@property (nonatomic,copy  ) NSMutableData             *secondSenderJsonData;
@property (nonatomic,copy  ) AirKissDiscoveryDeviceSuc airKissDiscoveryDeviceSuc;

- (void)discoverDevices;

- (void)closeConnection;

@end
