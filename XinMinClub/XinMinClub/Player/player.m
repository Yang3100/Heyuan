//
//  player.m
//  player
//
//  Created by 杨科军 on 2016/12/16.
//  Copyright © 2016年 杨科军. All rights reserved.
//

#import "player.h"

@interface player()<AVAssetResourceLoaderDelegate>

//@property (nonatomic, strong) AVPlayerItem *songItem;
//@property (nonatomic, strong) id timeObserve;
//@property (nonatomic, strong) AVPlayer * player;

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) AVPlayerItem *currentItem;  // 当前播放的item
@property (nonatomic, strong) SUResourceLoader *resourceLoader;

@property (nonatomic, strong) id timeObserve;


@end

@implementation player

+ (instancetype)instancePlayer {
    static player *pla;
    if (!pla) {
        pla = [[super allocWithZone:NULL] init];
    }
    return pla;
}

- (instancetype)init{
    if (self==[super init]) {
        
    }
    return self;
}

- (void)reloadCurrentItem {
    //Item
    if ([self.url.absoluteString hasPrefix:@"http"]) {
        //有缓存播放缓存文件
        NSString * cacheFilePath = [SUFileHandle cacheFileExistsWithURL:self.url];
        if (cacheFilePath) {
            NSURL * url = [NSURL fileURLWithPath:cacheFilePath];
            self.currentItem = [AVPlayerItem playerItemWithURL:url];
            NSLog(@"有缓存，播放缓存文件");
        }else {
            //没有缓存播放网络文件
            self.resourceLoader = [[SUResourceLoader alloc]init];
            self.resourceLoader.delegate = self;
            
            AVURLAsset * asset = [AVURLAsset URLAssetWithURL:[self.url customSchemeURL] options:nil];
            [asset.resourceLoader setDelegate:self.resourceLoader queue:dispatch_get_main_queue()];
            self.currentItem = [AVPlayerItem playerItemWithAsset:asset];
            NSLog(@"无缓存，播放网络文件");
        }
    }else {
        self.currentItem = [AVPlayerItem playerItemWithURL:self.url];
        NSLog(@"播放本地文件");
    }
    //Player
    self.player = [AVPlayer playerWithPlayerItem:self.currentItem];
    //Observer
    [self addObserver];
    
//    //State
//    _state = SUPlayerStateWaiting;
}

- (void)replaceItemWithURL:(NSURL *)url{
    self.url = url;
    [self reloadCurrentItem];
}


- (void)play {
//    if (self.state == SUPlayerStatePaused || self.state == SUPlayerStateWaiting) {
        [self.player play];
//    }
}

- (void)pause {
//    if (self.state == SUPlayerStatePlaying) {
        [self.player pause];
//    }
}

- (void)endLastOperate{
    [self.player pause];
    [self.resourceLoader stopLoading];
    [self removeObserver];
    self.resourceLoader = nil;
    self.currentItem = nil;
}

//- (void)stop {
////    if (self.state == SUPlayerStateStopped) {
////        return;
////    }
//    
//    [self.player pause];
//    [self.resourceLoader stopLoading];
//    [self removeObserver];
//    self.resourceLoader = nil;
//    self.currentItem = nil;
////    self.player = nil;
//    
//    self.songTime = 0.0;
//    self.currentTime = 0.0;
//    self.isPlayComplete = YES;
//    self.cacheValue = 0.0;
////    self.state = SUPlayerStateStopped;
//}


#pragma mark - KVO
- (void)addObserver {
    AVPlayerItem * songItem = self.currentItem;
    //播放完成
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished) name:AVPlayerItemDidPlayToEndTimeNotification object:songItem];
    //播放进度
    __weak typeof(self) weakSelf = self;
    self.timeObserve = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        weakSelf.currentTime = CMTimeGetSeconds(time);  // 获取当前播放时间
        float total = CMTimeGetSeconds(songItem.duration);
        if (!((self.songTime - total) <= 0.0001) || (self.songTime - total) < -0.01) {
            weakSelf.songTime = CMTimeGetSeconds(songItem.duration); // 获取到媒体的总时长
        }
    }];
