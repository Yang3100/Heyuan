//
//  player.m
//  player
//
//  Created by 杨科军 on 2016/12/16.
//  Copyright © 2016年 杨科军. All rights reserved.
//

#import "player.h"

@interface player()

@property (nonatomic, strong) AVPlayerItem *songItem;
@property (nonatomic, strong) id timeObserve;

@end

@implementation player

/**
 *  初始化播放器
 */
- (void)setNewPlayerWithUrl:(NSString*)url {
    NSURL *urla = [NSURL URLWithString:url];
    self.songItem = [AVPlayerItem playerItemWithURL:urla];
    self.player = [AVPlayer playerWithPlayerItem:_songItem];
}

/**
 *  添加观察者
 */
- (void)addObserver {
    // 后台执行：
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 监听媒体资源的状态
        [_songItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        // 监听媒体资源缓冲情况
        [_songItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
        __weak typeof(self) weakSelf = self;
        // 监听播放进度
        self.timeObserve = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
            CGFloat current = CMTimeGetSeconds(time);
            weakSelf.currentTime = current;
        }];
        // 监听播放是否完成
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerFinish:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    });
}

/**
 *  释放,移除观察者
 */
- (void)removeObserver {
    // 释放观察播放器的状态
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [_player removeTimeObserver:self.timeObserve];
    // 释放监听媒体资源的状态
    [_songItem removeObserver:self forKeyPath:@"status" context:nil];
    // 释放监听媒体资源缓冲情况
    [_songItem removeObserver:self forKeyPath:@"loadedTimeRanges" context:nil];
}

/**
 *  KVO监听方法
 *
 *  keyPath
 *  object
 *  change
 *  context
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    AVPlayerItem *songItem = object;
    if ([keyPath isEqualToString:@"status"]) {
        // 媒体加载
        switch (self.player.status) {
            case AVPlayerStatusFailed:
                NSLog(@"KVO:加载失败,网络或者服务器出现问题");
                break;
            case AVPlayerStatusReadyToPlay:
                NSLog(@"KVO:准备完毕，可以播放");
                break;
            case AVPlayerStatusUnknown:
                NSLog(@"KVO:未知状态");
                break;
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        self.songTime = CMTimeGetSeconds(songItem.duration); // 获取到媒体的总时长
        // 媒体缓冲
        NSArray *array=songItem.loadedTimeRanges;
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];//本次缓冲时间范围
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        NSTimeInterval totalBuffer = startSeconds + durationSeconds;//缓冲总长度
        NSLog(@"共缓冲：%.2f, %lf",totalBuffer, CMTimeGetSeconds(songItem.duration));
        _cacheValue = totalBuffer/CMTimeGetSeconds(songItem.duration);
    }
}

/**
 *  监听播放器播放完成
 *
 *  sender
 */
- (void)playerFinish:(NSNotification *)sender {
    NSLog(@"播放完成");
//    [self removeObserver];
    self.isPlayComplete = YES;
}

#pragma mark - 播放器操作
/**
 *  播放音乐
 */
- (void)play {
    [self.player play];
}

/**
 *  暂停播放
 */
- (void)pause {
    [self.player pause];
}

@end
