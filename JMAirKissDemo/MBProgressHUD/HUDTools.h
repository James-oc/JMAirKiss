//
//  HUDTools.h
//  AtsmartHome
//
//  Created by shengxiao on 15/8/20.
//  Copyright (c) 2015年 Atsmart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

typedef void (^HUDHandlerBlock) (void);

@interface HUDTools : NSObject

+(MBProgressHUD *) showHUDWithLabel:(NSString *) labelText withView:(UIView *) view;

+(MBProgressHUD *) showHUDWithDetailLabel:(NSString *) detailLabelText withView:(UIView *) view;

+(MBProgressHUD *) showHUDOnWindowWithLabel:(NSString *) labelText;

+(MBProgressHUD *) showHUDWithLabel:(NSString *) labelText withView:(UIView *) view withColor:(UIColor *) color;

+(MBProgressHUD *) showHUDOnWindowWithLabel:(NSString *) labelText withColor:(UIColor *) color;

+(MBProgressHUD *) showTransparentHUDWithLabel:(NSString *) labelText withView:(UIView *) view;

+(MBProgressHUD *) showTransparentHUDOnWindowWithLabel:(NSString *) labelText withLabelTextColor:(UIColor *) textColor;

+(MBProgressHUD *) showTransparentHUDOnWindowWithLabel:(NSString *) labelText;

+(MBProgressHUD *) changeLabelText:(NSString *) labelText;

+(MBProgressHUD *) changeDetailLabelText:(NSString *) labelText;

+ (void) removeHUD;

+ (void) removeHUDAfterDelay:(float) time;

+ (void) removeHUDAfterDelay:(float) time withAfterDelayHandler:(HUDHandlerBlock) handler;

+ (void)showText:(NSString *) text withView:(UIView *) view withDelay:(float) time;

+ (void)showDetailText:(NSString *) text withView:(UIView *) view withDelay:(float) time;

@end
