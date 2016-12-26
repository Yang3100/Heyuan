//
//  DetailsCell2.m
//  XinMinClub
//
//  Created by 杨科军 on 16/4/20.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "DetailsCell2.h"

@interface DetailsCell2()

@property (weak, nonatomic) IBOutlet UILabel *detailsLabel1;
@property (weak, nonatomic) IBOutlet UITextView *detalisTextView2;
@property (weak, nonatomic) IBOutlet UILabel *detailsTime;
@property (weak, nonatomic) IBOutlet UIImageView *detailsImageView;

@end

@implementation DetailsCell2

- (void)setDetailsImageUrl:(NSString *)detailsImageUrl{
    self.detailsImageView.layer.masksToBounds = YES;
    self.detailsImageView.layer.cornerRadius = 25;
}

- (void)setDetails2Text:(NSString *)details2Text{
    self.detailsLabel1.textColor = [UIColor colorWithWhite:0.373 alpha:1.000];
    self.detailsLabel1.text = details2Text;
}

- (void)setDetails2Time:(NSString *)details2Time{
    self.detailsTime.textColor = [UIColor colorWithWhite:0.373 alpha:1.000];
    self.detailsTime.text = details2Time;
}

- (void)setDetails2Title:(NSString *)details2Title{
    self.detalisTextView2.scrollEnabled = NO;
    self.detalisTextView2.editable = NO;
    self.detalisTextView2.textColor = [UIColor colorWithWhite:0.373 alpha:1.000];
    self.detalisTextView2.text = details2Title;
}

@end
