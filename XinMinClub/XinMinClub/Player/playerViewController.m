//
//  playerViewController.m
//  player
//
//  Created by 杨科军 on 2016/12/16.
//  Copyright © 2016年 杨科军. All rights reserved.
//

#import "playerViewController.h"
#import "player.h"
#import "lyricView.h"

#import <MediaPlayer/MPNowPlayingInfoCenter.h>
#import <MediaPlayer/MPMediaItem.h>

#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height) // 屏幕高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width) // 屏幕宽度
#define X ([UIScreen mainScreen].bounds.size.width/16) // 宽度

@interface playerViewController () <UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate> {
    player *kj_player; /**< 播放器 */
    bool isPlay;
    NSDictionary *jsonDict;
    int total; // 总歌曲数
    NSMutableArray *lrcArry;
    NSMutableArray *timeArry;
    int currentLyricNum; // 当前歌词位置
}

//@property (nonatomic, strong) player *player; /**< 播放器 */
@property (nonatomic, strong) CABasicAnimation *rotationAnimation; /**< 歌手图片旋转动画 */
@property (nonatomic, assign) CGFloat songTimes; /**< 歌曲总时间 */

// 界面布局
@property (nonatomic, strong) UILabel *songTimeLabel; // 显示歌曲时间
@property (nonatomic, strong) UILabel *currentTime; // 显示当前时间
@property (nonatomic, strong) UIImageView *autorImageView; /**< 歌手图片 */
@property(nonatomic, copy) UIImageView *backImageView; /**< 背景图片 */
@property(nonatomic, strong) UIView *backView; /**< 最下面的半黑色背景 */
@property(nonatomic, strong) UIImageView *authorImageView; /**< 作者头像 */
@property(nonatomic, strong) UILabel *authorNameLabel; /**< 作者名字 */
@property(nonatomic, copy) UIProgressView *pro; /**< 进度条背景 */
@property(nonatomic, copy) UISlider *progress; /**< 进度条 */
@property(nonatomic, copy) UIButton *upButton; /**< 上一首 */
@property(nonatomic, copy) UIButton *playButton; /**< 播放按钮 */
@property(nonatomic, copy) UIButton *nextButton; /**< 下一首 */
@property(nonatomic, copy) UIButton *likeButton; /**< 喜欢 */
@property(nonatomic, copy) UIButton *roundButton; /**< 循环 */
@property(nonatomic, copy) UIButton *downloadButton; /**< 下载 */
@property(nonatomic, copy) UIButton *shareButton; /**< 分享 */
@property(nonatomic, copy) UIButton *menuButton; /**< 菜单 */

@property(nonatomic, copy) lyricView *lyricTableView; /**< 歌词 */

@property(nonatomic, copy) UIView *menuBack;
@property(nonatomic, copy) UITableView *menuTable;

@end

@implementation playerViewController

#pragma mark 单利化播放器
+ (instancetype)defaultDataModel {
    static playerViewController *pvc;
    if (!pvc) {
        pvc = [[super allocWithZone:NULL] init];
    }
    return pvc;
}

- (instancetype)init{
    if (self==[super init]) {
        kj_player = [[player alloc] init];
        kj_player.isPlayComplete = YES;
        currentLyricNum = 0;
    }
    return self;
}
#pragma mark 获取到数据json
- (void)getJson:(NSDictionary *)json{
    jsonDict = json;
    NSNumber *num = [[jsonDict valueForKey:@"RET"] valueForKey:@"Record_Count"];
    total = num.intValue-1;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // 播放准备
    [self startPlayBefore];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.500]];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    
    [self.navigationController.navigationBar lt_reset];
//    [kj_player removeObserver]; // 移除观察者
//    // 移除三个KVO观察播放属性
//    [kj_player removeObserver:self forKeyPath:@"songTime"];
//    [kj_player removeObserver:self forKeyPath:@"currentTime"];
//    [kj_player removeObserver:self forKeyPath:@"isPlayComplete"];
}

