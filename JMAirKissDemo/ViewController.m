//
//  ViewController.m
//  JMAirKiss
//
//  Created by shengxiao on 16/3/1.
//  Copyright © 2016年 shengxiao. All rights reserved.
//

#import "ViewController.h"
#import <JMAirKiss/JMAirKiss.h>
#import "JMAirKissShareTools.h"
#import "HUDTools.h"

@interface ViewController ()<UITextFieldDelegate>
{
    NSString            *_ssidStr;
    NSString            *_pswStr;
    JMAirKissConnection *_airKissConnection;
}

@property (weak, nonatomic) IBOutlet UIButton    *connectionBtn;
@property (weak, nonatomic) IBOutlet UITextField *pswTextField;
@property (weak, nonatomic) IBOutlet UIView *pswView;
@property (weak, nonatomic) IBOutlet UILabel *ssidLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setupViews];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getSSID)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getSSID];
}

#pragma mark - UI
- (void)setupViews {
    self.title = @"AirKiss";
    
    self.connectionBtn.layer.cornerRadius = 5;
    self.connectionBtn.clipsToBounds      = YES;
    
    self.pswTextField.delegate            = self;
}

#pragma mark - Datas
- (void)getSSID {
    _ssidStr = [JMAirKissShareTools fetchSSIDInfo][@"SSID"];
    if (_ssidStr == nil || [_ssidStr isEqualToString:@""]) {
        _pswView.hidden       = YES;
        _connectionBtn.hidden = YES;
        _ssidLabel.text       = @"请开启手机WiFi后重试";
    }else {
        _pswView.hidden       = NO;
        _connectionBtn.hidden = NO;
        _ssidLabel.text       = _ssidStr ? :@"";
    }
}

#pragma mark - Event Response
- (IBAction)connectAction:(id)sender {
    _pswStr = _pswTextField.text;
    if (_pswStr == nil || _pswStr.length == 0) {
        [HUDTools showText:@"请输入WiFi密码"
                    onView:self.view
                     delay:2
                completion:^{
                      
                  }];
        return;
    }
    
    [_pswTextField resignFirstResponder];
    [HUDTools showHUDWithLabel:@"连接中..."
                        onView:self.view];
    
    if (!_airKissConnection) {
        _airKissConnection = [[JMAirKissConnection alloc] init];
        _airKissConnection.connectionSuccess = ^() {
            [HUDTools removeHUD];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"AirKiss"
                                                            message:@"设备WiFi连接成功"
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"确定", nil];
            [alert show];
        };
        
        _airKissConnection.connectionFailure = ^() {
            [HUDTools removeHUD];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"AirKiss"
                                                            message:@"设备WiFi连接失败"
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"确定", nil];
            [alert show];
        };
    }
   
    [_airKissConnection connectAirKissWithSSID:_ssidStr
                                       password:_pswStr];
}

@end
