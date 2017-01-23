//
//  DetailsCell4.m
//  XinMinClub
//
//  Created by 杨科军 on 2016/12/22.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "DetailsCell4.h"

@interface DetailsCell4()
    
@property (weak, nonatomic) IBOutlet UIImageView *details3ImageView;
@property (weak, nonatomic) IBOutlet UILabel *details3Label;

@end

@implementation DetailsCell4

- (void)setImageUrl:(NSString *)imageUrl{
    self.details3ImageView.layer.masksToBounds = YES;
    self.details3ImageView.layer.cornerRadius = self.details3ImageView.frame.size.height/2;
    [self.details3ImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:cachePicture_100x100];
}
    
- (void)setLibraryName:(NSString *)libraryName{
    NSString *s = [NSString stringWithFormat:@": %@",libraryName];
    self.details3Label.text = s;
}

@end
