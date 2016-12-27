//
//  MJscroll.h
//  course
//
//  Created by 杨科军 on 2016/11/23.
//  Copyright © 2016年 杨科军. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MJscrollDeledage <NSObject>

-(void)MJscrollImage:(UIView *)bannerPlayer didSelectedIndex:(NSInteger)index;

@end


@interface MJscroll : UIView

@property (strong, nonatomic) NSArray *sourceArray;
@property (strong, nonatomic) NSArray *urlArray;
@property (strong, nonatomic) id<MJscrollDeledage> delegate;

// 初始化一个本地图片播放器
+ (void)initWithSourceArray:(NSArray *)picArray addTarget:(id)controller delegate:(id)delegate withSize:(CGRect)frame;

// 初始化一个网络图片播放器
+ (void)initWithUrlArray:(NSArray *)urlArray addTarget:(UIViewController *)controller delegate:(id)delegate withSize:(CGRect)frame;

//设置图片
-(void)setImage:(NSArray *)sourceList;

@end