#pragma mark 界面布局
- (void)initView{
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.backImageView];
    [self.view addSubview:self.lyricTableView];
    [self.view addSubview:self.backView];
    [self.view addSubview:self.authorImageView];
    [self.view addSubview:self.authorNameLabel];
    [self.view addSubview:self.likeButton];
    [self.view addSubview:self.downloadButton];
    [self.view addSubview:self.shareButton];
    [self.view addSubview:self.currentTime];
    [self.view addSubview:self.pro];
    [self.view addSubview:self.progress];
    [self.view addSubview:self.songTimeLabel];
    [self.view addSubview:self.roundButton];
    [self.view addSubview:self.upButton];
    [self.view addSubview:self.playButton];
    [self.view addSubview:self.nextButton];
    [self.view addSubview:self.menuButton];
    
    [self.view addSubview:self.menuBack];
    [_menuBack addSubview:self.menuTable];
}

- (lyricView*)lyricTableView{
    if (!_lyricTableView) {
        _lyricTableView = [[lyricView alloc] init];
//        _lyricTableView.frame = CGRectMake(-30, 150, SCREEN_HEIGHT-(6*X-X/2)-65-50, SCREEN_WIDTH-50);
        _lyricTableView.frame = CGRectMake(30, 120, SCREEN_WIDTH-60, SCREEN_WIDTH-50);
//        _lyricTableView.backgroundColor = [UIColor grayColor];
        [_lyricTableView initView];
//        _lyricTableView.transform=CGAffineTransformMakeRotation(M_PI/2);
    }
    return _lyricTableView;
}

- (UIView *)backView{
    if (!_backView) {
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.560];
        view.frame = CGRectMake(0,SCREEN_HEIGHT-6*X+X/2,SCREEN_WIDTH,6*X-X/2);
        _backView = view;
    }
    return _backView;
}

- (UIImageView *)backImageView{
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        UIImage *image  = [UIImage imageNamed:@"001_0000_7675119_085617932000_2"];
        _backImageView.image = image;
    }
    return _backImageView;
}
- (UIImageView *)authorImageView{
    if (!_authorImageView) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.frame = CGRectMake(X/2, self.shareButton.frame.origin.y-2*X+X/3, 3*X, 3*X);
        
        imageView.image = [UIImage imageNamed:@"19"];
        
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.masksToBounds = YES;
        imageView.layer.borderWidth = 2;
        imageView.layer.cornerRadius = (3*X)/2;
        imageView.layer.borderColor = [[UIColor whiteColor] CGColor];
        _authorImageView = imageView;
        
        // 歌手图片动画效果
        _rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        _rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI * 2];
        _rotationAnimation.duration = 20;
        _rotationAnimation.cumulative = YES;
        _rotationAnimation.repeatCount = CGFLOAT_MAX; // 设置旋转次数
    }
    return _authorImageView;
}
- (UILabel *)authorNameLabel{
    if (!_authorNameLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(4*X, self.shareButton.frame.origin.y, 6*X, X);
        label.text = @"和源"; // 显示内容
        label.textColor = [UIColor whiteColor]; // 文字颜色
        _authorNameLabel = label;
    }
    return _authorNameLabel;
}

