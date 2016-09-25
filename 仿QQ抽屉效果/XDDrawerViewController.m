//
//  XDDrawerViewController.m
//  仿QQ抽屉效果
//
//  Created by 窦心东 on 16/9/25.
//  Copyright © 2016年 窦心东. All rights reserved.
//

#import "XDDrawerViewController.h"

@interface XDDrawerViewController ()
/**
 *  记录当前正在显示的VC
 */
@property (nonatomic,strong) UIViewController *showingVc;
/**
 *  遮盖按钮
 */
@property (nonatomic,strong) UIButton *coverButton;
//跨方法访问的 要记录一下属性
/**
 *  主控制器
 */
@property (nonatomic,strong) UIViewController *mainVc;
/**
 *  左边控制器
 */
@property (nonatomic,strong) UIViewController *leftMenuVc;
/**
 *  记录一下左边菜单控制器最大显示范围
 */
@property (nonatomic,assign) CGFloat leftWidth;


@end

@implementation XDDrawerViewController

/**
 *  快速获得抽屉控制器
 *
 *  @return shareDrawerVc
 */
+ (instancetype)shareDrawerVc{
    return (XDDrawerViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
}
/**
 *  快速创建抽屉控制器
 *
 *  @param mainVc     主控制器－UITabBarController
 *  @param leftMenuVc 左边菜单控制器
 *
 *  @return 抽屉控制器
 */
+ (instancetype)drawerVcWithMainVc:(UIViewController *)mainVc leftMenuVc:(UIViewController *)leftMenuVc leftWith:(CGFloat)leftWith{
    //创建抽屉控制器
    XDDrawerViewController *drawerVc = [[XDDrawerViewController alloc] init];
    drawerVc.mainVc = mainVc;
    drawerVc.leftMenuVc = leftMenuVc;
    drawerVc.leftWidth = leftWith;
    //将左边菜单控制器的view添加到抽屉控制器的view上
    [drawerVc.view addSubview:leftMenuVc.view];
    [drawerVc.view addSubview:mainVc.view];
    //苹果官方规定 如果“两个控制器的view”互为父子关系，这“两个控制器”与也必须互为父子关系
    [drawerVc addChildViewController:leftMenuVc];
    [drawerVc addChildViewController:mainVc];
    
    return drawerVc;
    
}
/**
 *  打开左边控制器方法
 */
- (void)openLeftVc{
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.mainVc.view.transform = CGAffineTransformMakeTranslation(self.leftWidth, 0);
        self.leftMenuVc.view.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        //在滑倒右边的mainVC主控制器view上边添加一个 “遮盖按钮”
        [self.mainVc.view addSubview:self.coverButton];
    }];
    
}
/**
 *  关闭左边控制器方法
 */
- (void)covreButtonClick{
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        /**
         *  清空，还原view的transform
         */
        self.mainVc.view.transform = CGAffineTransformIdentity;
        self.leftMenuVc.view.transform = CGAffineTransformMakeTranslation(-self.leftWidth, 0);
    } completion:^(BOOL finished) {
        //在滑倒右边的mainVC主控制器view上边去除一个 “遮盖按钮”
        [self.coverButton removeFromSuperview];
        self.coverButton = nil;
    }];
}
/**
 *  切换控制器的方法  切换到指定的控制器
 *
 *  @param destVc 目标控制器
 */
- (void)switchViewController:(UIViewController *)destVc{
    destVc.view.frame = self.mainVc.view.bounds;
    destVc.view.transform = self.mainVc.view.transform;
    [self.view addSubview:destVc.view];
    [self addChildViewController:destVc];
    [self covreButtonClick];
    self.showingVc = destVc;
    //以动画形式 让控制器回到最初状态
    [UIView animateWithDuration:0.25 animations:^{
        destVc.view.transform = CGAffineTransformIdentity;
    }];
    
}
/**
 *  回到主界面
 */
