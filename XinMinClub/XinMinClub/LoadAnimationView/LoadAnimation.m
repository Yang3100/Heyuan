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

#pragma mark 视图布局
- (void)initView{
    backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    [[UIApplication sharedApplication].keyWindow addSubview:backView];
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backTap)];
//    ges.delegate = self;
    [backView addGestureRecognizer:ges];
//    [self gifPlay6];
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
    [SVProgressHUD dismiss];
}

/**   
 *  利用SDWebImageView 库播放gif
 *  Memory-22.6M   
 *  #import "UIImage+GIF.h"   
 */
-(void)gifPlay6 {
    UIImage *image=[UIImage sd_animatedGIFNamed:@"load"];
    gifview = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,image.size.width*1.5, image.size.height*1.5)];
    gifview.center = backView.center;
    gifview.backgroundColor=[UIColor clearColor];
    gifview.image=image;
    UIImageView *avi = [[UIImageView alloc] init];
    avi.frame = CGRectMake(0,0,SCREEN_WIDTH/4, SCREEN_WIDTH/6);
    avi.center = backView.center;
    avi.image = [UIImage imageNamed:@"diban-"];
    
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
//    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD show];
//    [self performSelector:@selector(success) withObject:nil afterDelay:0.6f];
}

- (void)endLoadAnimation{
    [delaySection delay:0.4 task:^{  // 延时1秒执行
        backView.alpha = 0;
        [SVProgressHUD dismiss];
    }];
}
//- (void)success {
//    [SVProgressHUD showSuccessWithStatus:@"Clean Up!"];
//    [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.5f];
//}
//
//- (void)dismiss {
//    [SVProgressHUD dismiss];
//}

#pragma mark SDWeb相关
//清除缓存
- (void)clearTmpPics{
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];//可有可无
}

//- (void)clear_xx{
//    //计算检查缓存大小
//    float tmpSize = [[SDImageCache sharedImageCache] checkTmpSize];
//
//    NSLog(@"%f",tmpSize);
//    self.clearCacheName = tmpSize >= 1 ? [NSString stringWithFormat:@"%.1fM",tmpSize] : [NSString stringWithFormat:@"%.1fK",tmpSize * 1024];
//}

@end
