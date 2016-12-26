//
//  UIView+Draw.m
//  FreeTravel
//
//  Created by Admin on 16/3/4.
//  Copyright © 2016年 Miko. All rights reserved.
//

#import "UIView+Draw.h"

@implementation UIView (Draw)

- (void)roundedRectWithDefaultValue{
    [self roundedRectWithConerRadius:8.0 BorderWidth:1.0 borderColor:[UIColor whiteColor]];
}

- (void)roundedRectWithConerRadius:(CGFloat)cornerRadius BorderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = cornerRadius;
    self.layer.borderWidth = borderWidth;
    self.layer.borderColor = [borderColor CGColor];
}

@end