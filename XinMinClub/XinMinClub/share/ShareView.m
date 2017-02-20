//
//  ShareView.m
//  XinMinClub
//
//  Created by 杨科军 on 2016/12/23.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "ShareView.h"

//获取屏幕 宽度、高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface ShareView(){
    UIButton *backBut;
    UIView *whiteView;
}

// 选择分享的地方
typedef NS_ENUM(NSInteger, ShareToWhere) {
    QQ=0,
    QZone,
    WeChat,
    FriendsCircle
};

@property(nonatomic,assign) ShareToWhere where;

@end

@implementation ShareView

- (instancetype)init{
    if (self==[super init]) {
        [self initView];
        NSArray *array = whiteView.subviews;
        if (!DATA_MODEL.wxInstalled&&DATA_MODEL.qqInstalled) {  // 没微信有QQ
            [array[2] removeFromSuperview];
            [array[3] removeFromSuperview];
            UIButton *but1 = (UIButton*)array[0];
            UIButton *but2 = (UIButton*)array[1];
            [UIView animateWithDuration:0.45 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                whiteView.frame = CGRectMake(0, SCREEN_HEIGHT - SCREEN_HEIGHT/6, SCREEN_WIDTH, SCREEN_HEIGHT/6);
            } completion:nil];
            but1.frame = CGRectMake(0, 0, SCREEN_WIDTH, whiteView.frame.size.height/2-5);
            but2.frame = CGRectMake(0, whiteView.frame.size.height/2, SCREEN_WIDTH, whiteView.frame.size.height/2-5);
        }
        else if (!DATA_MODEL.qqInstalled&&DATA_MODEL.wxInstalled) {  // 没QQ有微信
            [array[0] removeFromSuperview];
            [array[1] removeFromSuperview];
            UIButton *but1 = (UIButton*)array[2];
            UIButton *but2 = (UIButton*)array[3];
            [UIView animateWithDuration:0.45 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                whiteView.frame = CGRectMake(0, SCREEN_HEIGHT - SCREEN_HEIGHT/6, SCREEN_WIDTH, SCREEN_HEIGHT/6);
            } completion:nil];
            but1.frame = CGRectMake(0, 0, SCREEN_WIDTH, whiteView.frame.size.height/2-5);
            but2.frame = CGRectMake(0, whiteView.frame.size.height/2, SCREEN_WIDTH, whiteView.frame.size.height/2-5);
        }
        else if (!DATA_MODEL.wxInstalled&&!DATA_MODEL.qqInstalled) {  // 没微信也没QQ
            [backBut removeFromSuperview];
            [whiteView removeFromSuperview];
        }else if (DATA_MODEL.wxInstalled&&DATA_MODEL.qqInstalled) {
            [UIView animateWithDuration:0.45 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                whiteView.frame = CGRectMake(0, SCREEN_HEIGHT - SCREEN_HEIGHT/3, SCREEN_WIDTH, SCREEN_HEIGHT/3);
            } completion:nil];
        }
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
    backBut = [UIButton buttonWithType:UIButtonTypeCustom];
    backBut.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    backBut.backgroundColor = [UIColor blackColor];
//    [backBut setImage:[UIImage imageNamed:@"sharebackground"] forState:UIControlStateNormal];
    backBut.alpha = 0;
    [backBut addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [[self appRootViewController].view addSubview:backBut];
    // 动画效果
    [UIView animateWithDuration:0.45 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        backBut.alpha = 0.3;
    } completion:nil];
    
    whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT/3)];
    whiteView.backgroundColor = [UIColor whiteColor];
    
    NSArray *nameArray = @[[UIImage imageNamed:@"QQ"],[UIImage imageNamed:@"QZone"],[UIImage imageNamed:@"WeChat"],[UIImage imageNamed:@"朋友圈"]];
    for (int a=0; a<4; a++) {
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.frame = CGRectMake(0, whiteView.frame.size.height/4*a, SCREEN_WIDTH, whiteView.frame.size.height/4-5);
        but.tag = a;
        [but setImage:nameArray[a] forState:UIControlStateNormal];
        [but addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [whiteView addSubview:but];
    }
    
    [[self appRootViewController].view addSubview:whiteView];
}

#pragma mark 点击分享事件
- (void)backButtonAction{
    [self removeView];
}

- (void)removeView{ // 移除视图
    [UIView animateWithDuration:0.45 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        backBut.alpha = 0;
    } completion:^(BOOL finished) {
        [backBut removeFromSuperview];
    }];

    [UIView animateWithDuration:0.45 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        whiteView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT/3);
    } completion:^(BOOL finished) {
        [whiteView removeFromSuperview];
    }];
}

