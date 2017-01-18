//
//  LoadAnimation.m
//  XinMinClub
//
//  Created by 杨科军 on 2017/1/5.
//  Copyright © 2017年 yangkejun. All rights reserved.
//

#import "LoadAnimation.h"
#import "UIImage+GIF.h"
#import "XinMinClub-Swift.h"

//获取屏幕 宽度、高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface LoadAnimation()<UIGestureRecognizerDelegate>{
    UIView *backView;
    UIImageView *gifview;
}

@end

@implementation LoadAnimation

#pragma mark 单利化播放器
+ (instancetype)defaultDataModel {
    static LoadAnimation *pvc;
    if (!pvc) {
        pvc = [[super allocWithZone:NULL] init];
    }
    return pvc;
}

- (instancetype)init{
    if (self==[super init]) {
        [self initView];
        backView.alpha = 0;
    }
    return self;
}

- (UIViewController *)appRootViewController{
    UIViewController*appRootVC=[UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController*topVC=appRootVC;
    while(topVC.presentedViewController) {
        topVC=topVC.presentedViewController;
    }
    return topVC;
}

#pragma mark 视图布局
- (void)initView{
    backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.3];
    [[self appRootViewController].view addSubview:backView];
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backTap)];
//    ges.delegate = self;
    [backView addGestureRecognizer:ges];
    [self gifPlay6];
}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
//    if ([touch.view isDescendantOfView:gifview]) {
//        return NO;
//    }
//    return YES;
//}

#pragma mark Action
- (void)backTap {
    backView.alpha = 0;
}

/**   
 *  利用SDWebImageView 库播放gif
 *  Memory-22.6M   
 *  #import "UIImage+GIF.h"   
 */
-(void)gifPlay6 {
    UIImage *image=[UIImage sd_animatedGIFNamed:@"load"];
    gifview = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,image.size.width, image.size.height)];
    gifview.center = backView.center;
    gifview.backgroundColor=[UIColor clearColor];
    gifview.image=image;
    UIView *avi = [[UIView alloc] init];
    avi.frame = CGRectMake(0,0,image.size.width/2, image.size.height/2);
    avi.center = backView.center;
    avi.backgroundColor = RGB255_COLOR(238, 224, 160, 1);
    
    [backView addSubview:avi];
    [backView addSubview:gifview];
}

/**
 *  利用UIImageView
 *  把gif图拆成1张1张
 */
- (void)gifPlay7{
    // 播放一系列图片
    UIImage *image1 = [UIImage imageNamed:@"1.tiff"];
    UIImage *image2 = [UIImage imageNamed:@"2.tiff"];
    UIImage *image3 = [UIImage imageNamed:@"3.tiff"];
    UIImage *image4 = [UIImage imageNamed:@"4.tiff"];
    UIImage *image5 = [UIImage imageNamed:@"5.tiff"];
    NSArray *imagesArray = @[image1,image2,image3,image4,image5];
    
    UIImageView *playerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, SCREEN_HEIGHT/2)];
    playerImageView.animationImages = imagesArray;
    playerImageView.animationDuration = [imagesArray count]/3;// 设定所有的图片在多少秒内播放完
    playerImageView.animationRepeatCount = 0; // 不重复播放多少遍，0表示无数遍
    [playerImageView startAnimating]; // 开始播放
    
    [backView addSubview:playerImageView];
}

- (void)startLoadAnimation{
    backView.alpha = 1;
}

- (void)endLoadAnimation{
    [delaySection delay:0.5 task:^{  // 延时1秒执行
        backView.alpha = 0;
    }];
}


@end
