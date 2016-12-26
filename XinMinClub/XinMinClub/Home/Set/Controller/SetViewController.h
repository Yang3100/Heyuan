//
//  SetViewController.h
//  XinMinClub
//
//  Created by Jason_zzzz on 16/3/24.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SetViewDelegate <NSObject>

@optional
- (void)pushUserDataView;

@end

@interface SetViewController : UIViewController

@property (nonatomic, assign) id <SetViewDelegate> delegate;

@end
