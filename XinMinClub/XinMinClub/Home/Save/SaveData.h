//
//  SaveData.h
//  XinMinClub
//
//  Created by yangkejun on 16/4/7.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVKit/AVKit.h>

@interface SaveData : NSObject

// 区分不同文集的编号
@property(nonatomic,copy) NSString *bookNum;
// 区分本地文集和网络文集是否一致的问题
@property(nonatomic,copy) NSString *versionNum;
// 文集封面
@property(nonatomic,copy) NSString *bookImageUrl;
// 文集的标题
@property(nonatomic,copy) NSString *bookTitle;
// 作者的名字
@property(nonatomic,copy) NSString *bookAuthorName;
// 作者的头像
@property(nonatomic,copy) NSString *bookAuthorImageUrl;
// 文集内容
@property(nonatomic,copy) NSDictionary *bookContent;
// 文集详情
@property(nonatomic,copy) NSArray *bookDetails;

@end
