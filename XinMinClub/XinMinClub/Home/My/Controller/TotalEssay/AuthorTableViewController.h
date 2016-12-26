//
//  AuthorTableViewController.h
//  XinMinClub
//
//  Created by Jason_zzzz on 16/3/25.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AuthorDelegate <NSObject>

- (void)popEssayList;

@end

@interface AuthorTableViewController : UITableViewController

@property (nonatomic, assign) NSInteger authorNum;
@property (nonatomic, assign) id <AuthorDelegate> delegate;

@end
