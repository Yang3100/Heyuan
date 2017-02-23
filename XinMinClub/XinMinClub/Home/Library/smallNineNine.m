//
//  smallNineNine.m
//  XinMinClub
//
//  Created by 杨科军 on 2016/11/2.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "smallNineNine.h"
#import "BookViewController.h"

@interface smallNineNine (){
    float Nwidth;
    float Nheight;
    NSArray *typeAr;
    NSString *rushidaoname;
    int touchNum;
}

@property(nonatomic, strong) UIImageView *smallBackImage;
@property(nonatomic, strong) UIButton *backbutton;

@property(nonatomic, readonly) UIViewController *viewController;

@end

@implementation smallNineNine

- (id)initWithSize:(CGRect)frame rushidaoName:(NSString*)name smallNineArray:(NSArray*)array TouchNum:(int)touch{
    if (self==[super initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)]) {
        Nwidth = frame.size.width;
        Nheight = frame.size.height;
        
        touchNum = touch;
        rushidaoname = name;
        [DataModel defaultDataModel].lastrushidaoName = name;
        typeAr = array;
        
        [self addSubview:self.backbutton];
        
        [self addSubview:self.smallBackImage];
        
        [self seNineNine];
    }
    return self;
}

//  获取当前view所处的viewController重写读方法
- (UIViewController *)viewController{
    for (UIView *next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            // 上面if判断是否为UIViewController的子类
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

- (UIImageView*)smallBackImage{
    if (!_smallBackImage) {
        UIImage *im = [UIImage imageNamed:@"xiaojiugongge"];
        _smallBackImage = [[UIImageView alloc] initWithImage:im];
        _smallBackImage.userInteractionEnabled = YES;
        _smallBackImage.frame = CGRectMake(SCREEN_WIDTH-Nwidth, 0, Nwidth, Nheight);
    }
    return _smallBackImage;
}

- (UIButton*)backbutton{
    if (!_backbutton) {
        _backbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backbutton.frame = self.bounds;
        _backbutton.backgroundColor = [UIColor whiteColor];
//        [_backbutton setImage:[UIImage imageNamed:@"maoboli.jpg"] forState:UIControlStateNormal];
        _backbutton.alpha = 0.5;
        [_backbutton addTarget:self action:@selector(butClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backbutton;
}

- (void)seNineNine{
    UIButton *button;
    int k = 0;
    for (int i = 0; i<3; i++) {
        for (int j = 0; j<3; j++) {
            k++;
            button = [UIButton buttonWithType:UIButtonTypeCustom];
            CGFloat w = self.smallBackImage.bounds.size.width/3;
            CGFloat h = self.smallBackImage.bounds.size.height/3;
            CGFloat x = w*j;
            CGFloat y = h*i;
            button.frame = CGRectMake(x, y, w, h);
            button.backgroundColor = [UIColor clearColor];
            button.tag = k;
            [button setTitle:typeAr[k-1] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(butNineClick:) forControlEvents:UIControlEventTouchUpInside];
            if (k-1==touchNum) {
                [button setTitleColor:[UIColor colorWithRed:231.0/255.0 green:178.0/255.0 blue:102.0/255.0 alpha:1.000] forState:UIControlStateNormal];
            }else{
                [button setTitleColor:[UIColor colorWithRed:254.0/255.0 green:240.0/255.0 blue:220.0/255.0 alpha:1.000] forState:UIControlStateNormal];
            }
            [self.smallBackImage addSubview:button];
        }
    }
}

- (IBAction)butNineClick:(UIButton*)sender{
    [DataModel defaultDataModel].kaiguannnn = 0;
    // 请求数据
    [BookViewController shareObject].rushidaoName = rushidaoname;
    [BookViewController shareObject].typeName = typeAr[sender.tag-1];
    [BookViewController shareObject].typeArray = typeAr;
    [BookViewController shareObject].isRemoveArray = YES;
    [[BookViewController shareObject] startGetDataWithType:typeAr[sender.tag-1] touchNum:sender.tag-1];
    [BookViewController shareObject].title = [NSString stringWithFormat:@"%@--%@",rushidaoname,typeAr[sender.tag-1]];
    [self removeFromSuperview];
}

- (IBAction)butClick:(UIButton*)sender{
    [DataModel defaultDataModel].kaiguannnn = 0;
    [self removeFromSuperview];
}

- (void)goBackHideJiuGongGe{
    [DataModel defaultDataModel].kaiguannnn = 0;
    [self removeFromSuperview];
}

@end
