//
//  HelloWord.m
//  XinMinClub
//
//  Created by 贺军 on 16/4/13.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "HelloWord.h"
#import "HomeViewController.h"
#import <CommonCrypto/CommonDigest.h>
#import "LoginViewController.h"
#import "HomeNavController.h"

@interface HelloWord ()<LogSuccessfully>{
    LoginViewController*loginView;
}
//@property(nonatomic,strong)UIImageView *advertisement;

@end

static NSString *encryptionKey = @"1342534278964210906074784732150231";

@implementation HelloWord

// 自己写的加密函数
- (NSString *)md5EncryptWithString:(NSString *)string{
    NSString *content =[NSString stringWithFormat:@"%@%@", encryptionKey, string];
    const char *char1 = [content cStringUsingEncoding:NSUTF8StringEncoding];
    NSInteger k = foo1(char1);
    NSMutableArray *a=[NSMutableArray array];
    for (NSInteger i = 0; i<k; i++) {
        NSString *s=[content substringWithRange:NSMakeRange(i,1)];
        [a addObject:s];
    }
    //--------------------
    NSString *s1=a[2];
    a[2]=a[a.count-1];
    a[a.count-1]=s1;
    
    NSString *s2=a[4];
    a[4]=a[a.count-2];
    a[a.count-2]=s2;
    
    NSString *s3=a[7];
    a[7]=a[a.count-3];
    a[a.count-3]=s3;
    
    NSString *s4=a[10];
    a[10]=a[a.count-4];
    a[a.count-4]=s4;
    
    NSString *s5=a[14];
    a[14]=a[a.count-5];
    a[a.count-5]=s5;
    
    NSString *s6=a[18];
    a[18]=a[a.count-6];
    a[a.count-6]=s6;
    
    NSString *s7=a[20];
    a[20]=a[a.count-7];
    a[a.count-7]=s7;
    
    NSString *s8=a[24];
    a[24]=a[a.count-8];
    a[a.count-8]=s8;
    
    NSString *s9=a[27];
    a[27]=a[a.count-9];
    a[a.count-9]=s9;
    //--------------------
    NSString *sss=@"";
    for (int i=0; i<a.count; i++) {
        sss=[sss stringByAppendingString:a[i]];
    }
    return sss;
}

// 自己写的解密方法
-(NSString*)decryption:(NSString*)MyDecryption{
    //NSLog(@"%@",MyDecryption);
    NSInteger k = foo1([MyDecryption cStringUsingEncoding:NSUTF8StringEncoding]);
    NSMutableArray *a = [NSMutableArray array];
    for (NSInteger i = 0; i<k; i++) {
        NSString *s=[MyDecryption substringWithRange:NSMakeRange(i,1)];
        [a addObject:s];
    }
    NSString *s1=a[2];
    a[2]=a[a.count-1];
    a[a.count-1]=s1;
    
    NSString *s2=a[4];
    a[4]=a[a.count-2];
    a[a.count-2]=s2;
    
    NSString *s3=a[7];
    a[7]=a[a.count-3];
    a[a.count-3]=s3;
    
    NSString *s4=a[10];
    a[10]=a[a.count-4];
    a[a.count-4]=s4;
    
    NSString *s5=a[14];
    a[14]=a[a.count-5];
    a[a.count-5]=s5;
    
    NSString *s6=a[18];
    a[18]=a[a.count-6];
    a[a.count-6]=s6;
    
    NSString *s7=a[20];
    a[20]=a[a.count-7];
    a[a.count-7]=s7;
    
    NSString *s8=a[24];
    a[24]=a[a.count-8];
    a[a.count-8]=s8;
    
    NSString *s9=a[27];
    a[27]=a[a.count-9];
    a[a.count-9]=s9;
    
    NSString *sss=@"";
    for (int i=0; i<a.count; i++) {
        sss=[sss stringByAppendingString:a[i]];
    }
    return sss;
}
// 判断字符串长度
int foo1(const char *p){
    if (*p == '\0')    //指针偏移，偏移到\0的时候结束
        return 0;   //如果取出来的值是\0的话就直接返回一个0
    else    //否则就返回下面的foo1
        return foo1(p + 1) + 1;//递归一直掉用函数foo1，直到最后一位\0，开始return 0；
    //  p+1先偏移到下一个位置，然后长度加1,得到字符串长度
}

// 加密账号和密码并存储
-(void)setAccount:(NSString*)account Password:(NSString*)password{
    NSString *account1 = [self md5EncryptWithString:account];
    NSString *password1 = [self md5EncryptWithString:password];
    NSMutableArray *data = [NSMutableArray array];
    [data addObject:account1];
    [data addObject:password1];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"Account"];//以字典形式存在NSUserDefaults当中
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)getAccount{
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    NSString *account = [userD arrayForKey:@"Account"][0];
    NSString *password = [userD arrayForKey:@"Account"][1];
    if (account != nil && password != nil) {
        self.ThereAreNoPassword = YES;
        NSString *account1 = [[self decryption:account] substringFromIndex:34];
        NSString *password1 = [[self decryption:password] substringFromIndex:34];
        loginView = [[LoginViewController alloc]init];
        loginView.delegateFully=self;
        [loginView JudgeAccountSuccessfully:account1 Password:password1];
    }else{
        self.ThereAreNoPassword = NO;
    }
}
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//    self.ThereAreNoPassword=YES;
//    [self getAccount];
//}

- (id)init{
    if (self==[super init]) {
        self.ThereAreNoPassword = YES;
//        [self getAccount];
    }
    return self;
}

//- (UIImageView *)advertisement{
//    if (!_advertisement) {
//        _advertisement = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//            }
//    return _advertisement;
//}
//-(void)setAdvertisementImage:(UIImage *)advertisementImage{
//    [self.view addSubview:self.advertisement];
//    [self.view bringSubviewToFront:self.advertisement];
//    _advertisement.image =advertisementImage;
////    [self AdvertisingdDisplayTime];
//}
-(void)PlayProgressTimer{
    //本地密码正确
    HomeNavController *nav = [[HomeNavController alloc] initWithRootViewController:[HomeViewController shareObject]];
//    CATransition *animation = [CATransition animation];
//    animation.duration = 1.0;
//    animation.timingFunction = UIViewAnimationCurveEaseInOut;
//    animation.type = @"rippleEffect";
//    //animation.type = kCATransitionPush;
//    animation.subtype = kCATransitionFromTop;
//    [self.view.window.layer addAnimation:animation forKey:nil];
    [self presentViewController:nav animated:NO completion:nil];
}

-(void)PasswordMistake{
    //账号和密码错误
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"账号和密码不正确" message:@"请重新输入!!!" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        LoginViewController *login=[[LoginViewController alloc]init];
        [self presentViewController:login animated:NO completion:nil];
    }];
    [alertController addAction:action1];
    [self presentViewController:alertController animated:YES completion:NULL];
}
-(void)accountState:(NSInteger)state{
    if (state==1) {
       [self PlayProgressTimer];
    }
    else if (state==4) {
        [self PasswordMistake];
    }
    else if (state==2) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"网络连接失败" message:@"请检查你的网络!!!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"網絡連接失敗!!");
        }];
        [alertController addAction:action1];
        [self presentViewController:alertController animated:YES completion:NULL];
    }
    else if (state==3) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"网络连接失败" message:@"请检查你的网络!!!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"網絡連接失敗!!");
        }];
        [alertController addAction:action1];
        [self presentViewController:alertController animated:YES completion:NULL];
    }
}

// 删除账号
+(BOOL)deleteAccount{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Account"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return YES;
}

@end

