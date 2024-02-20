//
//  ViewController.m
//  CustomSwitch
//
//  Created by OKNI-IOS on 2020/10/23.
//

#import "ViewController.h"
#import "CustomSwitch.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CustomSwitch *CS = [[CustomSwitch alloc]initWithFrame:CGRectMake(100, 100, 0, 0)];
    CS.on = YES;
    [self.view addSubview:CS];
    
    // 测试信息
    
}


@end
