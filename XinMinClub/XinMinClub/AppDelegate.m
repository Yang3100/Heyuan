//
//  AppDelegate.m
//  XinMinClub
//
//  Created by yangkejun on 16/3/18.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import "HelloViewController.h"
#import "ICETutorialController.h"
#import "loginView.h"
#import "RegisterViewController.h"

@interface AppDelegate ()<WXApiDelegate, ICETutorialControllerDelegate>{
    ICETutorialController *leadViewController;
}

@end

@implementation AppDelegate

-(void)applicationWillResignActive:(UIApplication *)application{
    AVAudioSession *session=[AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    //后台播放
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event{
    if(event.type==UIEventTypeRemoteControl)
    {
        NSInteger order=-1;
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlPause:
                order=UIEventSubtypeRemoteControlPause;
                break;
            case UIEventSubtypeRemoteControlPlay:
                order=UIEventSubtypeRemoteControlPlay;
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                order=UIEventSubtypeRemoteControlNextTrack;
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                order=UIEventSubtypeRemoteControlPreviousTrack;
                break;
            case UIEventSubtypeRemoteControlTogglePlayPause:
                order=UIEventSubtypeRemoteControlTogglePlayPause;
                break;
            default:
                order=-1;
                break;
        }
        NSDictionary *orderDict=@{@"order":@(order)};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kAppDidReceiveRemoteControlNotification" object:nil userInfo:orderDict];
    }
}

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [WXApi registerApp:@"wxd1e9cf61f91dac3f" withDescription:@"weixin"];

    // 一句话解决所有TableView的多余cell就一句代码放在AppDelegate里
    [[UITableView appearance] setTableFooterView:[UIView new]];
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    // 返回按钮
    [self setNavigationBarBackButton:nil withText:@""];
    [self setColor];

    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 创建并设置UIWindow
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
   
    // 1.判断本地有无保存账号密码
    if ([[shareObjectModel shareObject] isSaveAccountAndPassword]) { // 1-1  本地保存了账号密码
        HelloViewController *hvc = [[HelloViewController alloc] init];
        hvc.view.backgroundColor = [UIColor purpleColor];
        [hvc ADImage:cachePicture waitingTime:3];
        self.window.rootViewController = hvc;
    }else { // 1-2  本地没有保存账号密码
        // 设置滚动的文字和图片
        ICETutorialPage *layer1 = [[ICETutorialPage alloc] initWithTitle:@"雅書華學舘" subTitle:@"仁愛謹信  知行合一" pictureName:@"tu1" duration:3.0];
        ICETutorialPage *layer2 = [[ICETutorialPage alloc] initWithTitle:@"雅書華學舘" subTitle:@"雅讀詩書氣質華" pictureName:@"tu2" duration:3.0];
        ICETutorialPage *layer3 = [[ICETutorialPage alloc] initWithTitle:@"樂 學 堂" subTitle:@"仁愛謹信  知行合一" pictureName:@"tu3" duration:3.0];
        ICETutorialPage *layer4 = [[ICETutorialPage alloc] initWithTitle:@"樂 學 堂" subTitle:@"好學者不如樂學者" pictureName:@"tu4" duration:3.0];
        NSArray *tutorialLayers = @[layer1,layer2,layer3,layer4];
        // Set the common style for the title.
        ICETutorialLabelStyle *titleStyle = [[ICETutorialLabelStyle alloc] init];
        [titleStyle setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17.0f]];
        [titleStyle setTextColor:[UIColor whiteColor]];
        [titleStyle setLinesNumber:1];
        [titleStyle setOffset:180];
        [[ICETutorialStyle sharedInstance] setTitleStyle:titleStyle];
        // Set the subTitles style with few properties and let the others by default.
        [[ICETutorialStyle sharedInstance] setSubTitleColor:[UIColor whiteColor]];
        [[ICETutorialStyle sharedInstance] setSubTitleOffset:150];
        // Init tutorial.
        leadViewController = [[ICETutorialController alloc] initWithPages:tutorialLayers delegate:self];
        // Run it.
        [leadViewController startScrolling];
        self.window.rootViewController = leadViewController;
    }
    
    return YES;
}

- (void)setColor {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [[UINavigationBar appearance] setTintColor:RGB255_COLOR(48, 48, 48, 1)]; // 返回按钮颜色
    [[UINavigationBar appearance] setBarTintColor:RGB255_COLOR(231, 178, 102, 1)]; // navigation背景颜色
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:RGB255_COLOR(48, 48, 48, 1), NSForegroundColorAttributeName, [UIFont boldSystemFontOfSize:18], NSFontAttributeName, nil]]; // 标题文字颜色
    //    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)setNavigationBarBackButton:(UIImage *)image withText:(NSString *)text {
    if ([text isEqualToString:@""]) {
        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
    }
    UIImage *backButtonImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 30, 0, 0)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
}

#pragma mark WXApiDelegate
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
    [WXApi handleOpenURL:url delegate:self];
    return YES;
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    [WXApi handleOpenURL:url delegate:self];
    return YES;
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    [WXApi handleOpenURL:url delegate:self];
    return YES;
}
#pragma mark WeChat登录,登陆成功的通知
- (void)onResp:(BaseResp *)resp {
    //WeChat
    if ([resp isKindOfClass:[SendAuthResp class]]){
        SendAuthResp *rep = (SendAuthResp *)resp;
        if (rep.errCode == 0) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:WXLoginSuccess object:@{@"code":rep.code}];
            NSLog(@"%dloadSuccess!!!,错误提示字段%@,响应类型:%d",rep.errCode,rep.errStr,rep.type);
        }else{
            NSLog(@"%dloadSuccess!!!,错误提示字段%@,响应类型:%d",rep.errCode,rep.errStr,rep.type);
        }
        
    }
    
    //QQ
}

#pragma mark - ICETutorialController delegate
- (void)tutorialController:(ICETutorialController *)tutorialController didClickOnLeftButton:(UIButton *)sender {
//    NSLog(@"点击了登录");
    loginView *lv = [[loginView alloc] init];
    [leadViewController presentViewController:lv animated:YES completion:nil];
}

- (void)tutorialController:(ICETutorialController *)tutorialController didClickOnRightButton:(UIButton *)sender {
//    NSLog(@"点击了注册");
    RegisterViewController *rvc = [[RegisterViewController alloc] init];
    [leadViewController presentViewController:rvc animated:YES completion:nil];
}


@end
