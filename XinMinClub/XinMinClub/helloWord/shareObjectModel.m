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
    // 后台对数据类型的需要
    NSDictionary *dict = @{@"PhoneNo":account, @"PassWord":password};
    NSString *paramString = [networkSection getParamStringWithParam:@{@"FunName":@"Login",@"Params":dict}];
    [networkSection getLoadJsonDataWithUrlString:IPUrl param:paramString];
    //回调函数获取数据
    [networkSection setGetLoadRequestDataClosuresCallBack:^(NSDictionary *json) {
        NSString *str = [[json valueForKey:@"RET"] valueForKey:@"DATA"];
        if ([str isEqualToString:@"0"]) {
            NSLog(@"账号密码错误!!!");
            Block(false,str);
        }else{
            NSLog(@"账号密码正确!!!");
            Block(true,str);
        }
    }];
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
