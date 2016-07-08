//
//  Defines.h
//  JMAirKiss
//
//  Created by shengxiao on 16/3/28.
//  Copyright © 2016年 shengxiao. All rights reserved.
//

#ifndef Defines_h
#define Defines_h

#define kMagic_Num_0             0xFD
#define kMagic_Num_1             0x01
#define kMagic_Num_2             0xFE
#define kMagic_Num_3             0xFC

#define kHead_Length_0           0x00
#define kHead_Length_1           0x20

#define kProto_Version_0         0x00
#define kProto_Version_1         0x02

#define kCMD_Discorvery_Req_0    0x00
#define kCMD_Discorvery_Req_1    0x00
#define kCMD_Discorvery_Req_2    0x00
#define kCMD_Discorvery_Req_3    0x01

#define kCMD_Discorvery_Resp_0   0x00
#define kCMD_Discorvery_Resp_1   0x00
#define kCMD_Discorvery_Resp_2   0x10
#define kCMD_Discorvery_Resp_3   0x01

#define kCMD_Get_Dev_Pro_Req_0   0x00
#define kCMD_Get_Dev_Pro_Req_1   0x00
#define kCMD_Get_Dev_Pro_Req_2   0x00
#define kCMD_Get_Dev_Pro_Req_3   0x03

#define kCMD_Get_Dev_Pro_Resp_0  0x00
#define kCMD_Get_Dev_Pro_Resp_1  0x00
#define kCMD_Get_Dev_Pro_Resp_2  0x10
#define kCMD_Get_Dev_Pro_Resp_3  0x03

#define kCMD_User_Dev_Ser_Req_0  0x00
#define kCMD_User_Dev_Ser_Req_1  0x00
#define kCMD_User_Dev_Ser_Req_2  0x00
#define kCMD_User_Dev_Ser_Req_3  0x07

#define kCMD_User_Dev_Ser_Resp_0 0x00
#define kCMD_User_Dev_Ser_Resp_1 0x00
#define kCMD_User_Dev_Ser_Resp_2 0x10
#define kCMD_User_Dev_Ser_Resp_3 0x07

#define kPrefix_Data_Length      32

#define kTotalLength_Start_Index 8
#define kTotalLength_Bytes_Num   4

#define kCMD_Start_Index         12
#define kCMD_Bytes_Num           4

#define kCheckNum_Start_Index    20
#define kCheckNum_Bytes_Num      4

#endif /* Defines_h */
