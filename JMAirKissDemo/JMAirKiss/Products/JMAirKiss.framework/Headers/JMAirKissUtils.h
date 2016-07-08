//
//  JMAirKissUtils.h
//  JMAirKiss
//
//  Created by shengxiao on 16/3/28.
//  Copyright © 2016年 shengxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMAirKissUtils : NSObject

+ (UInt8 *)calcCheckNumInt8:(NSData *)senderData
                 prefixData:(UInt8 *)prefixData;

+ (UInt8 *)calcCheckNumInt8:(NSData *)senderData;

+ (NSData *)calcCheckNumData:(NSData *)senderData;

+ (UInt8 *)calcTotalLenInt8:(NSInteger)length
                 prefixData:(UInt8 *)prefixData;

+ (UInt8 *)calcTotalLenInt8:(NSInteger)length;

+ (NSData *)calcTotalLenData:(NSInteger)length
                  prefixData:(UInt8 *)prefixData;

+ (NSData *)calcTotalLenData:(NSInteger)length;

@end
