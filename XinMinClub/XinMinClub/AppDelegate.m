//
//  AppDelegate.m
//  XinMinClub
//
//  Created by yangkejun on 16/3/18.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "AppDelegate.h"
#import "RegisterViewController.h"
#import "ForgetViewController.h"
#import <AVFoundation/AVFoundation.h>


@interface AppDelegate ()<WXApiDelegate,ICETutorialControllerDelegate, LoginDelegate, RegisterDelegate, ForgetDelegate> { //添加代理
    RegisterViewController *rvc;
    ForgetViewController *fvc;
    
}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    [WXApi registerApp:(@"wxd1e9cf61f91dac3f")];//注册appID
    
    //后台播放音频设置
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    // 一句话解决所有TableView的多余cell就一句代码放在AppDelegate里
    [[UITableView appearance] setTableFooterView:[UIView new]];
    
    // Init the pages texts, and pictures.
    ICETutorialPage *layer1 = [[ICETutorialPage alloc] initWithTitle:@"雅書華學舘" subTitle:@"仁愛謹信  知行合一" pictureName:@"tu1" duration:3.0];
    ICETutorialPage *layer2 = [[ICETutorialPage alloc] initWithTitle:@"雅書華學舘" subTitle:@"雅讀詩書氣質華" pictureName:@"tu2" duration:3.0];
    ICETutorialPage *layer3 = [[ICETutorialPage alloc] initWithTitle:@"樂 學 堂" subTitle:@"仁愛謹信  知行合一" pictureName:@"tu3" duration:3.0];
    ICETutorialPage *layer4 = [[ICETutorialPage alloc] initWithTitle:@"樂 學 堂" subTitle:@"好學者不如樂學者" pictureName:@"tu4" duration:3.0];
    //    ICETutorialPage *layer5 = [[ICETutorialPage alloc] initWithTitle:@"Picture 5" subTitle:@"The Louvre's Museum Pyramide" pictureName:@"5@2x.jpg" duration:3.0];
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
    self.leadViewController = [[ICETutorialController alloc] initWithPages:tutorialLayers delegate:self];
    // Run it.
    [self.leadViewController startScrolling];
    
    // 设置window
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = self.leadViewController;
    
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [WXApi registerApp:@"wxd1e9cf61f91dac3f" withDescription:@"weixin"];
    
//    self.window.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"1false.jpg"]];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"19" ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    self.window.layer.contents = (id)image.CGImage;
    [self.window makeKeyAndVisible];
    [self.leadViewController touchhhhhh];
    
//    _helloWord = [[HelloWord alloc] init];
//    if (_helloWord.ThereAreNoPassword) {
//        
//    }else
//        [_helloWord getAccount];
//    if (_helloWord.ThereAreNoPassword) {
//        [self.leadViewController presentViewController:_helloWord animated:YES completion:nil];
//    }
//    else{
//        [self.leadViewController presentViewController:_loginView animated:YES completion:nil];
//    }
    
    // 返回按钮
    [self setNavigationBarBackButton:nil withText:@""];
    [self setColor];
    
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
    else {
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
#pragma mark start

- (void)startApp {
    if (!_helloWord) {
        _helloWord = [[HelloWord alloc] init];
    }
    [_helloWord getAccount];
    _loginView=[[LoginViewController alloc]init];
    _loginView.delegate = self;
    if (_helloWord.ThereAreNoPassword) {
        self.window.rootViewController = _helloWord;
    }else{
        self.window.rootViewController = _loginView;
    }
}

#pragma mark - ICETutorialController delegate
- (void)tutorialController:(ICETutorialController *)tutorialController scrollingFromPageIndex:(NSUInteger)fromIndex toPageIndex:(NSUInteger)toIndex {
//    NSLog(@"Scrolling from page %lu to page %lu.", (unsigned long)fromIndex, (unsigned long)toIndex);
}

- (void)tutorialControllerDidReachLastPage:(ICETutorialController *)tutorialController {
//    NSLog(@"最后一张图片需要做的事情");
} 

- (void)tutorialController:(ICETutorialController *)tutorialController didClickOnLeftButton:(UIButton *)sender {
//    NSLog(@"点击了登录");
    if (!_helloWord) {
        _helloWord = [[HelloWord alloc] init];
    }
    [_helloWord getAccount];
//    UIImage *im = [[UIImage imageNamed:@"goAd"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    _helloWord.advertisementImage = im;
    _loginView=[[LoginViewController alloc]init];
    _loginView.delegate = self;
    if (_helloWord.ThereAreNoPassword) {
        [self.leadViewController presentViewController:_helloWord animated:NO completion:nil];
    }else{
        [self.leadViewController presentViewController:_loginView animated:NO completion:nil];
    }
}

- (void)tutorialController:(ICETutorialController *)tutorialController didClickOnRightButton:(UIButton *)sender {
//    NSLog(@"点击了注册");
    if (!rvc) {
        rvc = [[RegisterViewController alloc] init];
        rvc.delegate = self;
    }
    // 设置切换动画
    CATransition *animation = [CATransition animation];
    animation.duration = 0.6;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"rippleEffect";
    [self.window.layer addAnimation:animation forKey:nil];
    rvc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.leadViewController presentViewController:rvc animated:YES completion:nil];
}


#pragma mark LoginDelegate
- (void)loginForget {
    if (!fvc) {
        fvc = [[ForgetViewController alloc] init];
        fvc.delegate = self;
    }
//    fvc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.leadViewController presentViewController:fvc animated:NO completion:nil];
}

- (void)loginRegister {
    if (!rvc) {
        rvc = [[RegisterViewController alloc] init];
        rvc.delegate = self;
    }
    rvc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.leadViewController presentViewController:rvc animated:YES completion:nil];
}

- (void)registerLogin {
    if (!_helloWord) {
        _helloWord = [[HelloWord alloc] init];
    }
    [_helloWord getAccount];
//    UIImage *im = [[UIImage imageNamed:@"goAd"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    _helloWord.advertisementImage=im;
    if (_helloWord.ThereAreNoPassword) {
        [self.leadViewController presentViewController:_helloWord animated:NO completion:nil];
    }else{
        LoginViewController *loginView=[[LoginViewController alloc]init];
        [self.leadViewController presentViewController:loginView animated:NO completion:nil];
    }
}

#pragma mark ForgetDelegate
- (void)forgetRegister {
    if (!rvc) {
        rvc = [[RegisterViewController alloc] init];
        rvc.delegate = self;
    }
    rvc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.leadViewController presentViewController:rvc animated:YES completion:nil];
}
- (void)forgetLogin {
    if (!_helloWord) {
        _helloWord = [[HelloWord alloc] init];
    }
    [_helloWord getAccount];
//    UIImage *im = [[UIImage imageNamed:@"goAd"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    _helloWord.advertisementImage=im;
    if (_helloWord.ThereAreNoPassword) {
        [self.leadViewController presentViewController:_helloWord animated:NO completion:nil];
    }else{
        LoginViewController *loginView=[[LoginViewController alloc]init];
        [self.leadViewController presentViewController:loginView animated:NO completion:nil];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}


@end