- (IBAction)buttonAction:(UIButton*)sender{
    switch (sender.tag) {
        case 0:
            self.where = QQ;
            break;
        case 1:
            self.where = QZone;
            break;
        case 2:
            self.where = WeChat;
            break;
        case 3:
            self.where = FriendsCircle;
            break;
    }
    [self share];
}

- (void)share{
    switch (_setShareContent) {
        case ShareText:
            [self kj_shareTextTowhere:_where];
            break;
        case ShareImage:
            [self kj_shareImageTowhere:_where];
            break;
        case ShareWeb:
            [self kj_shareWebTowhere:_where];
            break;
        case ShareMusic:
            [self kj_shareMusicTowhere:_where];
            break;
        case ShareVideo:
            [self kj_shareVideoTowhere:_where];
            break;
    }
}

#pragma mark 分享实现代码
//分享文字
- (void)kj_shareTextTowhere:(ShareToWhere)where{
    // 微信
    if (where==WeChat||where==FriendsCircle) {
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.text = _text;
        req.bText = YES;
        if (where==WeChat) {
            req.scene = WXSceneSession;//会话(WXSceneSession)或者朋友圈(WXSceneTimeline)
        }else{
            req.scene = WXSceneTimeline;//会话(WXSceneSession)或者朋友圈(WXSceneTimeline)
        }
        [WXApi sendReq:req];
    }else if (where==QQ||where==QZone){ // QQ
        QQApiTextObject *txtObj = [QQApiTextObject objectWithText:_text];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:txtObj];
        if (where==QZone) {
            NSLog(@"QZone不支持分享纯文字");
        }else{
            //将内容分享到qq
            [QQApiInterface sendReq:req];
        }
    }
    
}

//分享图片
- (void)kj_shareImageTowhere:(ShareToWhere)where{
    NSURL *urlString = [NSURL URLWithString:self.thumbImage];
    NSData *data = [NSData dataWithContentsOfURL:urlString];
    NSData *daa = [self compressOriginalImage:[UIImage imageWithData:data] toMaxDataSizeKBytes:31.0];
    // 微信
    if (where==WeChat||where==FriendsCircle) {
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = self.title;  // 标题
        [message setThumbImage:[UIImage imageWithData:daa]];  // 缩略图
        WXImageObject *imageObject = [[WXImageObject alloc] init];
        imageObject.imageData = data;
        message.mediaObject = imageObject;
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        if (where==WeChat) {
            req.scene = WXSceneSession;//会话(WXSceneSession)或者朋友圈(WXSceneTimeline)
        }else{
            req.scene = WXSceneTimeline;//会话(WXSceneSession)或者朋友圈(WXSceneTimeline)
        }
        [WXApi sendReq:req];
    }else if (where==QQ||where==QZone){ // QQ
        //分享内容
        QQApiWebImageObject *imageObj = [QQApiWebImageObject objectWithPreviewImageURL:urlString title:self.title description:self.describe];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:imageObj];
        if (where==QQ) {
            // 分享到QQ
            [QQApiInterface sendReq:req];
        }else {
            // 将内容分享到qzone
            [QQApiInterface SendReqToQZone:req];
        }
    }
    
}

//分享网页
- (void)kj_shareWebTowhere:(ShareToWhere)where{
    NSURL *urlString = [NSURL URLWithString:self.thumbImage];
    NSData *data = [NSData dataWithContentsOfURL:urlString];
    NSData *daa = [self compressOriginalImage:[UIImage imageWithData:data] toMaxDataSizeKBytes:31.0];
    // 微信
    if (where==WeChat||where==FriendsCircle) {
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = self.title;  // 标题
        message.description = self.describe; // 描述
        [message setThumbImage:[UIImage imageWithData:daa]];  // 缩略图
        WXWebpageObject *webObject = [WXWebpageObject object];
        webObject.webpageUrl = self.webUrl;  // 网页
        message.mediaObject = webObject;
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        if (where==WeChat) {
            req.scene = WXSceneSession;//会话(WXSceneSession)或者朋友圈(WXSceneTimeline)
        }else{
            req.scene = WXSceneTimeline;//会话(WXSceneSession)或者朋友圈(WXSceneTimeline)
        }
        [WXApi sendReq:req];
    }else if (where==QQ||where==QZone){ // QQ
        //分享内容
        QQApiNewsObject *newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:self.webUrl] title:self.title description:self.describe previewImageData:daa];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
        if (where==QQ) {
            // 分享到QQ
            [QQApiInterface sendReq:req];
        }else {
            // 将内容分享到qzone
            [QQApiInterface SendReqToQZone:req];
        }
    }
}

