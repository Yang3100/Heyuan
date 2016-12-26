
//
//  ClickLibraryViewController.m
//  XinMinClub
//
//  Created by yangkejun on 16/3/22.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "ClickLibraryViewController.h"
#import "ClickLibraryCardView.h"
#import "PlayAllCell.h"
#import "SectionCell.h"
#import "DetailsTableView.h"
#import "ReadTableView.h"
#import "SectionModel.h"
#import "SaveClass.h"
#import "SaveData.h"
#import "ReaderTableViewController.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "PalyerViewController.h"
#import "ShareViewController.h"
#import "SVProgressHUD.h"
#import "GlobalDialogBoxCentralNervousSystem.h"
#import "HomeViewController.h"

#define BUFFERX 0 //distance from side to the card (higher makes thinner card)
#define BUFFERY 0 //distance from top to the card (higher makes shorter card)

@interface ClickLibraryViewController ()<RKCardViewDelegate,UITableViewDelegate,UITableViewDataSource,ClickModelDelegate>{
    UIView *detailsView;
    UIView *readView;
    // 传给播放器的数组
    NSMutableArray *detailsListArray;
    NSMutableArray *detailsListIDArray;
    NSMutableArray *detailsMp3Array;
    NSMutableArray *detailsCNArray;
    NSMutableArray *detailsANArray;
    NSMutableArray *detailsENArray;
    
    UIButton *shareCloseButton; // 分享里面的取消按钮
    
    NSMutableArray *sectionArray;
    NSArray *detailsArray;
    NSArray *readArray;
    NSInteger i; // 上拉刷新
    bool off; // 判断数据是否获取到的状态
    NSInteger detailsTotal; // 章节总数
    
    NSInteger leftNum;
    NSInteger shareClickNum; // 监听分享button在点击了腾讯微博分享的状态
    
    NSInteger likeButton; // 我喜欢的按钮状态
    
    UIImage *placeholderImage;  // 占位图
}

@property(nonatomic, copy) ClickLibraryCardView *cardView;
@property(nonatomic, copy) UITableView *tableView;
@property(nonatomic, copy) DetailsTableView *detailsTableView;
@property(nonatomic, copy) ReadTableView *readTableView;
@property(nonatomic,strong)ShareViewController *share;//分享

@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, strong) UIButton *button1; // 加入文集
@property (nonatomic, strong) UIButton *button2; // 分享

@end

@implementation ClickLibraryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
#warning placeholderImage 占位图
//    placeholderImage = [UIImage imageNamed:@"1false.jpg"];
    
    [self.view addSubview:self.leftView];
    [self.view bringSubviewToFront:self.leftView];
    
    [self.leftView addSubview:self.button1];
    [self.leftView addSubview:self.button2];
    
    // 分享的UIView
    shareClickNum = 0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shareButClick1:) name:@"closeShare" object:nil];
    [self.view addSubview:self.share.view];
    
    sectionArray = [NSMutableArray array];
    
    detailsListArray = [NSMutableArray array];
    detailsListIDArray = [NSMutableArray array];
    detailsMp3Array = [NSMutableArray array];
    detailsCNArray = [NSMutableArray array];
    detailsANArray = [NSMutableArray array];
    detailsENArray = [NSMutableArray array];
    
    // 右侧消息按钮
    UIImage *leftImage = [[UIImage imageNamed:@"Join_the_corpus"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithImage:leftImage style:UIBarButtonItemStylePlain target:self action:@selector(leftAction)];
    self.navigationItem.rightBarButtonItem = leftButtonItem;
    leftNum = 0;
    
    detailsArray = @[self.libraryImageUrl,self.libraryTitle,self.libraryAuthorName,self.libraryType,self.libraryLanguage,self.libraryDetails];
    i=1;
//    [PalyerViewController shareObject].myClickLibraryViewController=self;
    // 开始获取数据
//    [[SectionModel shareObject] startGetClickBottomData:self.libraryNum PageIndex:i];
    [SectionModel shareObject].clickDelegate = self;
    
    // 文章标题
    self.title = self.libraryTitle;
    
    // 隐藏toolBar
    self.navigationController.toolbarHidden = YES;
    
    [self.view addSubview:self.cardView];
    [self.cardView addSubview:self.tableView];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        i++;
        off=YES;
        if (sectionArray.count>=detailsTotal) {
            [self.tableView.mj_footer endRefreshing];
        }
//        else
//            [[SectionModel shareObject] startGetClickBottomData:self.libraryNum PageIndex:i];
    }];
    
    // 监听属性“PlayCompleteState”
    /* KVO: listen for changes to our earthquake data source for table view updates
     HomeViewController类名,在类里面声明一个属性PlayCompleteState,@“PlayCompleteState"属性名字符串来访问对象属性
     */
    [[HomeViewController shareObject] addObserver:self forKeyPath:@"p_CompleteState" options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark 键值监听
// 播放列表歌曲播放结束，继续请求数据
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    //监听发生变化调用
    NSLog(@"------------------------change:%@",change);
    i++;
    if (sectionArray.count>=detailsTotal) {
        [self.tableView.mj_footer endRefreshing];
        return;
    }
//    else
//       [[SectionModel shareObject] startGetClickBottomData:self.libraryNum PageIndex:i];
//    SectionCell *MySectionCell=[[SectionCell alloc]init];
//    MySectionCell.ClickOnTheButton=i-1;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    // 设置navigationBar背景透明
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar lt_reset];
}

