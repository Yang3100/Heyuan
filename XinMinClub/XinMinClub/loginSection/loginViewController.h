//
//  loginView.h
//  XinMinClub
//
//  Created by 杨科军 on 2016/12/24.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol loginDelegate <NSObject>
@optional

- (void)loginToRegister:(UIViewController*)viewController;
- (void)loginToForget:(UIViewController*)viewController;

@end

@interface loginViewController : UIViewController

@property (nonatomic, assign) id <loginDelegate> delegate;

@end
