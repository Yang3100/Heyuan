//
//  RegisterViewController.h
//  XinMinClub
//
//  Created by yangkejun on 16/3/18.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol registerDelegate <NSObject>
@optional

- (void)registerToLogin:(UIViewController*)viewController;

@end

@interface RegisterViewController : UIViewController

@property (nonatomic, assign) id <registerDelegate> delegate;

@end