#pragma mark 加入文集和分享
- (UIView *)leftView{
    if (!_leftView) {
        CGFloat x = [UIScreen mainScreen].bounds.size.width/4;
        CGFloat y = -[UIScreen mainScreen].bounds.size.height/4;
        CGFloat w = 2*x;
        CGFloat h = [UIScreen mainScreen].bounds.size.height/6;
        _leftView = [UIView new];
        _leftView.backgroundColor = [UIColor clearColor];
        _leftView.frame = CGRectMake(x,y,w,h);
        _leftView.exclusiveTouch = YES; //决定当前视图是否是处理触摸事件的唯一对象
        _leftView.layer.masksToBounds = YES;
        _leftView.layer.borderWidth = 5.0;
        _leftView.layer.borderColor = [[UIColor colorWithRed:0.471 green:0.310 blue:0.075 alpha:1.000] CGColor];
        
        UIView *centView = [UIView new];
        centView.frame = CGRectMake(0, 0, _leftView.frame.size.width, 5);
        centView.center = CGPointMake(_leftView.frame.size.width/2, _leftView.frame.size.height/2);
        centView.layer.masksToBounds = YES;
        centView.layer.borderWidth = 1;
        centView.layer.borderColor = [[UIColor colorWithRed:0.471 green:0.310 blue:0.075 alpha:1.000] CGColor];
        [_leftView addSubview:centView];
    }
    return _leftView;
}

