//
//  DeleteController.h
//  XinMinClub
//
//  Created by 赵劲松 on 16/4/13.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SectionData.h"

@protocol DownloadDelegate <NSObject>

@optional
- (void)downloadSection:(SectionData *)sectionData;

@end

@interface DeleteController : UIViewController

@property (nonatomic, strong) NSString *deleteDirectoryName;
@property (nonatomic, strong) NSMutableArray <SectionData *> *deleteArr;
@property (nonatomic, assign) id <DownloadDelegate> delegate;

@end
