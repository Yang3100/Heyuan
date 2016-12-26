//
//  BookCell.h
//  XinMinClub
//
//  Created by Jason_zzzz on 16/3/25.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SectionDelegate <NSObject>

@optional
- (void)sectionManage: (NSInteger)tag;

@end

@interface BookCell : UITableViewCell

@property (nonatomic, assign) id <SectionDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIView *statusView;
@property (weak, nonatomic) IBOutlet UILabel *sectionsName;
@property (weak, nonatomic) IBOutlet UILabel *authorName;
@property (weak, nonatomic) IBOutlet UIButton *accessoryButton;
@property (weak, nonatomic) IBOutlet UIProgressView *downloadProgress;

@end
