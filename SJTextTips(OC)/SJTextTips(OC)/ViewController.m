//
//  ViewController.m
//  SJTextTips(OC)
//
//  Created by shmily on 15/9/4.
//  Copyright (c) 2015年 shmilyAshen. All rights reserved.
//

#import "ViewController.h"
#import "UITextField+tips.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtInput;

@property (weak, nonatomic) IBOutlet UITextField *txtPwd;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self test];
}

- (void)test{
    
    NSDictionary *dict = @{@"515783034":@"1111111",@"982042662":@"22222222", @"965917768":@"3333333"};
    
    _txtInput.matchArray = @[@"515783034",@"982042662",@"965917768"];
    _txtInput.delegate = _txtInput;
    
    //_txtInput.startMatch = @1;
    
    _txtInput.finished = ^() {
       // _txtPwd.text = @"账号匹配,自动导入密码";
        _txtPwd.text = dict[_txtInput.result];
    };
    
    _txtInput.failed = ^() {
        _txtPwd.text = @"";
    };

}

@end
