//
//  LocalAuthor.h
//  XinMinClub
//
//  Created by 赵劲松 on 16/4/4.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LocalAuthorDelegate <NSObject>

- (void)popEssayList;

@end

@interface LocalAuthor : UITableViewController

@property (nonatomic, assign) NSInteger localAuthor;
@property (nonatomic, assign) id <LocalAuthorDelegate> delegate;

@end
