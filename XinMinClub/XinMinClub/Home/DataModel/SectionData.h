//
//  SectionData.h
//  XinMinClub
//
//  Created by 赵劲松 on 16/3/31.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SectionData : NSObject

// 章节名
@property (nonatomic, copy) NSString *sectionName;
// 章节ID
@property (nonatomic, copy) NSString *sectionID;
// 作者名
@property (nonatomic, copy) NSString *author;
// 文集名
@property (nonatomic, copy) NSString *bookName;
// 播放次数
@property (nonatomic, copy) NSString *playCount;
// 是否添加到最近播放
@property (nonatomic, assign) BOOL isAddRecent;
// 是否喜欢
@property (nonatomic, assign) BOOL isLike;
// 是否下载
@property (nonatomic, assign) BOOL isDownload;
// 下载进度
@property (nonatomic, assign) CGFloat progress;

- (id)initWithDic: (NSDictionary *)dic;
+ (id)sectionWithDic: (NSDictionary *)dic;


// 书集1级分类
@property (nonatomic, strong) NSString *ZY_TYPE;
@property (nonatomic, strong) NSString *ZY_E;
@property (nonatomic, strong) NSString *ZY_CONTENT;
@property (nonatomic, strong) NSString *ZY_TIME;
@property (nonatomic, strong) NSString *ZY_PID;
@property (nonatomic, strong) NSString *ZY_NAME;
@property (nonatomic, strong) NSString *ZY_ID;
@property (nonatomic, strong) NSString *ZY_USER;
@property (nonatomic, strong) NSString *ZY_ISORT;


// 文集的Data
// 文集的阅读量
@property (nonatomic, strong) NSString *libraryReadTotal;
// 区分不同文集的编号
@property (nonatomic, strong) NSString *libraryNum;
// 书集总数
@property (nonatomic, strong) NSString *libraryCount;
// 作者的名字
@property (nonatomic, strong) NSString *libraryAuthorName;
// 文集简介
@property (nonatomic, strong) NSString *libraryDetails;
// 文集封面
@property (nonatomic, strong) NSString *libraryImageUrl;
// 文集的标题
@property (nonatomic, strong) NSString *libraryTitle;
// 文集分类
@property (nonatomic, strong) NSString *libraryType;
// 文集时间
@property (nonatomic, strong) NSString *libraryTime;
// 文集语言
@property (nonatomic, strong) NSString *libraryLanguage;
// 作者的头像
@property (nonatomic, strong) NSString *libraryAuthorImageUrl;



// 这个是点击文集之后的内容(每一个章节)   章节Data
@property (nonatomic, strong) NSString *clickType; // 文集分类
@property (nonatomic, strong) NSString *clickSectionTotal; // 所有章节的数目
@property (nonatomic, strong) NSString *clickNewSectionNum; // 已经请求的章节数目

@property (nonatomic, strong) NSString *clickTitle; // 章节名字
@property (nonatomic, strong) NSString *clickSectionType; // 章节分类
@property (nonatomic, strong) NSString *clickLibraryID; // 文集ID
@property (nonatomic, strong) NSString *clickAuthor; // 文集作者
@property (nonatomic, strong) NSString *clickSectionCNText; // 章节简体中文内容
@property (nonatomic, strong) NSString *clickSectionANText; // 章节繁体中文内容
@property (nonatomic, strong) NSString *clickSectionENText; // 章节英文内容
@property (nonatomic, strong) NSString *clickTime; // 章节发布时间
@property (nonatomic, strong) NSString *clickNameRank; // 章节名称排序
@property (nonatomic, strong) NSString *clickTypeRank; // 章节分类排序
@property (nonatomic, strong) NSString *clickMp3; // 章节MP3
@property (nonatomic, strong) NSString *clickRemarks; // 备注
@property (nonatomic, strong) NSString *clickSectionID; // 章节ID



// 用户评价（文集的评价）用户评价Data
@property (nonatomic, strong) NSString *commentImageUrl; // 评价者头像Url
@property (nonatomic, strong) NSString *commentName; // 评价者名字
@property (nonatomic, strong) NSString *commentTime; // 评价时间
@property (nonatomic, strong) NSString *commentText; // 评价内容
@property (nonatomic, strong) NSString *commentUserID; // 评价作者ID
@property (nonatomic, strong) NSString *commentBookID; // 评价书集ID
@property (nonatomic, strong) NSString *commentID; // 评价ID


@end
