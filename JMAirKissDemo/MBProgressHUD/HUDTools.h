//
//  HUDTools.h
//  AtsmartHome
//
//  Created by shengxiao on 15/8/20.
//  Copyright (c) 2015年 Atsmart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

typedef void (^HUDCompletion) (void);

@interface HUDTools : NSObject

+ (MBProgressHUD *)showHUDWithLabel:(NSString *)labelText
                             onView:(UIView *)view;

+ (MBProgressHUD *)showHUDWithDetailLabel:(NSString *)detailLabelText
                                   onView:(UIView *)view;

+ (MBProgressHUD *)showHUDOnWindowWithLabel:(NSString *)labelText;

+ (MBProgressHUD *)showHUDWithLabel:(NSString *)labelText
                             onView:(UIView *)view
                              color:(UIColor *)color;

+ (MBProgressHUD *)showHUDWithLabel:(NSString *)labelText
                             onView:(UIView *)view
                              color:(UIColor *)color
                     labelTextColor:(UIColor *)textColor
             activityIndicatorColor:(UIColor *)actIndicatorColor;

+ (MBProgressHUD *)showHUDOnWindowWithLabel:(NSString *)labelText
                                      color:(UIColor *)color;

+ (MBProgressHUD *)showTransparentHUDWithLabel:(NSString *)labelText
                                        onView:(UIView *)view;

+ (MBProgressHUD *)showTransparentHUDOnWindowWithLabel:(NSString *)labelText
                                        labelTextColor:(UIColor *)textColor;

+ (MBProgressHUD *)showTransparentHUDOnWindowWithLabel:(NSString *)labelText;

+ (MBProgressHUD *)changeLabelText:(NSString *)labelText;

+ (MBProgressHUD *)changeDetailLabelText:(NSString *)labelText;

+ (void)removeHUD;

+ (void)removeHUDWithDelay:(float)time;

+ (void)removeHUDWithDelay:(float)time
                completion:(HUDCompletion)completion;

+ (void)showText:(NSString *)text
          onView:(UIView *)view
           delay:(float)time;

+ (void)showText:(NSString *)text
          onView:(UIView *)view
           delay:(float)time
      completion:(HUDCompletion)completion;

+ (void)showDetailText:(NSString *)text
                onView:(UIView *)view
                 delay:(float)time;

+ (void)showDetailText:(NSString *)text
                onView:(UIView *)view
                 delay:(float)time
            completion:(HUDCompletion)completion;

@end