//分享音乐
- (void)kj_shareMusicTowhere:(ShareToWhere)where{
    NSURL *urlString = [NSURL URLWithString:self.thumbImage];
    NSData *data = [NSData dataWithContentsOfURL:urlString];
    NSData *daa = [self compressOriginalImage:[UIImage imageWithData:data] toMaxDataSizeKBytes:3];
    // 微信
    if (where==WeChat||where==FriendsCircle) {
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = _title;
        [message setThumbImage:[UIImage imageWithData:daa]]; // 缩略图
        message.description = self.describe; // 描述
        WXMusicObject *music = [WXMusicObject object];
        music.musicUrl = self.musicUrl;
        music.musicLowBandUrl = music.musicUrl;  // 网页音乐
        music.musicDataUrl = self.musicUrl;
        music.musicLowBandDataUrl = music.musicDataUrl;  // 音乐lowband数据url地址
        message.mediaObject = music;
        
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        if (where==WeChat) {
            req.scene = WXSceneSession;//会话(WXSceneSession)或者朋友圈(WXSceneTimeline)
        }else{
            req.scene = WXSceneTimeline;//会话(WXSceneSession)或者朋友圈(WXSceneTimeline)
        }
        [WXApi sendReq:req];
    }else if (where==QQ||where==QZone){ // QQ
        //分享内容
        QQApiAudioObject *musicObj = [QQApiAudioObject objectWithURL:[NSURL URLWithString:self.musicUrl] title:_title description:_describe previewImageData:daa];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:musicObj];
        if (where==QQ) {
            // 分享到QQ
            [QQApiInterface sendReq:req];
        }else {
            // 将内容分享到qzone
            [QQApiInterface SendReqToQZone:req];
        }
    }
}

//分享视频
- (void)kj_shareVideoTowhere:(ShareToWhere)where{
    NSURL *urlString = [NSURL URLWithString:self.thumbImage];
    NSData *data = [NSData dataWithContentsOfURL:urlString];
    NSData *daa = [self compressOriginalImage:[UIImage imageWithData:data] toMaxDataSizeKBytes:31.0];
    // 微信
    if (where==WeChat||where==FriendsCircle) {
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = _title;
        [message setThumbImage:[UIImage imageWithData:daa]]; // 缩略图
        message.description = self.describe; // 描述
        WXVideoObject *video = [WXVideoObject object];
        video.videoUrl = self.videoUrl;
        video.videoLowBandUrl = video.videoUrl;  // 低分辨率的视频Url
        message.mediaObject = video;
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        if (where==WeChat) {
            req.scene = WXSceneSession;//会话(WXSceneSession)或者朋友圈(WXSceneTimeline)
        }else{
            req.scene = WXSceneTimeline;//会话(WXSceneSession)或者朋友圈(WXSceneTimeline)
        }
        [WXApi sendReq:req];
    }else if (where==QQ||where==QZone){ // QQ
        //分享内容
        QQApiVideoObject *videoObj = [QQApiVideoObject objectWithURL:[NSURL URLWithString:self.videoUrl] title:_title description:self.describe previewImageData:daa];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:videoObj];
        if (where==QQ) {
            // 分享到QQ
            [QQApiInterface sendReq:req];
        }else {
            // 将内容分享到qzone
            [QQApiInterface SendReqToQZone:req];
        }
    }
}

/**
 *  压缩图片到指定尺寸大小
 *
 *  @param image 原始图片
 *  @param size  目标大小
 *
 *  @return 生成图片
 */
- (UIImage *)compressOriginalImage:(UIImage *)image toSize:(CGSize)size{
    UIImage * resultImage = image;
    UIGraphicsBeginImageContext(size);
    [resultImage drawInRect:CGRectMake(00, 0, size.width, size.height)];
    UIGraphicsEndImageContext();
    return image;
}

/**
 *  压缩图片到指定文件大小
 *
 *  @param image 目标图片
 *  @param size  目标大小（最大值）
 *
 *  @return 返回的图片文件
 */
- (NSData *)compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size{
    NSData * data = UIImageJPEGRepresentation(image, 1.0);
    CGFloat dataKBytes = data.length/1000.0;
    CGFloat maxQuality = 0.9f;
    CGFloat lastData = dataKBytes;
    while (dataKBytes > size && maxQuality > 0.01f) {
        maxQuality = maxQuality - 0.01f;
        data = UIImageJPEGRepresentation(image, maxQuality);
        dataKBytes = data.length / 1000.0;
        if (lastData == dataKBytes) {
            break;
        }else{
            lastData = dataKBytes;
        }
    }
    return data;
}

@end