- (void)backHomeViewController{
    //以动画形式 让控制器回到最初状态
    [UIView animateWithDuration:0.25 animations:^{
        self.showingVc.view.transform = CGAffineTransformMakeTranslation(self.view.frame.size.width, 0);
    }completion:^(BOOL finished) {
        [self.showingVc removeFromParentViewController];
        [self.showingVc.view removeFromSuperview];
        self.showingVc = nil;
    }];
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //默认左边控制器的view向左偏移self.leftwidth
    self.leftMenuVc.view.transform = CGAffineTransformMakeTranslation(-self.leftWidth, 0);
    //给mainVc 设置阴影效果
    self.mainVc.view.layer.shadowColor = [UIColor blackColor].CGColor;
    self.mainVc.view.layer.shadowOffset = CGSizeMake(-3, -3);
    self.mainVc.view.layer.shadowOpacity=  1;
    self.mainVc.view.layer.shadowRadius = 5;
    //给tabBarVc的所有子控制器添加一个边缘拖拽的手势
    for (UIViewController *childVc in self.mainVc.childViewControllers) {
        [self addScreenEdgePanGestureRecognizerToView:childVc.view];
    }
    
    
    
}
/**
 *  给指定的view添加边缘拖拽手势
 */
- (void)addScreenEdgePanGestureRecognizerToView:(UIView *)View{
    //创建边缘拖拽对象
    UIScreenEdgePanGestureRecognizer *pan = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(edgePanGestureRecognizer:)];
    //设置手势方向，触发左边缘时才触发
    pan.edges = UIRectEdgeLeft;
    [View addGestureRecognizer:pan];
}
/**
 *  手势回调方法
 */
- (void)edgePanGestureRecognizer:(UIScreenEdgePanGestureRecognizer *)pan{
    NSLog(@"%s",__FUNCTION__);
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    //获得x方向拖拽的距离
    CGFloat offset = [pan translationInView:pan.view].x;
    if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled) {
        //当拖拽结束时或拖拽取消时，判断主控制器的view的x值有没有到达屏幕的一半
        if (self.mainVc.view.frame.origin.x > screenWidth/2) {
            [self openLeftVc];
        }else{
        
            [self covreButtonClick];
        }
    }else if (pan.state == UIGestureRecognizerStateChanged){
        //当拖拽时使mainVc的view的x值随着往x方向拖拽的距离的改变而变化
        self.mainVc.view.transform = CGAffineTransformMakeTranslation(offset, 0);
        self.leftMenuVc.view.transform= CGAffineTransformMakeTranslation(offset-self.leftWidth, 0);
    }
}
/**
 *  监听遮盖按钮的拖拽手势
 */
- (void)panCoverBtn:(UIPanGestureRecognizer *)pan{
    //获得x方向拖拽的距离
    CGFloat offset = [pan translationInView:pan.view].x;
    if (offset > 0) return;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat distance = self.leftWidth - ABS(offset);//减去绝对值
    if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled) {
        //当拖拽结束时或拖拽取消时，判断主控制器的view的x值有没有到达屏幕的一半
        if (self.mainVc.view.frame.origin.x > screenWidth/2) {
            [self openLeftVc];
        }else{
            
            [self covreButtonClick];
        }
    }else if (pan.state == UIGestureRecognizerStateChanged){
        //当拖拽时使mainVc的view的x值随着往x方向拖拽的距离的改变而变化
        self.mainVc.view.transform = CGAffineTransformMakeTranslation(MAX(0, distance), 0);
        self.leftMenuVc.view.transform= CGAffineTransformMakeTranslation(offset, 0);
    }
}
#pragma mark -懒加载 遮盖按钮
-(UIButton *)coverButton{
    if (_coverButton == nil) {
        _coverButton = [[UIButton alloc] init];
        _coverButton.backgroundColor = [UIColor clearColor];
        _coverButton.frame = self.mainVc.view.bounds;
        [_coverButton addTarget:self action:@selector(covreButtonClick) forControlEvents:UIControlEventTouchUpInside];
        //创建一个拖拽手势
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panCoverBtn:)];
        [_coverButton addGestureRecognizer:pan];
    }
    return _coverButton;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
