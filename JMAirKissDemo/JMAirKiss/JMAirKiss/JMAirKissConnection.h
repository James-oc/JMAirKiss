//
//  JMAirKissConnection.h
//  JMAirKiss
//
//  Created by shengxiao on 16/3/2.
//  Copyright © 2016年 shengxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^AirKissConnectionSuccess) (void);
typedef void (^AirKissConnectionFailure) (void);

@interface JMAirKissConnection : NSObject

@property(nonatomic,copy) AirKissConnectionSuccess connectionSuccess;
@property(nonatomic,copy) AirKissConnectionFailure connectionFailure;

/**
 *  AirKiss连接
 *
 *  @param ssidStr ssid
 *  @param pswStr  psw
 */
- (void)connectAirKissWithSSID:(NSString *)ssidStr
                      password:(NSString *)password;

- (void)closeConnection;

@end
