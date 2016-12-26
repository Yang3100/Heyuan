//
//  UserDataModel.h
//  XinMinClub
//
//  Created by 赵劲松 on 16/4/11.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SectionData.h"
#import "BookData.h"

@interface UserDataModel : NSObject

@property (nonatomic, strong) UIImage *userImage;
@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *userUID;
@property (nonatomic, copy) NSString *userSex;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userBornDate;
@property (nonatomic, copy) NSString *userCity;
@property (nonatomic, copy) NSString *userIntroduction;
@property (nonatomic, strong) NSMutableArray <SectionData *> *userLikeSection;
@property (nonatomic, strong) NSMutableArray <NSString *> *userLikeSectionID;
@property (nonatomic, strong) NSMutableArray <BookData *> *userLikeBook;
@property (nonatomic, strong) NSMutableArray <NSString *> *userLikeBookID;
@property (nonatomic, strong) NSMutableArray *userLikeAuthor;
@property (nonatomic, strong) NSMutableDictionary *userRecentPlayIDAndCount;
// 播放定时
@property (nonatomic, assign) NSString *playTime;
// 资料改变
@property (nonatomic, assign) BOOL isChange;
// 重载
@property (nonatomic, assign) BOOL isReload;

+ (instancetype)defaultDataModel; // 单例

// 网络部分
- (void)loginOut;// 注销
- (void)keepSession;// 保持会话
- (void)initData;// 初始化数据
- (void)saveLike;// 保存收藏
- (void)getLike;// 取得收藏章节和文集
- (void)saveUserInternetData;// 网络保存用户资料
- (void)saveRecommend;// 保存推荐
- (void)getRecommend;// 取得推荐
- (void)deleteRecommend;// 删除推荐
- (void)getUserData;// 网络取得用户资料
- (void)saveLocalData;// 本地保存用户资料和数据
- (void)loadLocalData;// 加载本地用户资料和数据
- (void)getMyBook;// 取得"我的"文集
- (void)saveUserImage;// 网络保存用户头像
- (void)getUserImage; // 取得用户头像

// 本地部分
//- (void)getMyLocalBook;// 取得本地我的文集
- (void)judgeIsDelete;// 判断收藏是否删改
- (void)addLikeBookID:(NSString *)libraryNum; // 添加喜欢的文集ID
- (void)deleteLikeBookID:(NSString *)libraryNum; // 删除喜欢的文集ID
- (void)addLikeSectionID:(NSString *)sectionID; // 添加喜欢章节
- (void)deleteLikeSectionID:(NSString *)sectionID; // 删除喜欢章节

@end