- (UIButton *)shareButton{
    if (!_shareButton) {
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _shareButton.frame = CGRectMake(SCREEN_WIDTH-X-X/2, self.progress.frame.origin.y-2*X+X/3, X, X);
        UIImage *image = [[UIImage imageNamed:@"001_0000s_0000_share"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [_shareButton setImage:image forState:UIControlStateNormal];
        [_shareButton addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareButton;
}
- (UIButton *)downloadButton{
    if (_downloadButton == nil) {
        _downloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _downloadButton.frame = CGRectMake(SCREEN_WIDTH-3*X-X/2, self.shareButton.frame.origin.y, X, X);
        UIImage *image = [[UIImage imageNamed:@"001_0000s_0001_Player_download"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [_downloadButton setImage:image forState:UIControlStateNormal];
        [_downloadButton addTarget:self action:@selector(download:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _downloadButton;
}
- (UIButton *)likeButton{
    if (_likeButton == nil) {
        _likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _likeButton.frame = CGRectMake(SCREEN_WIDTH-5*X-X/2, self.shareButton.frame.origin.y, X, X);
        
        UIImage *image = [[UIImage imageNamed:@"001_0000s_0003_102"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        //        UIImage *image2 = [[UIImage imageNamed:@"001_0000s_0002_102-副本"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        //        // 是否添加到收藏(喜欢)里面
        //        if ([[UserDataModel defaultDataModel].userLikeBookID containsObject:_kj_IDArray[SongTags]]) {
        //            [_likeButton setImage:image2 forState:UIControlStateNormal];
        //            likeButton = 1;
        //        }
        //        else{
        [_likeButton setImage:image forState:UIControlStateNormal];
        //            likeButton = 0;
        //        }
        [_likeButton addTarget:self action:@selector(like:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _likeButton;
}

- (UISlider *)progress{
    if (_progress == nil) {
        _progress = [[UISlider alloc]initWithFrame:CGRectMake(70, SCREEN_HEIGHT-4*X+X/2, SCREEN_WIDTH-140, 20)];
        UIImage *thumbImage = [UIImage imageNamed:@"Player_progress_bar"];
        UIImage *thumbImage1 = [UIImage imageNamed:@"001_0000_B副本"];
        [_progress setMaximumTrackImage:thumbImage1 forState:UIControlStateNormal];
        [_progress setThumbImage:thumbImage forState:UIControlStateNormal];
        _progress.value=0;
        _progress.minimumValue=0;
        // 监听进度条的手动改变
        [self.progress addTarget:self action:@selector(progressValueChage:) forControlEvents:UIControlEventValueChanged];
        [self.progress addTarget:self action:@selector(progressEndChange) forControlEvents:UIControlEventTouchUpInside];
        [self.progress addTarget:self action:@selector(progressEndChange) forControlEvents:UIControlEventTouchUpOutside];
    }
    return _progress;
}
- (UIProgressView *)pro{
    if (_pro == nil) {
        CGFloat x = 80;
        CGFloat y = SCREEN_HEIGHT-4*X+X/2+9;
        CGFloat w = SCREEN_WIDTH-150;
        CGFloat h = 20;
        _pro = [[UIProgressView alloc]initWithFrame:CGRectMake(x, y, w, h)];
        _pro.progress=0;
        _pro.progressTintColor=[UIColor colorWithRed:0.000 green:0.003 blue:0.621 alpha:1.000];
    }
    return _pro;
}


- (UILabel *)currentTime{
    if (!_currentTime) {
        _currentTime = [[UILabel alloc]initWithFrame:CGRectMake(10, self.progress.frame.origin.y, 50, 20)];
        _currentTime.text=@"00:00";
        _currentTime.textColor = [UIColor colorWithWhite:0.651 alpha:1.000];
        _currentTime.textAlignment = NSTextAlignmentCenter;
    }
    return _currentTime;
}
- (UILabel *)songTimeLabel{
    if (_songTimeLabel == nil) {
        _songTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-60, self.progress.frame.origin.y, 50, 20)];
        _songTimeLabel.text = @"00:00";
        _songTimeLabel.textColor = [UIColor colorWithWhite:0.651 alpha:1.000];
        _songTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _songTimeLabel;
}

- (UIButton *)roundButton{
    if (_roundButton == nil) {
        _roundButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _roundButton.frame = CGRectMake(X, SCREEN_HEIGHT-2*X, X, X);
        UIImage *image = [[UIImage imageNamed:@"001_0000s_0004_110"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [_roundButton setImage:image forState:UIControlStateNormal];
        [_roundButton addTarget:self action:@selector(round:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _roundButton;
}

- (UIButton *)upButton{
    if (_upButton == nil) {
        _upButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _upButton.frame = CGRectMake(4*X, self.roundButton.frame.origin.y, X, X);
        UIImage *image = [[UIImage imageNamed:@"001_0000s_0006_组-3"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [_upButton setImage:image forState:UIControlStateNormal];
        [_upButton setImage:image forState:UIControlStateNormal];
        [_upButton addTarget:self action:@selector(on:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _upButton;
}
- (UIButton *)playButton{
    if (_playButton == nil) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _playButton.frame = CGRectMake(7*X, self.roundButton.frame.origin.y-X/2, 2*X, 2*X);
        UIImage *image = [[UIImage imageNamed:@"001_0000s_0009_组-5"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [_playButton setImage:image forState:UIControlStateNormal];
        [_playButton addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
        isPlay=NO;
        [self play:_playButton];
    }
    return _playButton;
}

- (UIButton *)nextButton{
    if (!_nextButton) {
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextButton.frame = CGRectMake(11*X, self.roundButton.frame.origin.y, X, X);
        UIImage *image = [[UIImage imageNamed:@"001_0000s_0007_组-4"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [_nextButton setImage:image forState:UIControlStateNormal];
        [_nextButton addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextButton;
}
- (UIButton *)menuButton{
    if (!_menuButton) {
        _menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _menuButton.frame = CGRectMake(14*X, self.roundButton.frame.origin.y, X, X);
        UIImage *image = [[UIImage imageNamed:@"001_0000s_0005_组-2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [_menuButton setImage:image forState:UIControlStateNormal];
        [_menuButton addTarget:self action:@selector(menuButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _menuButton;
}

- (UIView *)menuBack {
    if (!_menuBack) {
        _menuBack = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _menuBack.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        _menuBack.hidden = YES;
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backTap)];
        ges.delegate = self;
        [_menuBack addGestureRecognizer:ges];
    }
    return _menuBack;
}

- (UITableView *)menuTable {
    if (!_menuTable) {
        CGFloat width = SCREEN_WIDTH;
        CGFloat height = SCREEN_HEIGHT * 2 / 5;
        _menuTable = [[UITableView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-height, width, height) style:UITableViewStyleGrouped];
        _menuTable.backgroundColor = [UIColor orangeColor];
        _menuTable.delegate = self;
        _menuTable.dataSource = self;
        _menuTable.tableHeaderView = nil;
    }
    return _menuTable;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NSDictionary *dict = [[jsonDict valueForKey:@"RET"] valueForKey:@"Sys_GX_ZJ"][indexPath.row];
    
    NSString *urlString = [dict valueForKey:@"GJ_NAME"];
    
    cell.textLabel.text = urlString;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return total;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self next:indexPath];
    _menuBack.hidden = YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:_menuTable]) {
        return NO;
    }
    return YES;
}

#pragma mark Action
- (void)backTap {
    _menuBack.hidden = YES;
}

- (IBAction)share:(UIButton *)sender {
    NSLog(@"点击了分享!!!");
}
- (IBAction)like:(UIButton *)sender {
    
}
- (IBAction)download:(UIButton *)sender {
    
}
-(IBAction)menuButton:(UIButton*)sender {
    _menuBack.hidden = NO;
}
#pragma mark 循环状态
bool isRound = NO;
- (IBAction)round:(UIButton*)sender {
    //状态1：随机播放 状态2：单曲循环
    isRound = !isRound;
    if (isRound) {
        [_roundButton setImage:[UIImage imageNamed:@"001_0000s_0004_110"] forState:UIControlStateNormal];
        return;
    }
     [_roundButton setImage:[UIImage imageNamed:@"001_0000s_0001_Player_download@2x"] forState:UIControlStateNormal];
}
#pragma mark 上一首
- (IBAction)on:(UIButton *)sender {
    if (_touchNum > 0 && _touchNum < total) {
        _touchNum--;
        [self startPlayBefore];
    }else {
        NSLog(@"第一首!!!");
        _touchNum = 0;
        [self startPlayBefore];
    }
}
#pragma mark 下一首
- (IBAction)next:(id)sender {
    if ([sender isKindOfClass:[NSIndexPath class]]) {
        if (((NSIndexPath *)sender).row >= 0) {
            _touchNum = (int)((NSIndexPath *)sender).row;
            [self startPlayBefore];
            return;
        }
    }
    if (isRound) {
        [self startPlayBefore];
        return;
    }
    if (_touchNum < total) {
        _touchNum++;
        [self startPlayBefore];
    }else{
        if (!isRound) {
            _touchNum = 0;
            [self startPlayBefore];
            return;
        }
        NSLog(@"最后一首也播放结束!!!");
    }
}

/**
 *  播放 与 暂停
 */
- (IBAction)play:(UIButton *)sender {
    if (!isPlay) {
        isPlay=YES;
        if (kj_player.isPlayComplete) {
            [self startPlayBefore];
        }else{
            [kj_player play]; // 播放
            [self imageViewRotate]; // 旋转歌手图片
            [self.playButton setImage:[UIImage imageNamed:@"001_0000s_0008_组-5-副本"] forState:UIControlStateNormal];
        }
    }else{
        isPlay=NO;
        [kj_player pause]; // 暂停
        NSLog(@"%@--%hhd--%hhd", _rotationAnimation.toValue,_rotationAnimation.cumulative,_rotationAnimation.additive);
        [self.authorImageView.layer removeAnimationForKey:@"rotationAnimation"];
        [sender setImage:[UIImage imageNamed:@"001_0000s_0009_组-5"] forState:UIControlStateNormal];
    }
}

#pragma mark - 自定义方法

/**
 *  歌手图片旋转动画
 */
- (void)imageViewRotate {
    [self.authorImageView.layer addAnimation:_rotationAnimation forKey:@"rotationAnimation"];
}

/**
 *  时间转换
 *
 *  time 秒数
 */
- (NSString *)convertStringWithTime:(float)time {
    if (isnan(time)) time = 0.f;
    int min = time / 60.0;
    int sec = time - min * 60;
    NSString * minStr = min > 9 ? [NSString stringWithFormat:@"%d",min] : [NSString stringWithFormat:@"0%d",min];
    NSString * secStr = sec > 9 ? [NSString stringWithFormat:@"%d",sec] : [NSString stringWithFormat:@"0%d",sec];
    NSString * timeStr = [NSString stringWithFormat:@"%@:%@",minStr, secStr];
    return timeStr;
}

#pragma mark - KVO
/**
 *  观察者监听方法
 *
 *  keyPath
 *  object
 *  change
 *  context
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"songTime"]) {
        self.songTimes = kj_player.songTime;
        self.songTimeLabel.text = [self convertStringWithTime:kj_player.songTime];
        self.pro.progress = kj_player.cacheValue; // 缓存进度条
    } else if ([keyPath isEqualToString:@"currentTime"]) {
        [self progressValueChage:YES];
        
    } else if ([keyPath isEqualToString:@"isPlayComplete"]) {
        NSNumber *number = [change valueForKey:@"new"];
        if (number.intValue==1) {
            [self next:nil];
        }else {
            NSLog(@"正在播放!!!");
        }
    }
}

/**
 *  进度条改变操作
 */
bool isObserve = YES;
- (void)progressValueChage:(BOOL)notDrag{
    [NSThread sleepForTimeInterval:0.1];
    if (notDrag) {
        self.currentTime.text = [self convertStringWithTime:kj_player.currentTime];
        self.progress.value = (1.0/kj_player.songTime) * kj_player.currentTime;
        
        NSString *s = [self convertStringWithTime:kj_player.currentTime];
        if ([timeArry containsObject:s]) {
            currentLyricNum = (int)[timeArry indexOfObject:s];
            if (lrcArry.count-1>currentLyricNum) {
                self.lyricTableView.lyricLocation = currentLyricNum;
            }
        }else if(currentLyricNum==0){
            self.lyricTableView.lyricLocation = 0;
        }
        //    CGFloat pro = kj_player.currentTime / self.songTimes; /**< 播放进度 */
        //    self.progress.value = pro;
        return;
    }
    [self pack];
}

- (void)progressEndChange {
    dispatch_async(dispatch_queue_create(nil, nil), ^{
        [NSThread sleepForTimeInterval:0.4];
        [kj_player addObserver:self forKeyPath:@"currentTime" options:NSKeyValueObservingOptionNew context:nil];
        isObserve = YES;
    });
}

- (void)pack{
    if (isObserve) {
        [kj_player removeObserver:self forKeyPath:@"currentTime"]; // 移除观察者
        isObserve = NO;
    }
    CGFloat currentTime = self.progress.value * kj_player.songTime;
    [kj_player.player seekToTime:CMTimeMakeWithSeconds(currentTime, USEC_PER_SEC) completionHandler:^(BOOL finished) {
    }];
    
    NSString *s = [self convertStringWithTime:currentTime];
    if ([timeArry containsObject:s]) {
        if (lrcArry.count-1>currentLyricNum) {
            currentLyricNum = (int)[timeArry indexOfObject:s];
            self.lyricTableView.lyricLocation = currentLyricNum;
        } else if (lrcArry.count-1==currentLyricNum){
            self.lyricTableView.lyricLocation = currentLyricNum;
        }
    }else if(currentLyricNum==0){
        self.lyricTableView.lyricLocation = 0;
    }
}

#pragma mark - 懒加载

/**
 *  播放之前的准备
 */
- (void)startPlayBefore {
    NSDictionary *dict = [[jsonDict valueForKey:@"RET"] valueForKey:@"Sys_GX_ZJ"][_touchNum];
    // 重置显示的数据
    self.currentTime.text = @"00:00";
    self.pro.progress = 0; // 缓存进度条
    self.progress.value = 0;
    currentLyricNum = 0; // 歌词位置清零
    self.authorNameLabel.text = [dict valueForKey:@"GJ_NAME"];
    
    [self.playButton setImage:[UIImage imageNamed:@"001_0000s_0008_组-5-副本"] forState:UIControlStateNormal];
    
    [self paserLrcFileContents:[dict valueForKey:@"GJ_CONTENT_CN"]];// 传入歌词
    
    [kj_player removeObserver]; // 移除观察者
    kj_player.isPlayComplete = NO; // 播放状态
    NSString *urlString = [NSString stringWithFormat:@"http://218.240.52.135%@",[dict valueForKey:@"GJ_MP3"]];
    [kj_player setNewPlayerWithUrl:urlString]; // 传入播放的mp3Url
    [kj_player addObserver]; // 添加新的观察者
    // 三个KVO观察播放属性
    [kj_player addObserver:self forKeyPath:@"songTime" options:NSKeyValueObservingOptionNew context:nil];
    [kj_player addObserver:self forKeyPath:@"currentTime" options:NSKeyValueObservingOptionNew context:nil];
    [kj_player addObserver:self forKeyPath:@"isPlayComplete" options:NSKeyValueObservingOptionNew context:nil];
    [kj_player play]; // 播放
    [self imageViewRotate]; // 旋转歌手图片
    
    [self setNowPlayingInfo];
}

//解析歌词内容
- (void)paserLrcFileContents:(NSString *)contents {
    NSArray *array = [contents componentsSeparatedByString:@"\n"];
    lrcArry = [NSMutableArray array];
    timeArry = [NSMutableArray array];
    for (int i = 0; i < [array count]; i++) {
        NSString *lineString = [array objectAtIndex:i];
        NSArray *lineArray = [lineString componentsSeparatedByString:@"]"];
        if ([lineArray[0] length] > 5) {
            NSString *str1 = [lineString substringWithRange:NSMakeRange(3, 1)];
            if ([str1 isEqualToString:@":"]) {
                for (int i = 0; i < lineArray.count - 1; i++) {
                    //分割区间求歌次
                    NSString *lrcString = [lineArray objectAtIndex:lineArray.count - 1];
                    [lrcArry addObject:lrcString];
                    //分割区间求歌词时间
                    NSString *timeString = [lineString substringWithRange:NSMakeRange(1, 5)];
                    [timeArry addObject:timeString];
                }
            }
        }
    }
    [self.lyricTableView getLyric:lrcArry];
}

#pragma mark - 设置控制中心正在播放的信息
-(void)setNowPlayingInfo{
    NSMutableDictionary *songDict=[NSMutableDictionary dictionary];
    //歌名
    [songDict setObject:@"31321af  暗杀" forKey:MPMediaItemPropertyTitle];
    //歌手名
    [songDict setObject:@"发送到发放的" forKey:MPMediaItemPropertyArtist];
    //歌曲的总时间
    [songDict setObject:[NSNumber numberWithDouble:323.0] forKeyedSubscript:MPMediaItemPropertyPlaybackDuration];
    //设置歌曲图片
    MPMediaItemArtwork *imageItem=[[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:@"19"]];
    [songDict setObject:imageItem forKey:MPMediaItemPropertyArtwork];
    //设置控制中心歌曲信息
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songDict];
    
    //    NSDictionary *info=[[MPNowPlayingInfoCenter defaultCenter] nowPlayingInfo];
    //    NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithDictionary:info];
    //    [dict setObject:@(kj_player.currentTime) forKeyedSubscript:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    //    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
    
}

#pragma mark 后台播放和锁屏播放
- (void)remoteControlReceivedWithEvent:(UIEvent *)receivedEvent {
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        switch (receivedEvent.subtype) {
            case UIEventSubtypeRemoteControlTogglePlayPause:
                NSLog(@"0");
                // [self playAndStopSong:self.playButton];
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                NSLog(@"1");//上一首
                //  [self playLastButton:self.lastButton];
                
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                NSLog(@"2");//下一首
                // [self playNextSong:self.nextButton];
                
                break;
            case UIEventSubtypeRemoteControlPlay:
                NSLog(@"3");//播放
                //[self playAndStopSong:self.playButton];
                
                break;
            case UIEventSubtypeRemoteControlPause:
                NSLog(@"4");//
                // [self playAndStopSong:self.playButton];
                
                break;
            default:
                break;
        }
    }
}

@end
