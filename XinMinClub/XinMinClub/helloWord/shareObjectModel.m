//
//  shareObjectModel.m
//  LoginSection
//
//  Created by 杨科军 on 2016/12/15.
//  Copyright © 2016年 杨科军. All rights reserved.
//

#import "shareObjectModel.h"

@implementation shareObjectModel

+(instancetype)shareObject{
    static shareObjectModel *som = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        som = [[super allocWithZone:NULL] init];
    });
    return som;
}

// 加密账号和密码并存储
- (void)setAccount:(NSString*)account Password:(NSString*)password {
    NSArray *array = @[account,password];
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"AccountAndPassword"];//以字典形式存在NSUserDefaults当中
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// 删除账号
- (BOOL)deleteAccountAndPassword{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"AccountAndPassword"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return YES;
}

// 判断本地是否保存了账号密码
- (BOOL)isSaveAccountAndPassword{
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    if ([userD arrayForKey:@"AccountAndPassword"]) {
        return true;
    }else
        return false;
}

// 判断账号密码是否正确->userID(在回调函数Block当中返回userID)
- (void)isTrueForAcctont:(NSString*)account Password:(NSString*)password Block:(void(^)(BOOL successful, NSString *userID))Block {
    // 创建会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    // 设置请求路径
    NSURL *URL=[NSURL URLWithString:IPUrl];//不需要传递参数
    // 创建请求对象
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];//默认为get请求
    request.timeoutInterval=5.0;//设置请求超时为5秒
    request.HTTPMethod=@"POST";//设置请求方法
    // 参数..
    NSString *param = [NSString stringWithFormat:@"{\"FunName\":\"Login\",\"Params\":{\"PhoneNo\":\"%@\",\"PassWord\":\"%@\"}}",account,password];
    NSLog(@"%@",param);
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // 解析数据
        if (data != nil) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            if (dict!=nil) {
                NSString *userid = [[dict valueForKey:@"RET"] valueForKey:@"DATA"];
                if ([userid isEqualToString:@"0"]) {
                    NSLog(@"账号密码错误!!!");
                    Block(false,userid);
                }else{
                    NSLog(@"账号密码正确!!!");
                    Block(true,userid);
                }
            }else
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    // 服务器无反应
                    [self addAlertViewTitle:@"网络连接失败😔😔" Message:@"😥😥请稍后再试!!!"];
                });
        }else
            dispatch_async(dispatch_get_main_queue(), ^(void){
                // 无网络
                [self addAlertViewTitle:@"网络连接失败😱😱" Message:@"😀😀请检查你的网络!!!"];
            });
    }];
    // 执行任务
    [dataTask resume];
    
}
#pragma mark 弹出AlertView
-(void)addAlertViewTitle:(NSString*)title Message:(NSString*)message{
    
    UIView *baView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    baView.backgroundColor = [UIColor blackColor];
    baView.alpha = 0.5;
    [[self appRootViewController].view addSubview:baView];
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, SCREEN_WIDTH/2*(9/7))];
    backView.center = [self appRootViewController].view.center;
    
    UIImageView *diImageView = [[UIImageView alloc] initWithFrame:backView.bounds];
    diImageView.image = [UIImage imageNamed:@"底"];
    [backView addSubview:diImageView];
    
    UIButton *qudingBut = [UIButton buttonWithType:UIButtonTypeCustom];
    qudingBut.frame = CGRectMake(0, SCREEN_WIDTH/2*(9/7)-SCREEN_WIDTH/12-3, SCREEN_WIDTH/2, SCREEN_WIDTH/12);
    [qudingBut setImage:[UIImage imageNamed:@"确定"] forState:UIControlStateNormal];
    [qudingBut addTarget:self action:@selector(returnView) forControlEvents:UIControlEventTouchUpInside];
    
    [backView addSubview:qudingBut];
    
    [[self appRootViewController].view addSubview:backView];
    
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        NSLog(@"无网络或者服务器无连接!!!");
//        HomeViewController *hvc = [[HomeViewController alloc] init];
//        HomeNavController *nav = [[HomeNavController alloc] initWithRootViewController:hvc];
//        CATransition *animation = [CATransition animation];
//        animation.duration = 1.0;
//        animation.timingFunction = UIViewAnimationCurveEaseInOut;
//        animation.type = @"rippleEffect";
//        [[self appRootViewController].view.window.layer addAnimation:animation forKey:nil];
//        [[self appRootViewController] presentViewController:nav animated:YES completion:^{
//            [UserDataModel defaultDataModel].userID = nil;
//        }];
//
//    }];
//    [alertController addAction:action1];
//    [[self appRootViewController] presentViewController:alertController animated:YES completion:NULL];
}

- (void)returnView{
        HomeViewController *hvc = [[HomeViewController alloc] init];
        HomeNavController *nav = [[HomeNavController alloc] initWithRootViewController:hvc];
//        CATransition *animation = [CATransition animation];
//        animation.duration = 1.0;
//        animation.timingFunction = UIViewAnimationCurveEaseInOut;
//        animation.type = @"rippleEffect";
//        [[self appRootViewController].view.window.layer addAnimation:animation forKey:nil];
        [[self appRootViewController] presentViewController:nav animated:YES completion:^{
            [UserDataModel defaultDataModel].userID = nil;
            [[NSNotificationCenter defaultCenter] removeObserver:self name:@"wechatLoadSucessful" object:nil];
        }];
}

- (UIViewController *)appRootViewController{
    UIViewController *appRootVC=[UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC=appRootVC;
    while(topVC.presentedViewController) {
        topVC=topVC.presentedViewController;
    }
    return topVC;
}

// 获取本地账号和密码
- (NSArray *)getAccountAndPassword{
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    NSString *account = [userD arrayForKey:@"AccountAndPassword"][0];
    NSString *password = [userD arrayForKey:@"AccountAndPassword"][1];
    
    return [NSArray arrayWithObjects:account, password, nil];
}

//// 是否成功登录
//- (BOOL)isLoadTrue{
//    BOOL *boo=false;
//    return boo;
//}


@end
