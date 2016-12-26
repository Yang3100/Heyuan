//
//  MyViewController.h
//  XinMinClub
//
//  Created by yangkejun on 16/3/19.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SetViewController.h"
#import "UserViewController.h"

@protocol MyDelegate <NSObject>

- (void)pushUserController;

@end

@interface MyViewController : UIViewController <SetViewDelegate>

@property (nonatomic, strong) UserViewController *userController;
@property (nonatomic, assign) id <MyDelegate> delegate;

@end
