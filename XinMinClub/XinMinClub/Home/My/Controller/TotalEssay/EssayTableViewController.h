//
//  EssayTableViewController.h
//  XinMinClub
//
//  Created by 赵劲松 on 16/3/29.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EssayDelegate <NSObject>

- (void)popEssayList;

@end

@interface EssayTableViewController : UITableViewController

@property (nonatomic, assign) NSInteger bookNum;
@property (nonatomic, assign) id <EssayDelegate> delegate;

@end
