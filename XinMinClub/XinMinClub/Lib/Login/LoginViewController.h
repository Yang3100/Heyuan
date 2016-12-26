//
//  LoginViewController.h
//  FreeTravel
//
//  Created by Admin on 16/3/4.
//  Copyright © 2016年 Miko. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LogSuccessfully <NSObject>
-(void)accountState:(NSInteger)state;
@end

@protocol LoginDelegate <NSObject>

@optional
- (void)loginRegister;
- (void)loginForget;

@end

@interface LoginViewController : UIViewController

@property (nonatomic, strong) UIButton *cancel;
@property (nonatomic, assign) id <LoginDelegate> delegate;
@property (nonatomic, assign) id <LogSuccessfully>delegateFully;
-(void)JudgeAccountSuccessfully:(NSString*)account Password:(NSString*)password;

@end





