//
//  ILikeAuthor.h
//  XinMinClub
//
//  Created by 赵劲松 on 16/3/30.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ILikeAuthorDelegate <NSObject>

- (void)popEssayList;

@end

@interface ILikeAuthor : UITableViewController

@property (nonatomic, assign) NSInteger authorNum;
@property (nonatomic, assign) id <ILikeAuthorDelegate> delegate;

@end
