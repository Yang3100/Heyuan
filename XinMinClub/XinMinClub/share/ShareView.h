//
//  ShareView.h
//  XinMinClub
//
//  Created by 杨科军 on 2016/12/23.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import <UIKit/UIKit.h>

// 选择分享内容类型
typedef NS_ENUM(NSInteger, SelectedShareContent) {
    ShareText=0,  // 文字  默认从0开始
    ShareImage, // 图片
    ShareWeb,   // 网页
    ShareMusic, // 音乐
    ShareVideo  // 视频
};

@interface ShareView : UIView

// 分享内容
@property(nonatomic, assign) SelectedShareContent setShareContent;

@property(nonatomic,strong) NSString *text;       // 文字
@property(nonatomic,strong) NSString *imageUrl;   // 图片
@property(nonatomic,strong) NSString *thumbImage; // 缩略图
@property(nonatomic,strong) NSString *title;      // 标题
@property(nonatomic,strong) NSString *describe;   // 描述
@property(nonatomic,strong) NSString *webUrl;     // 网页链接
@property(nonatomic,strong) NSString *musicUrl;   // 音乐链接
@property(nonatomic,strong) NSString *videoUrl;   // 视频链接

@end