//    [self.player addObserver:self forKeyPath:@"rate" options:NSKeyValueObservingOptionNew context:nil];
    [songItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    [songItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
//    [songItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
//    [songItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObserver {
    AVPlayerItem * songItem = self.currentItem;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (self.timeObserve) {
        [self.player removeTimeObserver:self.timeObserve];
        self.timeObserve = nil;
    }
    [songItem removeObserver:self forKeyPath:@"status"];
    [songItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
//    [songItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
//    [songItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
//    [self.player removeObserver:self forKeyPath:@"rate"];
    [self.player replaceCurrentItemWithPlayerItem:nil];
}

/**
 *  通过KVO监控播放器状态
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    AVPlayerItem * songItem = object;
    if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        NSArray * array = songItem.loadedTimeRanges;
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue]; //本次缓冲的时间范围
        NSTimeInterval totalBuffer = CMTimeGetSeconds(timeRange.start) + CMTimeGetSeconds(timeRange.duration); //缓冲总长度
        self.cacheValue = totalBuffer/CMTimeGetSeconds(songItem.duration);
        NSLog(@"共缓冲%.2f",totalBuffer);
    }
    
//    if ([keyPath isEqualToString:@"rate"]) {
//        if (self.player.rate == 0.0) {
////            _state = SUPlayerStatePaused;
//            NSLog(@"Paused");
//        }else {
////            _state = SUPlayerStatePlaying;
//            NSLog(@"Playing");
//        }
//    }
    
    if ([keyPath isEqualToString:@"status"]) {
        // 媒体加载
        switch (self.player.status) {
            case AVPlayerStatusFailed:
                NSLog(@"KVO:加载失败,网络或者服务器出现问题");
                break;
            case AVPlayerStatusReadyToPlay:
                NSLog(@"KVO:准备完毕，可以播放");
                //                [_player play];
                break;
            case AVPlayerStatusUnknown:
                NSLog(@"KVO:未知状态");
                break;
        }
    }
    
}

- (void)playbackFinished {
    NSLog(@"播放完成");
    self.isPlayComplete = YES;
//    [self stop];
}

#pragma mark - SULoaderDelegate
- (void)loader:(SUResourceLoader *)loader cacheProgress:(CGFloat)progress {
    self.cacheValue = progress;
}

#pragma mark - Property Set
//- (void)setProgress:(CGFloat)progress {
//    [self willChangeValueForKey:@"progress"];
//    _progress = progress;
//    [self didChangeValueForKey:@"progress"];
//}

//- (void)setState:(SUPlayerState)state {
//    [self willChangeValueForKey:@"cacheValue"];
//    _state = state;
//    [self didChangeValueForKey:@"cacheValue"];
//}

//- (void)setCacheValue:(float)cacheValue{
//    [self willChangeValueForKey:@"cacheValue"];
//    _cacheValue = cacheValue;
//    [self didChangeValueForKey:@"cacheValue"];
//}

//- (void)setCacheProgress:(CGFloat)cacheProgress {
//    [self willChangeValueForKey:@"progress"];
//    _cacheProgress = cacheProgress;
//    [self didChangeValueForKey:@"progress"];
//}

//- (void)setCurrentTime:(float)currentTime{
//    if (currentTime != _currentTime && !isnan(currentTime)) {
//        [self willChangeValueForKey:@"currentTime"];
//        NSLog(@"duration %f",currentTime);
//        _currentTime = currentTime;
//        [self didChangeValueForKey:@"currentTime"];
//    }
//
//}

#pragma mark - CacheFile
- (BOOL)currentItemCacheState {
    if ([self.url.absoluteString hasPrefix:@"http"]) {
        if (self.resourceLoader) {
            return self.resourceLoader.cacheFinished;
        }
        return YES;
    }
    return NO;
}

- (NSString *)currentItemCacheFilePath {
    if (![self currentItemCacheState]) {
        return nil;
    }
    return [NSString stringWithFormat:@"%@/%@", [NSString cacheFolderPath], [NSString fileNameWithURL:self.url]];;
}

+ (BOOL)clearCache {
    [SUFileHandle clearCache];
    return YES;
}



@end
