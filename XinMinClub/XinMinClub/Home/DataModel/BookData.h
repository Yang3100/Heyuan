//
//  BookData.h
//  XinMinClub
//
//  Created by 赵劲松 on 16/4/25.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SectionData.h"

@interface BookData : NSObject

@property (nonatomic, strong) NSMutableArray *sections;
@property (nonatomic, copy) NSString *bookName;
@property (nonatomic, copy) NSString *bookID;
@property (nonatomic, copy) NSString *authorName;
@property (nonatomic, strong) UIImage *bookImage;
@property (nonatomic, strong) NSMutableArray *firstLevelList;
@property (nonatomic, strong) NSMutableDictionary *firstLevelListWithSecondLevelList;
@property (nonatomic, strong) NSMutableArray *secondLevelList;
@property (nonatomic, strong) NSString *imagePath;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *language;
@property (nonatomic, strong) NSString *details;

// 以字典初始化
- (id)initWithDic: (NSDictionary *)dic;

@end
