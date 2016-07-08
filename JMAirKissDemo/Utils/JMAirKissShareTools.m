//
//  UdpShareTools.m
//  UdpEchoClient
//
//  Created by shengxiao on 15/10/30.
//
//

#import "JMAirKissShareTools.h"

#import <SystemConfiguration/SystemConfiguration.h>
#import <SystemConfiguration/CaptiveNetwork.h>

#include <inttypes.h>

#define CRC8INIT 0x00
#define CRC8POLY 0x31 // = X^8+X^5+X^4+X^0

@implementation JMAirKissShareTools
/**
 *  获取SSID信息
 *
 *  @return id
 */
+ (id)fetchSSIDInfo {
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        
        if (info && [info count]) {
            break;
        }
    }
    return info;
}

@end
