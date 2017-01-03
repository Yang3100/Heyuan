//
//  playerViewController.m
//  player
//
//  Created by 杨科军 on 2016/12/16.
//  Copyright © 2016年 杨科军. All rights reserved.
//

#import "playerViewController.h"
#import "lyricView.h"

#import <MediaPlayer/MPNowPlayingInfoCenter.h>
#import <MediaPlayer/MPMediaItem.h>

#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height) // 屏幕高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width) // 屏幕宽度
#define X ([UIScreen mainScreen].bounds.size.width/16) // 宽度

@interface playerViewController () <UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate> {
    NSDictionary *jsonDict;
    int total; // 总歌曲数
    NSMutableArray *timeArry;
    NSString *lastPlayGJID;  // 保存上一次播放的音频的章节ID
    bool isRound; // 是否循环
    NSDictionary *kj_dict;
    bool getDataWay;  // 获取数据的方式  yes代表第1种，no第2种
}

@property (nonatomic, strong) CABasicAnimation *rotationAnimation; /**< 歌手图片旋转动画 */
@property (nonatomic, assign) CGFloat songTimes; /**< 歌曲总时间 */

// 界面布局
@property(nonatomic, strong) UILabel *songTimeLabel; // 显示歌曲时间
@property(nonatomic, strong) UILabel *currentTime; // 显示当前时间
@property(nonatomic, strong) UIImageView *autorImageView; /**< 歌手图片 */
@property(nonatomic, strong) UIImageView *backImageView; /**< 背景图片 */
@property(nonatomic, strong) UIView *backView; /**< 最下面的半黑色背景 */
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

@property(nonatomic, copy) UILabel *lrcLabel;//<单句歌词>
@property(nonatomic, copy) UIImageView *lrcImageView;//<锁屏图片>

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
        _kj_player = [[player alloc] init];
        _kj_player.isPlayComplete = YES;
        self.isPrepare = NO;
        self.currentLyricNum = 0;
        lastPlayGJID = @"ykj_luandayixieshuju";
        self.lrcArray = [NSMutableArray array];
        timeArry = [NSMutableArray array];
        self.currentSongs = [NSMutableArray array];
        // 开启防呆模式
        [self preventSBPattern:NO];
    }
    return self;
}
//第1种数据传输方式 -  从最近播放、下载、我喜欢点入的方式
- (void)getDict:(NSDictionary*)dict{
    NSLog(@"第1种数据传输方式 -  从最近播放、下载、我喜欢点入的方式%@",dict);
    getDataWay = NO;
    total=1;
    kj_dict = dict;
    [_currentSongs addObject:dict];
    [self.menuTable reloadData];
}

#pragma mark 获取到数据json
- (void)getJson:(NSDictionary *)json{
    jsonDict = json;
    getDataWay = YES;
    NSLog(@"xxxxxxxxxxxxxxxxxjsonDict:%@",jsonDict);
    NSNumber *num = [[jsonDict valueForKey:@"RET"] valueForKey:@"Record_Count"];
    total = num.intValue;
    NSArray *arr = [[jsonDict valueForKey:@"RET"] valueForKey:@"Sys_GX_ZJ"];
    [_currentSongs addObjectsFromArray:arr];
    [self.menuTable reloadData];
}

- (void)setTouchNum:(int)touchNum{
    // 关闭防呆模式
    [self preventSBPattern:YES];
    _touchNum = touchNum;
    if (!getDataWay) {  // 第1种获取数据方式
        if ([lastPlayGJID isEqualToString:[kj_dict valueForKey:@"GJ_ID"]]) {
            return;
        }else if([lastPlayGJID isEqualToString:@"ykj_luandayixieshuju"]){ // 代表第一次进入播放器
            lastPlayGJID = [kj_dict valueForKey:@"GJ_ID"];
            [self play:nil];
        }else{
            // 播放准备
            [self startPlayBefore];
            lastPlayGJID = [kj_dict valueForKey:@"GJ_ID"];
            return;
        }
        if (isRound) {
            return;
        }
        [self round:nil];
    }
    else{   // 第2种获取数据方式
        kj_dict = [[jsonDict valueForKey:@"RET"] valueForKey:@"Sys_GX_ZJ"][_touchNum];
        if ([lastPlayGJID isEqualToString:[kj_dict valueForKey:@"GJ_ID"]]) {
            NSLog(@"继续播放!!!");
        }else if([lastPlayGJID isEqualToString:@"ykj_luandayixieshuju"]){ // 代表第一次进入播放器
            lastPlayGJID = [kj_dict valueForKey:@"GJ_ID"];
            [self play:nil];
        }else{
            // 播放准备
            [self startPlayBefore];
            lastPlayGJID = [kj_dict valueForKey:@"GJ_ID"];
        }
    }
}

