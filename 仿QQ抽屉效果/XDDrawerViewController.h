//
//  XDDrawerViewController.h
//  仿QQ抽屉效果
//
//  Created by 窦心东 on 16/9/25.
//  Copyright © 2016年 窦心东. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDDrawerViewController : UIViewController
/**
 *  快速获得抽屉控制器
 *
 *  @return shareDrawerVc
 */
+ (instancetype)shareDrawerVc;
/**
 *  快速创建抽屉控制器
 *
 *  @param mainVc     主控制器－UITabBarController
 *  @param leftMenuVc 左边菜单控制器
 *  @param leftWith 左边控制器现实的最大宽度
 *  @return 抽屉控制器
 */
+ (instancetype)drawerVcWithMainVc:(UIViewController *)mainVc leftMenuVc:(UIViewController *)leftMenuVc leftWith:(CGFloat)leftWith;
/**
 *  打开左边控制器方法
 */
- (void)openLeftVc;
/**
 *  切换控制器的方法
 *
 *  @param destVc 目标控制器
 */
- (void)switchViewController:(UIViewController *)destVc;
/**
 *  回到主界面
 */
- (void)backHomeViewController;
@end
