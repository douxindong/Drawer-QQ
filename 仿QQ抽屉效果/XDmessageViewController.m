//
//  XDmessageViewController.m
//  仿QQ抽屉效果
//
//  Created by 窦心东 on 16/9/25.
//  Copyright © 2016年 窦心东. All rights reserved.
//

#import "XDmessageViewController.h"
#import "XDDrawerViewController.h"
@interface XDmessageViewController ()

@end

@implementation XDmessageViewController
/**
 *  坚听按钮的点击
 *
 *  @param sender drawerButtonClick
 */
- (IBAction)ButtonClick {
    NSLog(@"%s",__FUNCTION__);
    [[XDDrawerViewController shareDrawerVc] openLeftVc];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor brownColor];
}


@end
