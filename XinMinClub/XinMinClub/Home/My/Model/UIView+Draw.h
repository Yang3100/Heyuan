//
//  UIView+Draw.h
//  FreeTravel
//
//  Created by Admin on 16/3/4.
//  Copyright © 2016年 Miko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Draw)

- (void)roundedRectWithConerRadius:(CGFloat)cornerRadius BorderWidth: (CGFloat)borderWidth borderColor:(UIColor *)borderColor;

- (void)roundedRectWithDefaultValue;

@end
