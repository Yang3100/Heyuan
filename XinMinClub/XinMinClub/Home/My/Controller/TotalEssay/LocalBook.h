//
//  LocalBook.h
//  XinMinClub
//
//  Created by 赵劲松 on 16/4/4.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LocalEssayDelegate <NSObject>

- (void)popEssayList;

@end

@interface LocalBook : UITableViewController

@property (nonatomic, assign) id <LocalEssayDelegate> delegate;
@property (nonatomic, assign) NSInteger localBook;

@end
