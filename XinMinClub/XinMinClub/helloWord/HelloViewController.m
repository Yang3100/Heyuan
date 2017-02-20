//
//  HelloViewController.m
//  LoginSection
//
//  Created by 杨科军 on 2016/12/15.
//  Copyright © 2016年 杨科军. All rights reserved.
//

#import "HelloViewController.h"
#import "shareObjectModel.h"
#import "HomeViewController.h"

@interface HelloViewController ()<loginDelegate,forgetDelegate,registerDelegate>{
    UIImage *adImage;
    UILabel *lab; // 跳过数字
    NSTimer *timer; // 定时器
    NSInteger num;
    int istrue;
    BOOL isUnload;
    
    loginViewController *kj_login;
    RegisterViewController *kj_register;
    ForgetViewController *kj_forget;
}

@end

@implementation HelloViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    istrue = 0;
    isUnload = NO;
    
    // 创建并启动定时器
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
    // 启动定时器
    [timer setFireDate:[NSDate distantPast]];
}

- (void)initView{
    UIImageView *adImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    adImageView.image = adImage;
    [self.view addSubview:adImageView];
    
    // 测试button
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    but.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-50, 30, 30, 30);
    //    but.layer.masksToBounds = YES;
    //    but.layer.cornerRadius = 20;
    //    but.layer.borderWidth = 1;
    [but setImage:[UIImage imageNamed:@"跳过广告"] forState:UIControlStateNormal];
    [but addTarget:self action:@selector(butAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:but];
    
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    l.center = CGPointMake(but.center.x, but.center.y+25);
    l.text = @"跳过广告";
    l.textColor = RGB255_COLOR(158,149,122,1);
    l.textAlignment = NSTextAlignmentCenter;
    l.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:l];
    
    lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 25)];
    lab.center = but.center;
    lab.text = [NSString stringWithFormat:@"%ld秒",(long)num];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = [UIColor whiteColor];
    lab.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:lab];
}

- (void)ADImage:(UIImage*)adim waitingTime:(NSTimeInterval)time{
    adImage = adim;
    num = time;
    
    [self network];
    
    [self initView];
}

// 定时器执行操作方法
- (void)updateTimer {
    lab.text = [NSString stringWithFormat:@"%ld秒",(long)num];
    //    [but setTitle:[NSString stringWithFormat:@"%ld秒",(long)num] forState:UIControlStateNormal];
    num--;
    // 满足条件后，停止当前的运行循环
    if (num < 1) {
        [self gotoViewController];
    }
}

- (void)gotoViewController{
    // 关闭定时器，永久关闭定时器
    [timer invalidate];
    
    //    [self performSelectorOnMainThread:@selector(xxx) withObject:self waitUntilDone:YES];
    if (istrue==1||istrue==2) {
        [self load];
    }else{
        isUnload = YES;
    }
}

- (void)butAction{
    NSLog(@"消失吧！！");
    [self gotoViewController];
}

- (void)load{
    if (istrue==1) {
        dispatch_async(dispatch_get_main_queue(), ^{
            HomeViewController *hvc = [[HomeViewController alloc] init];
            HomeNavController *nav = [[HomeNavController alloc] initWithRootViewController:hvc];
            CATransition *animation = [CATransition animation];
            animation.duration = 1.0;
            animation.timingFunction = UIViewAnimationCurveEaseInOut;
            animation.type = kCATransitionFade;
            [self.view.window.layer addAnimation:animation forKey:nil];
            [self presentViewController:nav animated:NO completion:^{
                [[NSNotificationCenter defaultCenter] removeObserver:self name:@"wechatLoadSucessful" object:nil];
            }];
        });
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [[shareObjectModel shareObject] deleteAccountAndPassword]; // 删除本地账号密码
            if (!kj_login) {
                kj_login = [[loginViewController alloc] init];
                kj_login.delegate = self;
            }
            [[self appRootViewController] presentViewController:kj_login animated:YES completion:nil];
        });
    }
}

- (UIViewController *)appRootViewController{
    UIViewController*appRootVC=[UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController*topVC=appRootVC;
    while(topVC.presentedViewController) {
        topVC=topVC.presentedViewController;
    }
    return topVC;
}

#pragma mark loginDelegate
- (void)loginToRegister:(UIViewController *)viewController{
    if (!kj_register) {
        kj_register = [[RegisterViewController alloc] init];
        kj_register.delegate = self;
    }
    [[self appRootViewController] presentViewController:kj_register animated:YES completion:nil];
}

- (void)loginToForget:(UIViewController *)viewController{
    if (!kj_forget) {
        kj_forget = [[ForgetViewController alloc] init];
        kj_forget.delegate = self;
    }
    [[self appRootViewController] presentViewController:kj_forget animated:YES completion:nil];
}
#pragma mark registerDelegate
- (void)registerToLogin:(UIViewController *)viewController{
    if (!kj_login) {
        kj_login = [[loginViewController alloc] init];
        kj_login.delegate = self;
    }
    [[self appRootViewController] presentViewController:kj_login animated:YES completion:nil];
}
#pragma mark forgetDelegate
- (void)forgetToRegister:(UIViewController *)viewController{
    if (!kj_register) {
        kj_register = [[RegisterViewController alloc] init];
        kj_register.delegate = self;
    }
    [[self appRootViewController] presentViewController:kj_register animated:YES completion:nil];
}
- (void)forgerToLogin:(UIViewController *)viewController{
    if (!kj_login) {
        kj_login = [[loginViewController alloc] init];
        kj_login.delegate = self;
    }
    [[self appRootViewController] presentViewController:kj_login animated:YES completion:nil];
}

- (void)network{
    // 获取本地账号密码
    NSString *account = [[shareObjectModel shareObject] getAccountAndPassword][0];
    NSString *password = [[shareObjectModel shareObject] getAccountAndPassword][1];
    // 1-1-1  判断保存的账号密码是否正确
    [[shareObjectModel shareObject] isTrueForAcctont:account Password:password Block:^(BOOL successful, NSString *userID) {
        if (successful) { // 账号密码正确，登录成功
//            NSLog(@"登录成功!!! userID:%@",userID);
            [UserDataModel defaultDataModel].userID = userID;
            istrue = 1;
        }else{ // 登录失败
            NSLog(@"账号密码错误登录失败!!!");
            istrue = 2;
        }
        if (isUnload) {
            [self load];
        }
        
    }];
}

@end
