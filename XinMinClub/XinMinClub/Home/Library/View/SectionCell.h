//
//  SectionCell.h
//  XinMinClub
//
//  Created by yangkejun on 16/3/22.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SectionCell : UITableViewCell

@property(nonatomic, assign) NSInteger indexNum;
@property (nonatomic, strong) NSString *sectionIsMp3; // 判断是否是mp3的章节
@property (nonatomic, strong) NSString *sectionName;  // 章节名字
@property (nonatomic, strong) NSString *libraryName; // 文集名字
@property (nonatomic,assign) NSInteger ClickOnTheButton;
// 章节数
@property (nonatomic, strong) NSArray *sectionNameArray;
@property (nonatomic, strong) NSArray *sectionIDArray;
@property (nonatomic, strong) NSArray *sectionMp3Array;
@property (nonatomic, strong) NSArray *sectionCNArray;
@property (nonatomic, strong) NSArray *sectionANArray;
@property (nonatomic, strong) NSArray *sectionENArray;
@end
