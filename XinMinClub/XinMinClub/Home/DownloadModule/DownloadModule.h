//
//  DownloadModule.h
//  XinMinClub
//
//  Created by 赵劲松 on 16/5/4.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SectionData.h"

@protocol FinishDelegate <NSObject>

@optional
- (void)finishDownloadSection;

@end

@interface DownloadModule : NSObject

// 开始下载
- (void)startDownload:(SectionData *)sectionData;
- (void)pauseDownload;

// 下载中章节
@property (nonatomic, strong) SectionData *sectionData;

@property (nonatomic, strong) NSMutableArray *urlArr;
@property (nonatomic, assign) id <FinishDelegate> delegate;

+ (instancetype)defaultDataModel;

@end
