//
//  SaveClass.h
//  XinMinClub
//
//  Created by yangkejun on 16/4/7.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVKit/AVKit.h>
#import "SaveData.h"

@interface SaveClass : NSObject

// 单例
+ (instancetype)shareObject;

// 根据书集的标号判断是否已经存在本地,如果存在返回，如果不存在返回nil
- (NSArray*)isSave:(NSString *)bookNum VersionNumber:(NSString *)Version;

// 保存数据到本地(根据版本号和书的ID)
- (BOOL)saveData:(SaveData *)saveData bookNum:(NSString *)bookNum versionNum:(NSString *)versionNum;
-(void)aaaaa:(NSString*)a;//测试使用，
// 删除本地全部数据
- (BOOL)deleteAllData;

@end
