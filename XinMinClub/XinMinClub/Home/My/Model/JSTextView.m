//
//  JSTextView.m
//  XinMinClub
//
//  Created by 赵劲松 on 16/4/26.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "JSTextView.h"

@interface JSTextView ()

@property (nonatomic, strong) UILabel *placeholderLabel;

@end

@implementation JSTextView

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initViews];
        self.myPlaceholderColor = [UIColor lightGrayColor];
        self.myPlaceholder = @"在这添加简介...";
    }
    return self;
}

- (void)initViews {
    
    if (!_placeholderLabel) {
        UILabel *placeholderLabel = [[UILabel alloc]init];//添加一个占位label
        placeholderLabel.backgroundColor= [UIColor clearColor];
        [self addSubview:placeholderLabel];
        self.placeholderLabel= placeholderLabel; //赋值保存
        self.font = [UIFont systemFontOfSize:14];
        self.myPlaceholderColor= [UIColor lightGrayColor]; //设置占位文字默认颜色
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self]; //通知:监听文字的改变
}

- (void)textDidChange {
    self.placeholderLabel.hidden = self.hasText;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 1. 用一个临时变量保存返回值。
    CGRect temp = self.placeholderLabel.frame;
    // 2. 给这个变量赋值。因为变量都是L-Value，可以被赋值
    temp.origin.x = 5;
    temp.origin.y = 8;
    temp.size.width = self.bounds.size.width - temp.origin.x * 2.0;
    
    //根据文字计算高度
    CGSize maxSize =CGSizeMake(temp.size.width,MAXFLOAT);
    temp.size.height= [self.myPlaceholder boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.placeholderLabel.font} context:nil].size.height;
    // 3. 修改frame的值
    self.placeholderLabel.frame = temp;
}

- (void)setMyPlaceholder:(NSString *)myPlaceholder {
    _myPlaceholder = [myPlaceholder copy];
    
    // 设置文字
    self.placeholderLabel.text = myPlaceholder;
    // 重新计算子控件frame
    [self setNeedsLayout];
}

- (void)setMyPlaceholderColor:(UIColor *)myPlaceholderColor {
    
    _myPlaceholderColor = myPlaceholderColor;
    self.placeholderLabel.textColor = myPlaceholderColor;
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    
    self.placeholderLabel.font = font;
    // 重新计算子控件frame
    [self setNeedsLayout];
}

- (void)setText:(NSString *)text {
    [super setText:text];
    
    [self textDidChange];// 调用通知的回调
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    [super setAttributedText:attributedText];
    
    [self textDidChange];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:UITextViewTextDidChangeNotification];
}

@end
