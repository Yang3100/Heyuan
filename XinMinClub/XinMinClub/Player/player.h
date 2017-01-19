//
//  player.h
//  player
//
//  Created by 杨科军 on 2016/12/16.
//  Copyright © 2016年 杨科军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "SUResourceLoader.h"

typedef NS_ENUM(NSInteger, SUPlayerState) {
    SUPlayerStateWaiting,
    SUPlayerStatePlaying,
    SUPlayerStatePaused,
    SUPlayerStateStopped,
    SUPlayerStateBuffering,
    SUPlayerStateError
};

@interface player : NSObject<SULoaderDelegate>

//@property (nonatomic, assign) SUPlayerState state;

@property (nonatomic, strong) AVPlayer *player; /**< 播放器 */
@property (nonatomic, assign) BOOL isPlayComplete; /**< 播放结束 */
@property (nonatomic, assign) float currentTime; /**< 当前播放时间 */
@property (nonatomic, assign) float songTime; /**< 歌曲总时间 */
@property (nonatomic, assign) float cacheValue; //缓存进度


+ (instancetype)instancePlayer;

/**
 *  播放下一首歌曲，url：歌曲的网络地址或者本地地址
 *  逻辑：stop -> replace -> play
 */
- (void)replaceItemWithURL:(NSURL *)url;

/**
 *  结束上一次操作
 */
- (void)endLastOperate;

/**
 *  播放
 */
- (void)play;

/**
 *  暂停
 */
- (void)pause;

/**
 *  当前歌曲缓存情况 YES：已缓存  NO：未缓存（seek过的歌曲都不会缓存）
 */
- (BOOL)currentItemCacheState;

/**
 *  当前歌曲缓存文件完整路径
 */
- (NSString *)currentItemCacheFilePath;

/**
 *  清除缓存音乐
 */
+ (BOOL)clearCache;

@end