#pragma mark 防呆模式
- (void)preventSBPattern:(BOOL)yes{
    self.likeButton.enabled = yes;
    self.downloadButton.enabled = yes;
    self.shareButton.enabled = yes;
    self.progress.enabled = yes;
    self.upButton.enabled = yes;
    self.playButton.enabled = yes;
    self.nextButton.enabled = yes;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.500]];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    
    [self.navigationController.navigationBar lt_reset];
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
        _lyricTableView.frame = CGRectMake(25, 120, SCREEN_WIDTH-50, SCREEN_WIDTH-50);
        [_lyricTableView initView];
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
        UIImage *image  = [UIImage imageNamed:@"yellowBackground"];
        _backImageView.image = image;
    }
    return _backImageView;
}
- (UIImageView *)authorImageView{
    if (!_authorImageView) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.frame = CGRectMake(X/2, self.shareButton.frame.origin.y-2*X+X/3, 3*X, 3*X);
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.image = cachePicture;
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
        UIImage *image = [[UIImage imageNamed:@"playShare"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [_shareButton setImage:image forState:UIControlStateNormal];
        [_shareButton addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareButton;
}
- (UIButton *)downloadButton{
    if (_downloadButton == nil) {
        _downloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _downloadButton.frame = CGRectMake(SCREEN_WIDTH-3*X-X/2, self.shareButton.frame.origin.y, X, X);
        UIImage *image = [[UIImage imageNamed:@"playDownload"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [_downloadButton setImage:image forState:UIControlStateNormal];
        [_downloadButton addTarget:self action:@selector(download:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _downloadButton;
}
- (UIButton *)likeButton{
    if (_likeButton == nil) {
        _likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _likeButton.frame = CGRectMake(SCREEN_WIDTH-5*X-X/2, self.shareButton.frame.origin.y, X, X);
        
        UIImage *image = [[UIImage imageNamed:@"playLike"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        //        UIImage *image2 = [[UIImage imageNamed:@"playLiked"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
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
        UIImage *thumbImage = [UIImage imageNamed:@"Player_progress_bar"];  // 圆形小球
        [_progress setThumbImage:thumbImage forState:UIControlStateNormal];
        _progress.maximumTrackTintColor = [UIColor clearColor];
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
        _pro.trackTintColor = [UIColor colorWithRed:255.0/255.0 green:240.0/255.0 blue:211.0/255.0 alpha:0.900];
        _pro.progressTintColor=[UIColor colorWithRed:251.0/255.0 green:218.0/255.0 blue:157.0/255.0 alpha:1.000];
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
        UIImage *image = [[UIImage imageNamed:@"playRound"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [_roundButton setImage:image forState:UIControlStateNormal];
        [_roundButton addTarget:self action:@selector(round:) forControlEvents:UIControlEventTouchUpInside];
        isRound = NO;
    }
    return _roundButton;
}

- (UIButton *)upButton{
    if (_upButton == nil) {
        _upButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _upButton.frame = CGRectMake(4*X, self.roundButton.frame.origin.y, X, X);
        UIImage *image = [[UIImage imageNamed:@"playOn"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
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
        UIImage *image = [[UIImage imageNamed:@"kjplay"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [_playButton setImage:image forState:UIControlStateNormal];
        [_playButton addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
        self.isPlay=NO;
    }
    return _playButton;
}

- (UIButton *)nextButton{
    if (!_nextButton) {
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextButton.frame = CGRectMake(11*X, self.roundButton.frame.origin.y, X, X);
        UIImage *image = [[UIImage imageNamed:@"playNext"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [_nextButton setImage:image forState:UIControlStateNormal];
        [_nextButton addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextButton;
}
- (UIButton *)menuButton{
    if (!_menuButton) {
        _menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _menuButton.frame = CGRectMake(14*X, self.roundButton.frame.origin.y, X, X);
        UIImage *image = [[UIImage imageNamed:@"playMenu"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
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
        _menuTable.backgroundColor = RGB255_COLOR(213.0,186.0,139.0,0.95);
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
    //    [self next:indexPath];
    self.touchNum = indexPath.row;
    _menuBack.hidden = YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
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
    if ([lastPlayGJID isEqualToString:@"ykj_luandayixieshuju"]){ // 第一次进入播放器
        NSLog(@"无数据分享!!!");
        return;
    }
    ShareView *ocsv = [[ShareView alloc]init];
    ocsv.setShareContent = ShareMusic;
    NSDictionary *dict = [[jsonDict valueForKey:@"RET"] valueForKey:@"Sys_GX_ZJ"][_touchNum];
    ocsv.title = [dict valueForKey:@"GJ_NAME"]; // 小节名字
    if ([[dict valueForKey:@"GJ_USER"] isEqualToString:@""]) {
        ocsv.describe = @"和源";
    }else{
        ocsv.describe = [dict valueForKey:@"GJ_USER"]; // 作者名字
    }
    ocsv.thumbImage = networkPictureUrl;
    NSLog(@"%@",[DataModel defaultDataModel].bookImageUrl);
    ocsv.musicUrl = [IP stringByAppendingString:[dict valueForKey:@"GJ_MP3"]];
    
    [self.view addSubview:ocsv];
}
- (IBAction)like:(UIButton *)sender {
    
}
- (IBAction)download:(UIButton *)sender {
    
}
-(IBAction)menuButton:(UIButton*)sender {
    _menuBack.hidden = NO;
}
#pragma mark 循环状态
- (IBAction)round:(UIButton*)sender {
    //状态1：随机播放 状态2：单曲循环
    isRound = !isRound;
    if (isRound) {
        [_roundButton setImage:[UIImage imageNamed:@"xuanhuan"] forState:UIControlStateNormal];
        return;
    }
    [_roundButton setImage:[UIImage imageNamed:@"playRound"] forState:UIControlStateNormal];
}
#pragma mark 上一首
- (IBAction)on:(UIButton *)sender {
    if (isRound) {
        [self startPlayBefore];
        return;
    }
    if (_touchNum > 0 && _touchNum < total-1) {
        self.touchNum = _touchNum - 1;
    }else {
        self.touchNum = 0;
    }
}
#pragma mark 下一首
- (IBAction)next:(id)sender {
    if ([sender isKindOfClass:[NSIndexPath class]]) {
        if (((NSIndexPath *)sender).row >= 0) {
            self.touchNum = (int)((NSIndexPath *)sender).row;
            return;
        }
    }
    if (isRound) { // 处于单曲循环
        [self startPlayBefore];
        return;
    }
    if (_touchNum < total-1) {
        self.touchNum = _touchNum + 1;
    }else{
        if (!isRound) {
            self.touchNum = 0;
            return;
        }
        NSLog(@"最后一首也播放结束!!!");
        self.isPrepare = NO;
        DATA_MODEL.playingSection = nil;
    }
}

/**
 *  播放 与 暂停
 */
- (IBAction)play:(UIButton *)sender {
    if (!self.isPlay) {
        self.isPlay=YES;
        if (_kj_player.isPlayComplete) {
//            [self next:nil];
            [self startPlayBefore];
            return;
        }else{
            [_kj_player play]; // 播放
            [self imageViewRotate]; // 旋转歌手图片
            [self.playButton setImage:[UIImage imageNamed:@"kjpause"] forState:UIControlStateNormal];
        }
    }else{
        self.isPlay=NO;
        [_kj_player pause]; // 暂停
        [self.authorImageView.layer removeAnimationForKey:@"rotationAnimation"];
        [sender setImage:[UIImage imageNamed:@"kjplay"] forState:UIControlStateNormal];
    }
    [self setNowPlayingInfo];
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
        if (!((self.songTimes - _kj_player.songTime) <= 0.0001) || (self.songTimes - _kj_player.songTime) < -0.01) {
            self.songTimes = _kj_player.songTime; // 获取到媒体的总时长
        }
        self.songTimeLabel.text = [self convertStringWithTime:_kj_player.songTime];
    }else if ([keyPath isEqualToString:@"cacheValue"]) {
        NSNumber *number = [change valueForKey:@"new"];
        self.pro.progress = number.floatValue; // 缓存进度条
    }else if ([keyPath isEqualToString:@"currentTime"]) {
        if (!_dic[@"image"]) {
            [_dic setObject:DATA_MODEL.bookImageUrl forKey:@"image"];
        }
        [DATA_MODEL addRecentPlay:_dic];
        [self progressValueChage:YES];
        [self setNowPlayingInfo];  // 锁屏播放
    } else if ([keyPath isEqualToString:@"isPlayComplete"]) {
        NSNumber *number = [change valueForKey:@"new"];
        if (number.intValue==1) {
            [self next:nil];
        }
    }
}


/**
 *  进度条改变操作
 */
bool isObserve = YES;
- (void)progressValueChage:(BOOL)notDrag{
    if (notDrag) {
        self.currentTime.text = [self convertStringWithTime:_kj_player.currentTime];
        self.progress.value = (1.0/_kj_player.songTime) * _kj_player.currentTime;
        
        NSString *s = [self convertStringWithTime:_kj_player.currentTime];
        if ([timeArry containsObject:s]) {
            self.currentLyricNum = (int)[timeArry indexOfObject:s];
            if (_lrcArray.count-1>self.currentLyricNum) {
                self.lyricTableView.lyricLocation = self.currentLyricNum;
            }
            else if (_lrcArray.count-1==self.currentLyricNum){
                self.lyricTableView.lyricLocation = _lrcArray.count-1;
            }
        }else if(self.currentLyricNum==0){
            self.lyricTableView.lyricLocation = 0;
        }
        return;
    }
    [self pack];
}

- (void)progressEndChange {
    dispatch_async(dispatch_queue_create(nil, nil), ^{
        [NSThread sleepForTimeInterval:0.4];
        [_kj_player addObserver:self forKeyPath:@"currentTime" options:NSKeyValueObservingOptionNew context:nil];
        isObserve = YES;
    });
}

- (void)pack{   // 拖动小球是调用
    if (isObserve) {
        [_kj_player removeObserver:self forKeyPath:@"currentTime"]; // 移除观察者
        isObserve = NO;
    }
    CGFloat currentTime = self.progress.value * _kj_player.songTime;
    [_kj_player.player seekToTime:CMTimeMakeWithSeconds(currentTime, USEC_PER_SEC) completionHandler:^(BOOL finished) {
    }];
    
    NSString *s = [self convertStringWithTime:currentTime];
    if ([timeArry containsObject:s]) {
        if (_lrcArray.count-1>self.currentLyricNum) {
            self.currentLyricNum = (int)[timeArry indexOfObject:s];
            self.lyricTableView.lyricLocation = self.currentLyricNum;
        }
        else if (_lrcArray.count-1==self.currentLyricNum){
            self.lyricTableView.lyricLocation = self.currentLyricNum;
        }
    }else if(self.currentLyricNum==0){
        self.lyricTableView.lyricLocation = 0;
    }
}

#pragma mark - 懒加载

/**
 *  播放之前的准备
 */
- (void)startPlayBefore {
    _dic = [NSMutableDictionary dictionaryWithDictionary:kj_dict];
    // 重置显示的数据
    [self paserLrcFileContents:[kj_dict valueForKey:@"GJ_CONTENT_CN"]];// 解析歌词 - 传入歌词
    self.currentTime.text = @"00:00";
    self.pro.progress = 0; // 缓存进度条
    self.progress.value = 0;
    self.currentLyricNum = 0; // 歌词位置清零
    self.authorNameLabel.text = [kj_dict valueForKey:@"GJ_NAME"];
    NSURL *url = [NSURL URLWithString:DATA_MODEL.bookImageUrl];
    [self.autorImageView sd_setImageWithURL:url placeholderImage:cachePicture];
    
    [self.playButton setImage:[UIImage imageNamed:@"kjpause"] forState:UIControlStateNormal];
    
    [_kj_player removeObserver]; // 移除观察者
    _kj_player.isPlayComplete = NO; // 播放状态
    NSString *urlString = [NSString stringWithFormat:@"%@%@",IP,[kj_dict valueForKey:@"GJ_MP3"]];
    [_kj_player setNewPlayerWithUrl:urlString]; // 传入播放的mp3Url
    [_kj_player addObserver]; // 添加新的观察者
    // 三个KVO观察播放属性
    [_kj_player addObserver:self forKeyPath:@"songTime" options:NSKeyValueObservingOptionNew context:nil];
    [_kj_player addObserver:self forKeyPath:@"cacheValue" options:NSKeyValueObservingOptionNew context:nil];
    [_kj_player addObserver:self forKeyPath:@"currentTime" options:NSKeyValueObservingOptionNew context:nil];
    [_kj_player addObserver:self forKeyPath:@"isPlayComplete" options:NSKeyValueObservingOptionNew context:nil];
    
    [_kj_player play]; // 播放
    self.isPrepare = YES;
    [self imageViewRotate]; // 旋转歌手图片
    
    [self setNowPlayingInfo];  // 设置锁屏播放
}


//解析歌词内容
- (void)paserLrcFileContents:(NSString *)contents {
    NSArray *array = [contents componentsSeparatedByString:@"\n"];
    [_lrcArray removeAllObjects];
    [timeArry removeAllObjects];
    for (int i = 0; i < [array count]; i++) {
        NSString *lineString = [array objectAtIndex:i];
        NSArray *lineArray = [lineString componentsSeparatedByString:@"]"];
        if ([lineArray[0] length] > 5) {
            NSString *str1 = [lineString substringWithRange:NSMakeRange(3, 1)];
            if ([str1 isEqualToString:@":"]) {
                for (int i = 0; i < lineArray.count - 1; i++) {
                    //分割区间求歌次
                    NSString *lrcString = [lineArray objectAtIndex:lineArray.count - 1];
                    [_lrcArray addObject:lrcString];
                    //分割区间求歌词时间
                    NSString *timeString = [lineString substringWithRange:NSMakeRange(1, 5)];
                    [timeArry addObject:timeString];
                }
            }
        }
    }
    self.lyricTableView.lyricArray = _lrcArray;  // 传入歌词到歌词table当中
}

#pragma mark - 设置控制中心正在播放的信息
-(void)setNowPlayingInfo{
    NSDictionary *info=[[MPNowPlayingInfoCenter defaultCenter] nowPlayingInfo];
    NSMutableDictionary *songDict=[NSMutableDictionary dictionaryWithDictionary:info];
    //歌名
    if (![kj_dict valueForKey:@"GJ_NAME"]) {
        return;
    }
    NSString *authorName;
    if ([[kj_dict valueForKey:@"GJ_USER"] isEqualToString:@""]) {
        authorName = @"和源";
    }else{
        authorName = [kj_dict valueForKey:@"GJ_USER"];
    }
    [songDict setObject:[kj_dict valueForKey:@"GJ_NAME"] forKey:MPMediaItemPropertyTitle];
    //作者
    [songDict setObject:authorName forKey:MPMediaItemPropertyArtist];
    //歌曲的总时间
    [songDict setObject:[NSNumber numberWithDouble:_kj_player.songTime] forKeyedSubscript:MPMediaItemPropertyPlaybackDuration];
    //设置已经播放时长
    [songDict setObject:[NSNumber numberWithDouble:_kj_player.currentTime] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    
    if (!_lrcImageView) {
        _lrcImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 100,self.view.frame.size.width - 100 + 50)];
        UIView *v = [[UIView alloc] initWithFrame:_lrcImageView.frame];
        v.backgroundColor = [UIColor blackColor];
        v.alpha = 0.2;
        [_lrcImageView addSubview:v];
        _lrcLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _lrcImageView.frame.size.height - 120, _lrcImageView.frame.size.width, 100)];
        _lrcLabel.font = [UIFont systemFontOfSize:15];
        _lrcLabel.textAlignment = NSTextAlignmentCenter;
        _lrcLabel.numberOfLines = 0;
        _lrcLabel.textColor = [UIColor whiteColor];
        [_lrcImageView addSubview:self.lrcLabel];
    }
    _lrcLabel.text = [_lrcArray objectAtIndex:self.currentLyricNum];
    NSURL *url = [NSURL URLWithString:[DataModel defaultDataModel].bookImageUrl];
    [_lrcImageView sd_setImageWithURL:url placeholderImage:cachePicture];
    
    //获取添加了歌词数据的背景图
    UIGraphicsBeginImageContextWithOptions(_lrcImageView.frame.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [_lrcImageView.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //设置显示的图片
    [songDict setObject:[[MPMediaItemArtwork alloc] initWithImage:img] forKey:MPMediaItemPropertyArtwork];
    
    //设置控制中心歌曲信息
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songDict];
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
                [self on:nil];
                
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                NSLog(@"2");//下一首
                [self next:nil];
                
                break;
            case UIEventSubtypeRemoteControlPlay:
                NSLog(@"3");//锁屏播放
                [self play:nil];
                
                break;
            case UIEventSubtypeRemoteControlPause:
                NSLog(@"4");//锁屏暂停
                [self play:nil];
                
                break;
            default:
                break;
        }
    }
}

- (void)instancePlay:(NSString *)state {
    if ([state isEqualToString:@"on"]) {
        [self on:nil];
    }
    if ([state isEqualToString:@"next"]) {
        [self next:nil];
    }
    if ([state isEqualToString:@"play"]) {
        [self play:nil];
    }
}


@end
