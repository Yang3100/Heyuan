//
//  shareObjectModel.h
//  LoginSection
//
//  Created by 杨科军 on 2016/12/15.
//  Copyright © 2016年 杨科军. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface shareObjectModel : NSObject

// 单例
+ (instancetype)shareObject;

// 加密账号和密码并存储
- (void)setAccount:(NSString*)account Password:(NSString*)password;

// 删除本地账号和密码
- (BOOL)deleteAccountAndPassword;

// 判断本地是否保存了账号密码
- (BOOL)isSaveAccountAndPassword;

// 获取本地账号和密码
- (NSArray*)getAccountAndPassword;

// 判断账号密码是否正确->userID(在回调函数Block当中返回userID)
- (void)isTrueForAcctont:(NSString*)account Password:(NSString*)password Block:(void(^)(BOOL successful, NSString *userID))Block;


//// 是否成功登录
//- (BOOL)isLoadTrue;

@end