- (UIButton *)button1{
    if (!_button1) {
        _button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        _button1.frame = CGRectMake(10, 10, _leftView.frame.size.width-20, _leftView.frame.size.height/2-15);
        _button1.backgroundColor = [UIColor colorWithRed:0.180 green:0.110 blue:0.067 alpha:1.000];
        [_button1 setTintColor:[UIColor whiteColor]];
        [_button1 setTitle:@"加入文集" forState:UIControlStateNormal];
        [_button1 addTarget:self action:@selector(button1:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button1;
}
- (UIButton *)button2{
    if (!_button2) {
        _button2 = [UIButton buttonWithType:UIButtonTypeCustom];
        _button2.frame = CGRectMake(10, _leftView.frame.size.height/2+5, _leftView.frame.size.width-20, _leftView.frame.size.height/2-15);
        _button2.backgroundColor = [UIColor colorWithRed:0.180 green:0.110 blue:0.067 alpha:1.000];
        [_button2 setTintColor:[UIColor whiteColor]];
        [_button2 setTitle:@"分享" forState:UIControlStateNormal];
        [_button2 addTarget:self action:@selector(button2:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button2;
}

#pragma mark 右上角navigationBar
- (void)button1:(UIButton *)sender{
    leftNum = 0;
    [self.view sendSubviewToBack:self.leftView];
    
    if ([[DataModel defaultDataModel] addMyLibrary:self.libraryNum ImageUrl:self.libraryImageUrl BookName:self.libraryTitle AuthorName:self.libraryAuthorName]) {
        // 提示成功
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD show];
        [self performSelector:@selector(success) withObject:nil afterDelay:0.6f];
    }else{
        // 提示已经有了
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD show];
        [self performSelector:@selector(success11) withObject:nil afterDelay:0.6f];
    }
}
- (void)success {
    [SVProgressHUD showSuccessWithStatus:@"加入文集成功!"];
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.5f];
}
- (void)success11 {
    [SVProgressHUD showSuccessWithStatus:@"文集已存在!"];
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.5f];
}

- (void)dismiss {
    [SVProgressHUD dismiss];
}

- (void)button2:(UIButton *)sender{
    if (shareClickNum != 0) {
        _share.view.center = CGPointMake(SCREEN_WIDTH/2,2*SCREEN_HEIGHT);
    }
    [UIView transitionWithView:self.share.view duration:0.5 options:0 animations:^{
        _share.view.alpha = 1.0;
        [self.view bringSubviewToFront:_share.view];
        if (shareClickNum != 0) {
            _share.view.center = CGPointMake(SCREEN_WIDTH/2,SCREEN_HEIGHT+SCREEN_HEIGHT/6);
            NSLog(@"%d",shareClickNum);
        }else {
            _share.view.center = CGPointMake(SCREEN_WIDTH/2,SCREEN_HEIGHT*5/6);
            shareClickNum = 0;
        }
    } completion:nil];
    self.leftView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT+SCREEN_HEIGHT/2);
    [self.view sendSubviewToBack:self.leftView];
}

- (void)leftAction{
    
    if (leftNum == 0) {
        leftNum = 1;
        
//        CATransition *animation = [CATransition animation];
//        animation.duration = 0.6;
//        animation.timingFunction = UIViewAnimationCurveEaseInOut;
//        animation.type = @"oglFlip";
//        animation.subtype = kCATransitionFromLeft;
//        [self.leftView.layer addAnimation:animation forKey:nil];
//        
        [self.view bringSubviewToFront:self.leftView];
        self.leftView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    }
    else if (leftNum == 1){
        leftNum = 0;
        self.leftView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT+SCREEN_HEIGHT/2);
        [self.view sendSubviewToBack:self.leftView];
        
        if (shareClickNum != 0) {
            _share.view.center = CGPointMake(SCREEN_WIDTH/2,2*SCREEN_HEIGHT);
            [self.view sendSubviewToBack:_share.view];
        }
        [UIView transitionWithView:self.view duration:0.5 options:0 animations:^{
            _share.view.center = CGPointMake(SCREEN_WIDTH/2,SCREEN_HEIGHT+SCREEN_HEIGHT/4);
        } completion:nil];
    }
}

#pragma mark 分享
-(UIViewController*)share{
    if (!_share) {
        _share=[[ShareViewController alloc]init];
#warning share假数据
        _share.Content = @"123123123";
        _share.Image = nil;
        _share.Location = nil;
        _share.UrlResource = nil;
        _share.view.backgroundColor=[UIColor whiteColor];
        UILabel *rank=[[UILabel alloc] init];
        rank.text=@"—————————————————————————————————";
        rank.textColor=[UIColor colorWithWhite:0.283 alpha:0.500];
        shareCloseButton=[UIButton buttonWithType:UIButtonTypeSystem];
        
        [shareCloseButton setTitle:@"取消" forState:UIControlStateNormal];
        [shareCloseButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [shareCloseButton addTarget:self action:@selector(shareButClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (SCREEN_HEIGHT<667&&SCREEN_HEIGHT >=568) {
            _share.view.frame=CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT/3);
            rank.frame=CGRectMake(0,140, _share.view.frame.size.width*2, 20);
            shareCloseButton.frame=CGRectMake(0,rank.frame.origin.y+20,SCREEN_WIDTH, 20);
        }
        else if (SCREEN_HEIGHT<736&&SCREEN_HEIGHT >=667) {
            _share.view.frame=CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT/3);
            rank.frame=CGRectMake(0,170, _share.view.frame.size.width*2, 20);
            shareCloseButton.frame=CGRectMake(0,rank.frame.origin.y+20,SCREEN_WIDTH, 20);
        }
        else if (SCREEN_HEIGHT>=736) {
            _share.view.frame=CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT/3);
            rank.frame=CGRectMake(0,195, _share.view.frame.size.width*2, 20);
            shareCloseButton.frame=CGRectMake(0,rank.frame.origin.y+20,SCREEN_WIDTH, 20);
        }
        
        [_share.view addSubview:rank];
        [_share.view addSubview:shareCloseButton];
    }
    return _share;
}

