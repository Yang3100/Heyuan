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

@interface HelloViewController (){
    UIImage *adImage;
    UIButton *but; // 跳过
    NSTimer *timer; // 定时器
    NSInteger num;
    int istrue;
    BOOL isUnload;
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
    but = [UIButton buttonWithType:UIButtonTypeCustom];
    but.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-60, 30, 40, 40);
    but.backgroundColor = [UIColor purpleColor];
    but.layer.masksToBounds = YES;
    but.layer.cornerRadius = 20;
    but.layer.borderWidth = 1;
    [but addTarget:self action:@selector(butAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:but];
}

- (void)ADImage:(UIImage*)adim waitingTime:(NSTimeInterval)time{
    adImage = adim;
    num = time;
    
    [self network];
    
    [self initView];
}

// 定时器执行操作方法
- (void)updateTimer {
    [but setTitle:[NSString stringWithFormat:@"%ld秒",(long)num] forState:UIControlStateNormal];
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
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:hvc];
            [self presentViewController:nav animated:YES completion:^{
                
            }];
        });
    }else{
        NSLog(@"登录失败!!!");
    }
}

- (void)network{
    // 获取本地账号密码
    NSString *account = [[shareObjectModel shareObject] getAccountAndPassword][0];
    NSString *password = [[shareObjectModel shareObject] getAccountAndPassword][1];
    // 1-1-1  判断保存的账号密码是否正确
    [[shareObjectModel shareObject] isTrueForAcctont:account Password:password Block:^(BOOL successful, NSString *userID) {
        if (successful) { // 账号密码正确，登录成功
            NSLog(@"登录成功!!! userID:%@",userID);
            [UserDataModel defaultDataModel].userID = userID;
            istrue = 1;
        }else{ // 登录失败
            NSLog(@"登录失败!!!");
            istrue = 2;
        }
        if (isUnload) {
            [self load];
        }
        
    }];
}

@end
