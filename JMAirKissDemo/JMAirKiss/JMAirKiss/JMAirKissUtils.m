//
//  JMAirKissUtils.m
//  JMAirKiss
//
//  Created by shengxiao on 16/3/28.
//  Copyright © 2016年 shengxiao. All rights reserved.
//

#import "JMAirKissUtils.h"
#import "Defines.h"

@implementation JMAirKissUtils
/**
 *  数据长度转化计算
 *
 *  @param length     <#length description#>
 *  @param prefixData <#prefixData description#>
 *
 *  @return <#return value description#>
 */
+ (UInt8 *)calcCheckNumInt8:(NSData *)senderData
                 prefixData:(UInt8 *)prefixData {
    static UInt8 *calcData;
    BOOL hasPrefixData  = NO;
    
    if (prefixData != nil) {
        calcData        = prefixData;
        hasPrefixData   = YES;
    }else {
        static UInt8 nilData[kCheckNum_Bytes_Num] = {0x00,0x00,0x00,0x00};
        calcData                                  = nilData;
    }

    if (senderData != nil) {
        NSString *checkNumHexStr       = [self turn10To16:[self crc32:senderData]];
        NSInteger originCheckNumHexLen = checkNumHexStr.length;
        
        if (originCheckNumHexLen < (kCheckNum_Bytes_Num * 2)) {
            for (int i = 0; i < (kCheckNum_Bytes_Num * 2 - originCheckNumHexLen); i++) {
                checkNumHexStr = [@"0" stringByAppendingString:checkNumHexStr];
            }
        }
        
        for (int i = 0; i < kCheckNum_Bytes_Num; i++) {
            NSString *subHexStr = [checkNumHexStr substringWithRange:NSMakeRange(2 * i, 2)];
            unsigned long subHex = strtoul([subHexStr UTF8String], 0, 16);
            
            if (hasPrefixData) {
                calcData[kCheckNum_Start_Index + i] = subHex;
            }else {
                calcData[i] = subHex;
            }
        }
    }
    
    return calcData;
}

/**
 *  数据长度转化计算
 *
 *  @param length     <#length description#>
 *  @param prefixData <#prefixData description#>
 *
 *  @return <#return value description#>
 */
+ (UInt8 *)calcCheckNumInt8:(NSData *)senderData {
    return [self calcCheckNumInt8:senderData
                       prefixData:nil];
}

+ (NSData *)calcCheckNumData:(NSData *)senderData
                  prefixData:(UInt8 *)prefixData {
    UInt8 *calcInt8     = [self calcCheckNumInt8:senderData
                                  prefixData:prefixData];
    NSMutableData *data = [NSMutableData data];
    int num             = kCheckNum_Bytes_Num;
    
    if (prefixData != nil) {
        num = kPrefix_Data_Length;
    }
    for (int i = 0; i < num; i++) {
        [data appendBytes:&calcInt8[i] length:1];
    }
    
    return data;
}

+ (NSData *)calcCheckNumData:(NSData *)senderData {
    return [self calcCheckNumData:senderData
                       prefixData:nil];
}

/**
 *  数据长度转化计算
 *
 *  @param length     <#length description#>
 *  @param prefixData <#prefixData description#>
 *
 *  @return <#return value description#>
 */
+ (UInt8 *)calcTotalLenInt8:(NSInteger)length
                 prefixData:(UInt8 *)prefixData {
    static UInt8 *calcData;
    BOOL hasPrefixData   = NO;

    if (prefixData != nil) {
        hasPrefixData = YES;
        calcData      = prefixData;
    }else {
        static UInt8 nilData[kTotalLength_Bytes_Num] = {0x00,0x00,0x00,0x00};
        calcData                                     = nilData;
    }
    
    NSString *lengthHexStr    = [self turn10To16:(UInt32)length];
    NSInteger originHexStrLen = lengthHexStr.length;
    if (originHexStrLen < (kTotalLength_Bytes_Num * 2)) {
        for (int i = 0; i < (kTotalLength_Bytes_Num * 2 - originHexStrLen); i++) {
            lengthHexStr = [@"0" stringByAppendingString:lengthHexStr];
        }
    }
    
    for (int i = 0; i < kTotalLength_Bytes_Num; i++) {
        NSString *subHexStr = [lengthHexStr substringWithRange:NSMakeRange(2 * i, 2)];
        unsigned long subHex = strtoul([subHexStr UTF8String], 0, 16);
        
        if (hasPrefixData) {
            calcData[kTotalLength_Start_Index + i] = subHex;
        }else {
            calcData[i] = subHex;
        }
    }
    
    return calcData;
}

/**
 *  数据长度转化计算
 *
 *  @param length     <#length description#>
 *  @param prefixData <#prefixData description#>
 *
 *  @return <#return value description#>
 */
+ (UInt8 *)calcTotalLenInt8:(NSInteger)length {
    return [self calcTotalLenInt8:length
                       prefixData:nil];
}

+ (NSData *)calcTotalLenData:(NSInteger)length
                  prefixData:(UInt8 *)prefixData {
    UInt8 *calcInt8     = [self calcTotalLenInt8:length
                                  prefixData:prefixData];
    NSMutableData *data = [NSMutableData data];
    int num             = kCheckNum_Bytes_Num;
    
    if (prefixData != nil) {
        num = kPrefix_Data_Length;
    }
    for (int i = 0; i < num; i++) {
        [data appendBytes:&calcInt8[i] length:1];
    }
    
    return data;
}

+ (NSData *)calcTotalLenData:(NSInteger)length {
    return [self calcTotalLenData:length
                       prefixData:nil];
}

/**
 *  十进制转十六进制
 *
 *  @param string <#string description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)turn10To16:(UInt32)tmpid {
    NSString *nLetterValue;
    NSString *str = @"";
    UInt32   ttmpig;
    
    for (int i = 0;i < 9;i++) {
        ttmpig = tmpid % 16;
        tmpid  = tmpid / 16;
        
        switch (ttmpig)
        {
            case 10:
                nLetterValue = @"A";
                break;
            case 11:
                nLetterValue = @"B";
                break;
            case 12:
                nLetterValue = @"C";
                break;
            case 13:
                nLetterValue = @"D";
                break;
            case 14:
                nLetterValue = @"E";
                break;
            case 15:
                nLetterValue = @"F";
                break;
            default:
                nLetterValue = [NSString stringWithFormat:@"%u",(unsigned int)ttmpig];
                
        }
        
        str = [nLetterValue stringByAppendingString:str];
        
        if (tmpid == 0) {
            break;
        }
    }
    
    return str;
}

/**
 *  获取CheckNum
 *
 *  @param data <#data description#>
 *
 *  @return <#return value description#>
 */
+ (uint32_t)crc32:(NSData *)data
{
    uint32_t *table = malloc(sizeof(uint32_t) * 256);
    uint32_t crc = 0xffffffff;
    uint8_t *bytes = (uint8_t *)[data bytes];
    
    for (uint32_t i=0; i<256; i++) {
        table[i] = i;
        for (int j=0; j<8; j++) {
            if (table[i] & 1) {
                table[i] = (table[i] >>= 1) ^ 0xedb88320;
            } else {
                table[i] >>= 1;
            }
        }
    }
    
    for (int i=0; i<data.length; i++) {
        crc = (crc >> 8) ^ table[crc & 0xff ^ bytes[i]];
    }
    crc ^= 0xffffffff;
    
    free(table);
    
    return crc;
}

@end
