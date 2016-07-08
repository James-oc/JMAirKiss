//
//  JMAirKissEncoder.m
//  UdpEchoClient
//
//  Created by shengxiao on 16/2/27.
//
//

#import "JMAirKissEncoder.h"

#define kRandomChar  arc4random() % 127

@interface JMAirKissEncoder()
{
    NSMutableArray *_mEncodedDatas;
    UInt8          _mRandomChar;
}
@end

@implementation JMAirKissEncoder

- (instancetype)init {
    self = [super init];
    if (self) {
        _mEncodedDatas = [NSMutableArray array];
    }
    
    return self;
}

/**
 *  创建AirKiss数据
 *
 *  @param ssid <#ssid description#>
 *  @param psd  <#psd description#>
 *
 *  @return 装载要发送的每条数据的长度的数组
 */
- (NSMutableArray *)createAirKissEncorderWithSSID:(NSString *)ssid
                                         password:(NSString *)password {
    [_mEncodedDatas removeAllObjects];
    int times      = 5;
    _mRandomChar   = kRandomChar;

    while (times-- > 0) {
        [self getLeadingPart];
        [self getMagicCodeWithSSID:ssid
                          password:password];
        
        for (int i = 0; i < 15; i++) {
            [self getPrefixCodeWithPSW:password];
            NSMutableData *data = [NSMutableData dataWithData:[password dataUsingEncoding:NSUTF8StringEncoding]];// 密码

            [data appendBytes:&_mRandomChar length:1];                       // 随机数
            [data appendData:[ssid dataUsingEncoding:NSUTF8StringEncoding]]; // ssid
            
            int size         = 4;
            int index        = 0;
            NSData *tempData = nil;
            for (index = 0;index < (data.length / size); index++) {
                // 以4为粒度
                tempData = [data subdataWithRange:NSMakeRange(index * size, size)];
                [self getSequenceWithIndex:index
                                      data:tempData];
            }
            
            if ((data.length % size) != 0) {
                tempData = [data subdataWithRange:NSMakeRange(index * size, data.length % size)];
                [self getSequenceWithIndex:index
                                      data:tempData];
            }
        }
    }
    
    return _mEncodedDatas;
}

/**
 *  前导域数据
 */
- (void)getLeadingPart {
    for (int i = 0; i < 50; ++i) {
        for (int j = 1; j <= 4; ++j) {
            [_mEncodedDatas addObject:[NSNumber numberWithInt:j]];
        }
    }
}

/**
 *  magic code
 */
- (void)getMagicCodeWithSSID:(NSString *)ssid
                    password:(NSString *)password {
    UInt8 length       = ssid.length + password.length + 1;
    UInt8 magicCode[4] = {0x00,0x00,0x00,0x00};
    magicCode[0]       = 0x00 | (length >> 4 & 0xF);
    
    if (magicCode[0] == 0) {
        magicCode[0] = 0x08;
    }
    
    magicCode[1]        = 0x10 | (length & 0xF);

    UInt8 *cipherBuffer = (UInt8*)[ssid UTF8String];
    UInt8 crc8          = CRC8(cipherBuffer, (int)ssid.length);

    magicCode[2]        = 0x20 | (crc8 >> 4 & 0xF);
    magicCode[3]        = 0x30 | (crc8 & 0xF);
    
    for (int i = 0; i < 20; ++i) {
        for (int j = 0; j < 4; ++j) {
            [_mEncodedDatas addObject:[NSNumber numberWithUnsignedChar:magicCode[j]]];
        }
    }
}

/**
 *  prefix code
 *
 *  @param psw <#psw description#>
 */
- (void)getPrefixCodeWithPSW:(NSString *)psw {
    UInt8 length        = psw.length;
    UInt8 crc8          = CRC8(&length, 1);

    UInt8 prefixCode[4] = {0x00,0x00,0x00,0x00};

    prefixCode[0]       = 0x40 | (length >> 4 & 0xF);
    prefixCode[1]       = 0x50 | (length & 0xF);
    prefixCode[2]       = 0x60 | (crc8 >> 4 & 0xF);
    prefixCode[3]       = 0x70 | (crc8 & 0xF);
    
    for (int j = 0; j < 4; ++j) {
        [_mEncodedDatas addObject:[NSNumber numberWithUnsignedChar:prefixCode[j]]];
    }
}

/**
 *  sequence
 *
 *  @param index <#index description#>
 *  @param data  <#data description#>
 */
- (void)getSequenceWithIndex:(UInt8)index
                        data:(NSData *)data {
    UInt8 newIndex       = index & 0xFF;
    NSMutableData *mData = [NSMutableData dataWithBytes:&newIndex
                                                 length:1];
    [mData appendData:data];

    UInt8 *originUData   = (UInt8 *)[data bytes];
    UInt8 *newUData      = (UInt8 *)[mData bytes];

    UInt8 crc8           = CRC8(newUData, (int)mData.length);
    
    [_mEncodedDatas addObject:[NSNumber numberWithUnsignedChar:(0x80 | crc8)]];
    [_mEncodedDatas addObject:[NSNumber numberWithUnsignedChar:(0x80 | index)]];

    for (int i = 0;i < data.length;i++) {
        [_mEncodedDatas addObject:[NSNumber numberWithUnsignedShort:(0x100 | originUData[i])]];
    }
}

/**
 *  获取CRC8值
 *
 *  @param data <#data description#>
 *  @param len  <#len description#>
 *
 *  @return <#return value description#>
 */
UInt8 CRC8(UInt8 * data, int len)
{
    UInt8 cFcs = 0;
    int i, j;
    
    for( i = 0; i < len; i ++ ) {
        cFcs ^= data[i];
        for(j = 0; j < 8; j ++) {
            if(cFcs & 1) {
                cFcs ^= 0x18; /* CRC (X(8) + X(5) + X(4) + 1) */
                cFcs >>= 1;
                cFcs |= 0x80;
                //cFcs = (BYTE)((cFcs >> 1) ^ AL2_FCS_COEF);
            } else {
                cFcs >>= 1;
            }
        }
    }
    
    return cFcs;
}

#pragma mark - Properties
- (UInt8)randomChar {
    return _mRandomChar;
}

@end
