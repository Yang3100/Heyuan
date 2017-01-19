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

@property (nonatomic, assign) SUPlayerState state;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) CGFloat duration;
@property (nonatomic, assign) CGFloat cacheProgress;

@property (nonatomic, strong) AVPlayer *player; /**< 播放器 */
@property (nonatomic, assign) float currentTime; /**< 当前播放时间 */
@property (nonatomic, assign) BOOL isPlayComplete; /**< 播放结束 */

@property (nonatomic, assign) float songTime; /**< 歌曲总时间 */
@property (nonatomic, assign) float cacheValue; //缓存进度

- (void)removeObserver;
- (void)addObserver;
/**
 *  初始化播放器
 */
- (void)setNewPlayerWithUrl:(NSString*)url;

- (void)setNewPlayerWithLocalUrl:(NSString *)url;

///**
// *  播放音乐
// */
//- (void)play;
//
///**
// *  暂停播放
// */
//- (void)pause;

+ (instancetype)instancePlayer;



/**
 *  初始化方法，url：歌曲的网络地址或者本地地址
 */
- (instancetype)initWithURL:(NSURL *)url;

/**
 *  播放下一首歌曲，url：歌曲的网络地址或者本地地址
 *  逻辑：stop -> replace -> play
 */
- (void)replaceItemWithURL:(NSURL *)url;

/**
 *  播放
 */
- (void)play;

/**
 *  暂停
 */
- (void)pause;

/**
 *  停止
 */
- (void)stop;

/**
 *  跳到某个时间进度
 */
- (void)seekToTime:(CGFloat)seconds;

/**
 *  当前歌曲缓存情况 YES：已缓存  NO：未缓存（seek过的歌曲都不会缓存）
 */
- (BOOL)currentItemCacheState;

/**
 *  当前歌曲缓存文件完整路径
 */
- (NSString *)currentItemCacheFilePath;

/**
 *  清除缓存
 */
+ (BOOL)clearCache;

@end
