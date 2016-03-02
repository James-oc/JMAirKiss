//
//  HUDTools.m
//  AtsmartHome
//
//  Created by shengxiao on 15/8/20.
//  Copyright (c) 2015年 Atsmart. All rights reserved.
//

#import "HUDTools.h"

static MBProgressHUD    *HUD;
static HUDHandlerBlock  _handlerBlock;

@implementation HUDTools

+(MBProgressHUD *) showHUDWithLabel:(NSString *) labelText withView:(UIView *) view {
    HUD = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:HUD];
    
    HUD.labelText = labelText;
    HUD.labelFont = [UIFont systemFontOfSize:16.0f];
    [HUD show:YES];
    
    return HUD;
}

+(MBProgressHUD *) showHUDWithDetailLabel:(NSString *) detailLabelText withView:(UIView *) view {
    HUD = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:HUD];
    
    HUD.detailsLabelText = detailLabelText;
    HUD.detailsLabelFont = [UIFont systemFontOfSize:16.0f];
    [HUD show:YES];
    
    return HUD;
}

+(MBProgressHUD *) showHUDOnWindowWithLabel:(NSString *) labelText {
    HUD = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
    [[UIApplication sharedApplication].keyWindow addSubview:HUD];
    
    HUD.labelText = labelText;
    [HUD show:YES];
    
    return HUD;
}

+(MBProgressHUD *) showHUDWithLabel:(NSString *) labelText withView:(UIView *) view withColor:(UIColor *) color {
    HUD = [self showHUDWithLabel:labelText withView:view];
    HUD.color = color;

    return HUD;
}

+(MBProgressHUD *) showHUDOnWindowWithLabel:(NSString *) labelText withColor:(UIColor *) color {
    HUD = [self showHUDOnWindowWithLabel:labelText];
    HUD.color = color;
    
    return HUD;
}

+(MBProgressHUD *) showTransparentHUDWithLabel:(NSString *) labelText withView:(UIView *) view {
    HUD = [self showHUDWithLabel:labelText withView:view];
    HUD.color = [UIColor clearColor];
    
    return HUD;

}

+(MBProgressHUD *) showTransparentHUDOnWindowWithLabel:(NSString *) labelText withLabelTextColor:(UIColor *) textColor {
    HUD = [self showHUDOnWindowWithLabel:labelText];
    HUD.color = [UIColor clearColor];
    HUD.labelColor = textColor;
    
    return HUD;
}

+(MBProgressHUD *) showTransparentHUDOnWindowWithLabel:(NSString *) labelText {
    HUD = [self showHUDOnWindowWithLabel:labelText];
    HUD.color = [UIColor clearColor];
    
    return HUD;
}

+(MBProgressHUD *) changeLabelText:(NSString *) labelText {
    if (HUD == nil) {
        return nil;
    }
    HUD.labelText = labelText;
    
    return HUD;
}

+(MBProgressHUD *) changeDetailLabelText:(NSString *) labelText {
    if (HUD == nil) {
        return nil;
    }
    HUD.detailsLabelText = labelText;
    
    return HUD;
}

+ (void) removeHUD {
    [HUD hide:YES afterDelay:0];
    [HUD removeFromSuperViewOnHide];
}

+ (void) removeHUDAfterDelay:(float) time {
    [HUD hide:YES afterDelay:time];
    [HUD removeFromSuperViewOnHide];
}

+ (void) removeHUDAfterDelay:(float) time withAfterDelayHandler:(HUDHandlerBlock) handler {
    [self removeHUDAfterDelay:time];
    _handlerBlock = handler;
    [self performSelector:@selector(handleAction)
               withObject:nil
               afterDelay:time];
}

+ (void)showText:(NSString *) text withView:(UIView *) view withDelay:(float) time {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = text;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    hud.labelFont = [UIFont systemFontOfSize:16.0f];
    
    [hud hide:YES afterDelay:time];
}

/**
 *@description 显示详情信息(多行)
 *@params <##>
 *@return <##>
 */
+ (void)showDetailText:(NSString *) text withView:(UIView *) view withDelay:(float) time {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = text;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    hud.detailsLabelFont = [UIFont systemFontOfSize:16.0f];

    [hud hide:YES afterDelay:time];
}

+(void) handleAction {
    if (_handlerBlock != nil) {
        _handlerBlock();
        _handlerBlock = nil;
    }
}
@end