// 通知中心
- (void)shareButClick1:(NSNotification *)not{
    NSLog(@"收起来!!!");
    _share.view.alpha = 0;
    shareClickNum = 1;
}

-(IBAction)shareButClick:(id)sender{
    leftNum = 0;
    if (shareClickNum != 0) {
        _share.view.center = CGPointMake(SCREEN_WIDTH/2,2*SCREEN_HEIGHT);
        [self.view sendSubviewToBack:_share.view];
    }
    [UIView transitionWithView:self.view duration:0.5 options:0 animations:^{
        _share.view.center = CGPointMake(SCREEN_WIDTH/2,SCREEN_HEIGHT+SCREEN_HEIGHT/4);
    } completion:nil];
}

#pragma mark ClickModelDelegate
- (void)getClickModelBottomDataComplete:(NSArray *)clickBottomDatas DetailsCount:(NSInteger)count{
    [sectionArray addObjectsFromArray:clickBottomDatas];
    detailsTotal = count;
    readArray = sectionArray;
    
//    NSLog(@"xxxxxxxxxxxxx%@",sectionArray);

    for (NSInteger k=0; k<clickBottomDatas.count; k++) {
        SectionData *data = clickBottomDatas[k];
        [detailsListArray addObject:data.clickTitle];
        [detailsListIDArray addObject:data.clickSectionID];
        [detailsMp3Array addObject:data.clickMp3];
        [detailsCNArray addObject:data.clickSectionCNText];
        [detailsANArray addObject:data.clickSectionANText];
        [detailsENArray addObject:data.clickSectionENText];
    }
    [self.tableView reloadData];
    if (off==YES) {
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];
        off=NO;
    }
}

#pragma mark Subviews

- (ClickLibraryCardView *)cardView{
    if (_cardView == nil) {
        _cardView = [[ClickLibraryCardView alloc]initWithFrame:CGRectMake(BUFFERX, BUFFERY, self.view.frame.size.width-2*BUFFERX, self.view.frame.size.height-2*BUFFERY)];
        NSURL *url = [NSURL URLWithString:self.libraryImageUrl];
        if (self.libraryAuthorImageUrl!=nil) {
//            _cardView.profileImageView.image = placeholderImage;
            [_cardView.profileImageView sd_setImageWithURL:[NSURL URLWithString:self.libraryAuthorImageUrl]]; // 作者头像
        }else
            [_cardView.profileImageView sd_setImageWithURL:url]; // 作者头像
        
//        _cardView.coverImageView.image = placeholderImage;
        [_cardView.coverImageView sd_setImageWithURL:url]; // 封面图片
        _cardView.titleLabel.text = self.libraryAuthorName; // 作者姓名
        // 是否添加到收藏(喜欢)里面
        if ([[UserDataModel defaultDataModel].userLikeBookID containsObject:self.libraryNum]) {
            _cardView.likeImageView.image = [UIImage imageNamed:@"svae_presonal"];
            likeButton = 1;
        }
        else{
            _cardView.likeImageView.image = [UIImage imageNamed:@"svae_presonal_nom"];
            likeButton = 0;
        }
        _cardView.delegate = self;
    }
    return _cardView;
}

- (UITableView *)tableView{
    if (!_tableView) {
        CGFloat x = 0;
        CGFloat y = self.cardView.likeImageView.frame.origin.y+self.cardView.likeImageView.frame.size.height+8;
        CGFloat w = self.cardView.frame.size.width;
        CGFloat h = self.cardView.frame.size.height-y;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(x, y, w, h) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.500];
        // 注册Cell类
        UINib *playAllNib = [UINib nibWithNibName:@"PlayAllCell" bundle:nil];
        [_tableView registerNib:playAllNib forCellReuseIdentifier:@"playAllCell"];
        UINib *sectionNib = [UINib nibWithNibName:@"SectionCell" bundle:nil];
        [_tableView registerNib:sectionNib forCellReuseIdentifier:@"sectionCell"];
    }
    return _tableView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 设置tableView不能下拉
    float offset = self.tableView.contentOffset.y;
    if (offset < 0) {
        self.tableView.contentOffset = CGPointMake(self.tableView.contentOffset.x, 0);
    }
}

