//
//  XDLeftMenuTableViewController.m
//  仿QQ抽屉效果
//
//  Created by 窦心东 on 16/9/25.
//  Copyright © 2016年 窦心东. All rights reserved.
//

#import "XDLeftMenuTableViewController.h"
#import "XDDrawerViewController.h"
@interface XDLeftMenuTableViewController ()
/**
 *  tableView的头部view
 */
@property (nonatomic,strong) UIView *headerView;
@end

@implementation XDLeftMenuTableViewController
#pragma mark - 懒加载创建tableView的头部view
-(UIView *)headerView{
    if (_headerView == nil) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,0,200)];
        _headerView.backgroundColor = [UIColor orangeColor];
        
    }
    return _headerView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //隐藏分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //设置背景
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"chat_bg_default"]];
//     self.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"chat_bg_default"]];
    //设置tableview 的头部控件
    self.tableView.tableHeaderView = self.headerView;
    
    
    UIButton *addbutton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    addbutton.center = CGPointMake(101, 100);
    [addbutton addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:addbutton];
    
}
//headerView上边的按钮点击事件
- (void)btnClick{
    NSLog(@"%s",__FUNCTION__);
    //创建控制器
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = [UIColor redColor];
    vc.title = @"增加按钮点击进来的控制器";
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    vc.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:[XDDrawerViewController shareDrawerVc] action:@selector(backHomeViewController)];
    //把我的nav传过去，来切换控制器
    [[XDDrawerViewController shareDrawerVc]switchViewController:nav];
    
}

@end
