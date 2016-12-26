//
//  SongCollectionCell.m
//  KJ5sing2
//
//  Created by yangkejun on 16/3/12.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "LibraryCollectionCell.h"

@interface LibraryCollectionCell(){
    UIImage *setUpImage;
}

@property(nonatomic, copy) UIImageView *libraryImageView;
@property (nonatomic, strong) UILabel *backLabel;
@property (nonatomic, strong) UIImageView *backView;

@end

@implementation LibraryCollectionCell

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        setUpImage = [UIImage imageNamed:@"12345.jpg"];
        
        [self addSubview:self.backView];
        [self addSubview:self.libraryImageView];
        [self.libraryImageView addSubview:self.backLabel];
    }
    return self;
}

#pragma mark Subviews
- (UIImageView *)backView{
    if (!_backView) {
        CGFloat x = 2;
        CGFloat y = 2;
        CGFloat w = self.frame.size.width;
        CGFloat h = self.frame.size.height;
        UIImageView *view = [[UIImageView alloc]init];
        view.backgroundColor = [UIColor colorWithWhite:0.707 alpha:0.500];
        view.frame = CGRectMake(x,y,w,h);
        view.image = setUpImage;
        _backView = view;
    }
    return _backView;
}

- (UIImageView *)libraryImageView{
    if (_libraryImageView==nil) {
        _libraryImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
//        _libraryImageView.image = setUpImage;
        _libraryImageView.layer.masksToBounds = YES;
        _libraryImageView.layer.cornerRadius =2.0;
        _libraryImageView.layer.borderWidth = 0.1;
    }
    return _libraryImageView;
}

- (UILabel *)backLabel{
    if (!_backLabel) {
        _backLabel = [[UILabel alloc] init];
        _backLabel.frame = CGRectMake(0, self.libraryImageView.frame.size.height- 15, self.libraryImageView.frame.size.width, 15);
        _backLabel.backgroundColor = [UIColor colorWithWhite:0.448 alpha:0.500]; // 背景颜色
        _backLabel.text = @"☊ 8693"; // 显示内容
        _backLabel.textColor = [UIColor whiteColor]; // 文字颜色
        _backLabel.textAlignment = NSTextAlignmentRight;
        _backLabel.lineBreakMode = NSLineBreakByTruncatingTail; // 显示不下的时候尾部用...表示
        _backLabel.font = [UIFont systemFontOfSize:12.0f]; // 字体大小
        _backLabel.adjustsFontSizeToFitWidth = YES; //设置字体大小适应label宽度
    }
    return _backLabel;
}


#pragma mark 显示数据 重写属性的写方法
- (void)setLibraryImageUrl:(NSString *)libraryImageUrl{
    NSString *string = [IP stringByAppendingString:libraryImageUrl];
    NSURL *url = [NSURL URLWithString:string];
    
    [self.libraryImageView sd_setImageWithURL:url placeholderImage:cachePicture];
}

- (void)setReadtotal:(NSString *)readtotal{
    NSString *s = [NSString stringWithFormat:@"☊ %@",readtotal];
    self.backLabel.text = s;
}

@end