#pragma mark RKCardViewDelegate
-(void)likeTap {
    NSLog(@"点击了我喜欢");
    // 提示成功
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD show];
    if (likeButton == 1) {
        likeButton=0;
        [[UserDataModel defaultDataModel] deleteLikeBookID:self.libraryNum];
        [self performSelector:@selector(closeLikeSuccess) withObject:nil afterDelay:0.3f];
    }else if (likeButton==0){
        likeButton=1;
        [[UserDataModel defaultDataModel] addLikeBookID:self.libraryNum];
        [self performSelector:@selector(likeSuccess) withObject:nil afterDelay:0.3f];
    }
}
- (void)closeLikeSuccess {
    [SVProgressHUD showSuccessWithStatus:@"取消喜欢!"];
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.5f];
    _cardView.likeImageView.image = [UIImage imageNamed:@"svae_presonal_nom"];
}
- (void)likeSuccess {
    [SVProgressHUD showSuccessWithStatus:@"加入我喜欢成功!"];
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.5f];
    _cardView.likeImageView.image = [UIImage imageNamed:@"svae_presonal"];
}

-(void)nameTap {
    NSLog(@"点击了名字");
    
}

-(void)profilePhotoTap {
    NSLog(@"点击了头像");
    
    
}
-(void)coverPhotoTap {
    NSLog(@"点击了背景");
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return sectionArray.count+1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    if (indexPath.row == 0) {
        PlayAllCell *cell = [tableView dequeueReusableCellWithIdentifier:@"playAllCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.row>0) {
        SectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sectionCell" forIndexPath:indexPath];
        SectionData *data = sectionArray[indexPath.row-1];
        cell.indexNum = indexPath.row;
        cell.sectionName = data.clickTitle;
        cell.libraryName = self.libraryTitle;
        cell.sectionCNArray = detailsCNArray;
        cell.sectionANArray = detailsANArray;
        cell.sectionENArray = detailsENArray;
        cell.sectionMp3Array = detailsMp3Array;
        cell.sectionNameArray = detailsListArray;
        cell.sectionIDArray = detailsListIDArray;
        
        cell.textLabel.textColor = [UIColor colorWithWhite:0.365 alpha:1.000];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    cell.textLabel.text = @"xxx";
    return cell;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    view.backgroundColor = [UIColor colorWithRed:0.619 green:0.282 blue:0.232 alpha:1.000];
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(0, 0, SCREEN_WIDTH/3, 40);
    [button1 setTitle:@"章节" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor colorWithRed:0.831 green:0.686 blue:0.690 alpha:1.000] forState:UIControlStateNormal];
    button1.showsTouchWhenHighlighted = YES;
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(SCREEN_WIDTH/3, 0, SCREEN_WIDTH/3, 40);
    [button2 setTitle:@"详情" forState:UIControlStateNormal];
    button2.showsTouchWhenHighlighted = YES;
    [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(detailsButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    button3.frame = CGRectMake(SCREEN_WIDTH*2/3, 0, SCREEN_WIDTH/3, 40);
    [button3 setTitle:@"阅读" forState:UIControlStateNormal];
    button3.showsTouchWhenHighlighted = YES;
    [button3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(readButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:button1];
    [view addSubview:button2];
    [view addSubview:button3];
    return view;
}

#pragma mark ButtonActions
- (IBAction)detailsButtonAction:(UIButton *)sender{
    NSLog(@"点击了详情");
    // 设置切换动画
//    CATransition *animation = [CATransition animation];
//    animation.duration = 0.6;
//    animation.type = kCATransitionReveal;
//    animation.subtype = kCATransitionFromTop;
//    [self.view.window.layer addAnimation:animation forKey:nil];
//    
    detailsView = [[UIView alloc]initWithFrame:self.view.bounds];
//    detailsView.backgroundColor = [UIColor colorWithRed:0.511 green:0.145 blue:0.588 alpha:1.000];
    [self.view addSubview:detailsView]; // 替UIView增加一个Subview
    [self addDetailsViewSubviews];
    
    readView = [[UIView alloc]initWithFrame:self.view.bounds];
    readView.backgroundColor = [UIColor colorWithRed:0.553 green:0.281 blue:0.248 alpha:1.000];
    [self.view addSubview:readView]; // 替UIView增加一个Subview
    [self addReadViewSubviews];
    
    [self.view bringSubviewToFront:detailsView];
    leftNum = 0;
    [self.view sendSubviewToBack:self.leftView];
}

- (IBAction)readButtonAction:(UIButton *)sender{
    NSLog(@"点击了阅读");
//    // 设置切换动画
//    CATransition *animation = [CATransition animation];
//    animation.duration = 0.6;
//    animation.type = kCATransitionFade;
//    [self.view.window.layer addAnimation:animation forKey:nil];
//    
    detailsView = [[UIView alloc]initWithFrame:self.view.bounds];
//    detailsView.backgroundColor = [UIColor colorWithRed:0.316 green:0.161 blue:0.141 alpha:1.000];
    [self.view addSubview:detailsView]; // 替UIView增加一个Subview
    [self addDetailsViewSubviews];
    
    readView = [[UIView alloc]initWithFrame:self.view.bounds];
    readView.backgroundColor = [UIColor colorWithRed:0.588 green:0.300 blue:0.264 alpha:1.000];
    [self.view addSubview:readView]; // 替UIView增加一个Subview
    [self addReadViewSubviews];
    
    [self.view bringSubviewToFront:readView];
    leftNum = 0;
    [self.view sendSubviewToBack:self.leftView];
}

- (void)addDetailsViewSubviews{
    CGFloat x = 0;
    CGFloat y = 64;
    CGFloat w = detailsView.frame.size.width;
    UIButton *bu1 = [UIButton buttonWithType:UIButtonTypeCustom];
    bu1.frame = CGRectMake(x, y, w/3-1, 30);
    bu1.tag = 1;
    [bu1 setTitle:@"章节" forState:UIControlStateNormal];
    [bu1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bu1 addTarget:self action:@selector(detailsSubviewButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *bu2 = [UIButton buttonWithType:UIButtonTypeCustom];
    bu2.frame = CGRectMake(x+w/3+1, y, w/3-2, 30);
    bu2.tag = 2;
    [bu2 setTitle:@"详情" forState:UIControlStateNormal];
    [bu2 setTitleColor:[UIColor colorWithRed:0.816 green:0.678 blue:0.682 alpha:1.000] forState:UIControlStateNormal];
    [bu2 addTarget:self action:@selector(detailsSubviewButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *bu3 = [UIButton buttonWithType:UIButtonTypeCustom];
    bu3.frame = CGRectMake(x+w*2/3+1, y, w/3-1, 30);
    bu3.tag = 3;
    [bu3 setTitle:@"阅读" forState:UIControlStateNormal];
    [bu3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bu3 addTarget:self action:@selector(detailsSubviewButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [detailsView addSubview:self.detailsTableView];
    [detailsView addSubview:bu1];
    [detailsView addSubview:bu2];
    [detailsView addSubview:bu3];
}

- (DetailsTableView *)detailsTableView{
    if (!_detailsTableView) {
        _detailsTableView = [[DetailsTableView alloc] initWithFrame:CGRectMake(0, 94, SCREEN_WIDTH, SCREEN_HEIGHT-94)];
        // 传递数据
        _detailsTableView.detailsTextArray = detailsArray;
        _detailsTableView.libraryID = self.libraryNum;
    }
    return _detailsTableView;
}

- (IBAction)detailsSubviewButtonAction:(UIButton *)sender{
    [shareCloseButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    // 设置切换动画
    CATransition *animation = [CATransition animation];
    animation.duration = 0.6;
    leftNum = 0;
    [self.view sendSubviewToBack:self.leftView];
    if (sender.tag == 1) {
        NSLog(@"点击了详情上面的章节");
//        animation.type = kCATransitionMoveIn;
//        [self.view.window.layer addAnimation:animation forKey:nil];
        [self.view sendSubviewToBack:detailsView];
        [self.view sendSubviewToBack:readView];
        [self.detailsTableView.detailsTextField resignFirstResponder];
    }
    if (sender.tag == 2) {
        NSLog(@"点击了详情上面的详情");
        [self.view sendSubviewToBack:readView];
        [self.view bringSubviewToFront:detailsView];
        [self.detailsTableView.detailsTextField resignFirstResponder];
    }
    if (sender.tag == 3) {
        NSLog(@"点击了详情上面的阅读");
//        animation.type = kCATransitionReveal;
//        animation.subtype = kCATransitionFromRight;
//        [self.view.window.layer addAnimation:animation forKey:nil];
        [self.view sendSubviewToBack:detailsView];
        [self.view bringSubviewToFront:readView];
        [self.detailsTableView.detailsTextField resignFirstResponder];
    }
}

- (void)addReadViewSubviews{
    CGFloat x = 0;
    CGFloat y = 64;
    CGFloat w = readView.frame.size.width;
    UIButton *bu1 = [UIButton buttonWithType:UIButtonTypeCustom];
    bu1.frame = CGRectMake(x, y, w/3-1, 30);
    bu1.tag = 1;
    [bu1 setTitle:@"章节" forState:UIControlStateNormal];
    [bu1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bu1 addTarget:self action:@selector(readSubviewButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *bu2 = [UIButton buttonWithType:UIButtonTypeCustom];
    bu2.frame = CGRectMake(x+w/3+1, y, w/3-2, 30);
    bu2.tag = 2;
    [bu2 setTitle:@"详情" forState:UIControlStateNormal];
    [bu2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bu2 addTarget:self action:@selector(readSubviewButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *bu3 = [UIButton buttonWithType:UIButtonTypeCustom];
    bu3.frame = CGRectMake(x+w*2/3+1, y, w/3-1, 30);
    bu3.tag = 3;
    [bu3 setTitle:@"阅读" forState:UIControlStateNormal];
    [bu3 setTitleColor:[UIColor colorWithRed:0.816 green:0.678 blue:0.682 alpha:1.000] forState:UIControlStateNormal];
    [bu3 addTarget:self action:@selector(readSubviewButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [readView addSubview:self.readTableView];
    [readView addSubview:bu1];
    [readView addSubview:bu2];
    [readView addSubview:bu3];
}

- (ReadTableView *)readTableView{
    if (!_readTableView) {
        _readTableView = [[ReadTableView alloc] initWithFrame:CGRectMake(0, 94, SCREEN_WIDTH, SCREEN_HEIGHT-94)];
        _readTableView.backgroundColor = [UIColor colorWithWhite:0.781 alpha:0.800];
        // 传递数据
        _readTableView.readTextArray = readArray;
    }
    return _readTableView;
}

- (IBAction)readSubviewButtonAction:(UIButton *)sender{
    // 收起分享面板
    [shareCloseButton sendActionsForControlEvents:UIControlEventTouchUpInside];
//    // 设置切换动画
//    CATransition *animation = [CATransition animation];
    
    leftNum = 0;
    [self.view sendSubviewToBack:self.leftView];
    if (sender.tag == 1) {
        NSLog(@"点击了详情上面的章节");
//        animation.duration = 0.6;
//        animation.type = kCATransitionPush;
//        [self.view.window.layer addAnimation:animation forKey:nil];
        [self.view sendSubviewToBack:readView];
        [self.view sendSubviewToBack:detailsView];
    }
    if (sender.tag == 2) {
        NSLog(@"点击了详情上面的详情");
//        animation.duration = 0.9;
//        animation.type = @"rippleEffect";
//        [self.view.window.layer addAnimation:animation forKey:nil];
        [self.view sendSubviewToBack:readView];
        [self.view bringSubviewToFront:detailsView];
    }
    if (sender.tag == 3) {
        NSLog(@"点击了详情上面的阅读");
        [self.view sendSubviewToBack:detailsView];
        [self.view bringSubviewToFront:readView];
    }
}

@end



