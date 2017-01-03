//
//  player.h
//  player
//
//  Created by 杨科军 on 2016/12/16.
//  Copyright © 2016年 杨科军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface player : NSObject

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

/**
 *  播放音乐
 */
- (void)play;

/**
 *  暂停播放
 */
- (void)pause;

+ (instancetype)instancePlayer;

@end
