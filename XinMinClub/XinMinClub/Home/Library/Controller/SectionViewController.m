//
//  SectionViewController.m
//  XinMinClub
//
//  Created by 杨科军 on 2016/12/20.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "SectionViewController.h"
#import "chapterView.h"
#import "detailsView.h"
#import "readView.h"

#define backButtonViewHeight (([UIScreen mainScreen].bounds.size.height)/18)

@interface SectionViewController (){
    NSDictionary *bookJson;
    NSMutableDictionary *but_dict2;
    CGFloat lastFrame_y;   // 保存上一次详情菜单的y坐标
    CGFloat lastFrame_zy;  // 保存上一次章节菜单的y坐标
    CGFloat last_a;  // 保存上一次详情navigationBar透明度
    CGFloat last_za; // 保存上一次章节navigationBar透明度
    
    UIBarButtonItem *leftButtonItem;
    UIBarButtonItem *rightButtonItem;
    
    BOOL isReadView;  // 判断当前顶部视图是否为阅读
}

@property(nonatomic,strong) UIView *backButtonView;
@property(nonatomic,strong) UIImageView *bookImageView;
@property(nonatomic,strong) chapterView *chapterView;
@property(nonatomic,strong) detailsView *detailsView;
@property(nonatomic,strong) readView *readView;

@end

@implementation SectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    lastFrame_y = SCREEN_HEIGHT/3;
    lastFrame_zy = SCREEN_HEIGHT/3;
    last_a = 0;
    last_za = 0;
    isReadView = NO;
    
    // 设置navigationBar背景透明
    [self kj_setNavigationBar];
    
    [self initView];
    [self.view addSubview:self.readView];
    [self.view addSubview:self.backButtonView];
    [self.view addSubview:self.bookImageView];
    [self.view addSubview:self.detailsView];
    [self.view addSubview:self.chapterView];
}

#pragma mark 视图控制器将要显示
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // KVO观察滚动距离
    [_chapterView addObserver:self forKeyPath:@"chapterScroll" options:NSKeyValueObservingOptionNew context:nil];
    [_detailsView addObserver:self forKeyPath:@"detailsScroll" options:NSKeyValueObservingOptionNew context:nil];
    
    // 设置navigationBar背景透明
    [self kj_setNavigationBar];
    
    self.navigationController.navigationBar.frame = CGRectMake(0, 20, SCREEN_WIDTH, 44);
    
    if (isReadView) {
        [self upOrDownIsTop:YES lastN:0.0];
    }else{
        self.backButtonView.frame = CGRectMake(0, lastFrame_zy, SCREEN_WIDTH, backButtonViewHeight);
        self.chapterView.frame = CGRectMake(0, lastFrame_zy+backButtonViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT-64);
        if (last_za>=1) {
            [self.navigationController.navigationBar lt_reset];// 清除设置的navigationBar的属性
            self.backButtonView.frame = CGRectMake(0, 64, SCREEN_WIDTH, backButtonViewHeight);
            self.chapterView.frame = CGRectMake(0, 64+backButtonViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT-64);
            return;
        }
        [self upOrDownIsTop:NO lastN:last_za];
    }
    
}

#pragma mark 视图控制器将要结束显示
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // 只修改这个navigationBar的样式和颜色
    [self.navigationController.navigationBar lt_reset];// 清除设置的navigationBar的属性
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    // 移除键值监听
    [_chapterView removeObserver:self forKeyPath:@"chapterScroll" context:nil];
    [_detailsView removeObserver:self forKeyPath:@"detailsScroll" context:nil];
    
    self.navigationController.navigationBar.frame = CGRectMake(0, 20, SCREEN_WIDTH, 44);
    
    _detailsView.kj_backView.hidden = YES;
}

- (void)dealloc {
    [USER_DATA_MODEL removeObserver:_detailsView forKeyPath:@"comment"];
}

#pragma maek 设置navigationBar透明
- (void)kj_setNavigationBar{
    // 设置navigationBar背景透明
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
}

#pragma mark 上一级传入的数据
- (void)getJsonData:(NSDictionary*)json {
    bookJson = json;
    self.title = [json valueForKey:@"WJ_NAME"]; // 书集名字
    NSString *imageUrlstring = [NSString stringWithFormat:@"%@%@",IP,[json valueForKey:@"WJ_IMG"]];
    NSURL *url = [NSURL URLWithString:imageUrlstring];
    [self.bookImageView sd_setImageWithURL:url placeholderImage:cachePicture_375x222];
    
    // 保存数据在datamodel
    [DataModel defaultDataModel].bookName = self.title;
    [DataModel defaultDataModel].bookFMImageUrl = [IP stringByAppendingString:[json valueForKey:@"WJ_FM"]]; // 书集封面Url
    //    [DataModel defaultDataModel].bookZuozheImageUrl = [IP stringByAppendingString:[json valueForKey:@"WJ_TITLE_IMG"]];; // 作者头像Url
    
    //    NSLog(@"%@---%@",[DataModel defaultDataModel].bookFMImageUrl,[DataModel defaultDataModel].bookZuozheImageUrl);
    
    self.detailsView.bookID = [json valueForKey:@"WJ_ID"];
    [self.detailsView giveMeJson:json];
    
    [[LoadAnimation defaultDataModel] startLoadAnimation];
    // 获取章节列表
    NSDictionary *dict = @{@"GJ_WJ_ID":[json valueForKey:@"WJ_ID"]};
    NSString *paramString = [networkSection getParamStringWithParam:@{@"FunName":@"Get_WJ_ZJ_TYPE", @"Params":dict}];
    [networkSection getRequestDataBlock:IPUrl :paramString block:^(NSDictionary *jsonDict) {
        //        NSLog(@"Get_WJ_ZJ_TYPE:%@",jsonDict);
        
        // 主线程执行
        dispatch_async(dispatch_get_main_queue(), ^{
            [[LoadAnimation defaultDataModel] endLoadAnimation];
            NSArray *typeArray = [[[jsonDict valueForKey:@"RET"] valueForKey:@"DATA"] componentsSeparatedByString:@","];//分割数组当中的内容
            NSString *bookid = [json valueForKey:@"WJ_ID"];
            // 传递数据
            self.chapterView.bookID = bookid;
            [self.chapterView gettype:typeArray];
            self.readView.bookID = bookid;
            self.readView.typeArray = typeArray;
        });
    }];
}

#pragma mark 视图区
- (void)initView{
    // 右侧消息按钮
//    UIImage *rightImage = [[UIImage imageNamed:@"jiarushuji"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    rightButtonItem = [[UIBarButtonItem alloc] init];
    [rightButtonItem setTarget:self];
    [rightButtonItem setAction:@selector(rightAction)];
//                       initWithImage:rightImage style:UIBarButtonItemStyleDone target:self action:@selector(rightAction)];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    // 左侧按钮
//    UIImage *leftImage = [UIImage imageNamed:@"daididefanhui"];
    leftButtonItem = [[UIBarButtonItem alloc] init];
    [leftButtonItem setTarget:self];
    [leftButtonItem setAction:@selector(leftAction)];
//                      WithImage:leftImage style:UIBarButtonItemStyleDone target:self action:@selector(leftAction)];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
//    [rightButtonItem setTintColor:[UIColor colorWithWhite:0.1 alpha:0.5]];
//    [leftButtonItem setTintColor:[UIColor colorWithWhite:0.1 alpha:0.5]];
}

- (UIImageView*)bookImageView{
    if (!_bookImageView) {
        _bookImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT/3)];
        _bookImageView.userInteractionEnabled = NO;
    }
    return _bookImageView;
}

- (UIView*)backButtonView{
    if (!_backButtonView) {
        _backButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, lastFrame_y, SCREEN_WIDTH, backButtonViewHeight)];
        NSArray *rushidaoArr = @[@"章节",@"详情",@"阅读"];
        but_dict2 = [NSMutableDictionary dictionary]; // 初始化存储button的字典
        for (int a = 0; a<3; a++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(SCREEN_WIDTH/3*a, 0, SCREEN_WIDTH/3, backButtonViewHeight);
            button.tag = a;
            [self aaa:button butTag:button.tag];
            button.backgroundColor = RGB255_COLOR(238, 238, 238, 1);
            [button setTitleColor:RGB255_COLOR(1, 0, 0, 1) forState:UIControlStateNormal];
            if (a==0) {
                [button setTitleColor:RGB255_COLOR(219, 145, 39, 1) forState:UIControlStateNormal];
            }
            [button setTitle:rushidaoArr[a] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(menusButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [_backButtonView addSubview:button];
        }
    }
    return _backButtonView;
}

- (chapterView*)chapterView{
    if (!_chapterView) {
        _chapterView = [[chapterView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT/3+backButtonViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT-backButtonViewHeight-64)];
        //        // KVO观察滚动距离
        //        [_chapterView addObserver:self forKeyPath:@"chapterScroll" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _chapterView;
}

- (detailsView*)detailsView{
    if (!_detailsView) {
        _detailsView = [[detailsView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT/3+backButtonViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT-backButtonViewHeight-64)];
        [_detailsView setHidden:YES];
        //        // KVO观察滚动距离
        //        [_detailsView addObserver:self forKeyPath:@"detailsScroll" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _detailsView;
}

- (readView*)readView{
    if (!_readView) {
        _readView = [[readView alloc]initWithFrame:CGRectMake(0, backButtonViewHeight+64, SCREEN_WIDTH, SCREEN_HEIGHT-backButtonViewHeight-64)];
        [_readView setHidden:YES];
    }
    return _readView;
}


#pragma mark 功能区
- (void)leftAction{
    // 清除设置的navigationBar的属性
    [self.navigationController.navigationBar lt_reset];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightAction{
    if ([DataModel defaultDataModel].isVisitorLoad) {
        [[DataModel defaultDataModel] pushLoadViewController];
        return;
    }
    if ([DATA_MODEL addMyLibrary:bookJson]) {
        // 提示成功
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD show];
        [self performSelector:@selector(success) withObject:nil afterDelay:0.6f];
    }else{
        // 提示已经有了
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD show];
        [self performSelector:@selector(success11) withObject:nil afterDelay:0.2f];
    }
}
- (void)success {
    [SVProgressHUD showSuccessWithStatus:@"加入文集成功!"];
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.5f];
}
- (void)success11 {
    [SVProgressHUD showSuccessWithStatus:@"文集已存在"];
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.5f];
}
- (void)dismiss {
    [SVProgressHUD dismiss];
}

#pragma mark 菜单Button各种事件方法
- (void)aaa:(UIButton*)but butTag:(NSInteger)butag{
    NSString *s = [NSString stringWithFormat:@"%ld",(long)butag];
    [but_dict2 addEntriesFromDictionary:@{s:but}];
}
- (IBAction)menusButtonAction:(UIButton*)sender{
    [self abcdTag:sender.tag];
}

- (void)abcdTag:(NSInteger)tag{
    for (int x=0; x<3; x++) {
        if (tag==x) {
            [[but_dict2 valueForKey:[NSString stringWithFormat:@"%d",x]] setTitleColor:RGB255_COLOR(219, 145, 39, 1) forState:UIControlStateNormal];
        }else{
            [[but_dict2 valueForKey:[NSString stringWithFormat:@"%d",x]] setTitleColor:RGB255_COLOR(1, 0, 0, 1) forState:UIControlStateNormal];
        }
    }
    if (tag==0) {
        isReadView = NO;
        _readView.isTopView = NO;
        _detailsView.isTopView = NO;
        [_readView setHidden:YES];
        [_detailsView setHidden:YES];
        [_chapterView setHidden:NO];
        self.backButtonView.frame = CGRectMake(0, lastFrame_zy, SCREEN_WIDTH, backButtonViewHeight);
        self.chapterView.frame = CGRectMake(0, lastFrame_zy+backButtonViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT-64);
        if (last_za>=1) {
            [self.navigationController.navigationBar lt_reset];// 清除设置的navigationBar的属性
            self.backButtonView.frame = CGRectMake(0, 64, SCREEN_WIDTH, backButtonViewHeight);
            self.chapterView.frame = CGRectMake(0, 64+backButtonViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT-64);
            return;
        }
        [self upOrDownIsTop:NO lastN:last_za];
    }
    else if (tag==1) {
        isReadView = NO;
        _readView.isTopView = NO;
        _detailsView.isTopView = YES;
        [_readView setHidden:YES];
        [_detailsView setHidden:NO];
        [_chapterView setHidden:YES];
        self.backButtonView.frame = CGRectMake(0, lastFrame_y, SCREEN_WIDTH, backButtonViewHeight);
        self.detailsView.frame = CGRectMake(0, lastFrame_y+backButtonViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT-64);
        if (last_a>=1) {
            [self.navigationController.navigationBar lt_reset];// 清除设置的navigationBar的属性
            self.backButtonView.frame = CGRectMake(0, 64, SCREEN_WIDTH, backButtonViewHeight);
            self.detailsView.frame = CGRectMake(0, 64+backButtonViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT-64);
            return;
        }
        [self upOrDownIsTop:NO lastN:last_a];
    }
    else{
        isReadView = YES;
        _readView.isTopView = YES;
        _detailsView.isTopView = NO;
        [_readView setHidden:NO];
        [_detailsView setHidden:YES];
        [_chapterView setHidden:YES];
        self.backButtonView.frame = CGRectMake(0, 64, SCREEN_WIDTH, backButtonViewHeight);
        self.navigationController.navigationBar.frame = CGRectMake(0, 0, SCREEN_WIDTH, 64);
        if (_readView.bounds.origin.y!=backButtonViewHeight+64) {
            _readView.frame = CGRectMake(0, backButtonViewHeight+44, SCREEN_WIDTH, SCREEN_HEIGHT-backButtonViewHeight-64);
        }
        [self.view bringSubviewToFront:self.readView];
        [self upOrDownIsTop:YES lastN:0.0];
    }
    
    
}

#pragma mark 上下滚动的时候，改变的一些东西
- (void)upOrDownIsTop:(BOOL)top lastN:(CGFloat)lasta{
    [self.view bringSubviewToFront:self.backButtonView];
    //    self.navigationController.navigationBar.frame = CGRectMake(0, 0, SCREEN_WIDTH, 64);
    if (top) {
        // 到顶了
        UIImage *im1 = [[UIImage imageNamed:@"daididefanhui2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *im2 = [[UIImage imageNamed:@"jiarushuji2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [leftButtonItem setImage:im1];
        [rightButtonItem setImage:im2];
        [self.navigationController.navigationBar lt_reset];// 清除设置的navigationBar的属性
        self.backButtonView.frame = CGRectMake(0, 64, SCREEN_WIDTH, backButtonViewHeight);
        self.navigationController.navigationBar.frame = CGRectMake(0, 20, SCREEN_WIDTH, 44);
    }
    else{
        UIImage *im1 = [[UIImage imageNamed:@"daididefanhui"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *im2 = [[UIImage imageNamed:@"jiarushuji"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [leftButtonItem setImage:im1];
        [rightButtonItem setImage:im2];
        // 设置navigationBar背景透明
        [self kj_setNavigationBar];
        self.navigationController.navigationBar.frame = CGRectMake(0, 0, SCREEN_WIDTH, 64);
//        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Navigation_BackgroundImage"] forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.backgroundColor = RGB255_COLOR(219, 145, 39, lasta);
    }
}

#pragma mark - KVO 观察者监听方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"chapterScroll"]) {
        last_za = (SCREEN_HEIGHT/3 - _chapterView.chapterScroll)/(SCREEN_HEIGHT/3);
        last_za = 1 - last_za + 0.3;
        if (_chapterView.chapterScroll>=SCREEN_HEIGHT/3-64) {
            self.chapterView.frame = CGRectMake(0, 64+backButtonViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT);
            [self upOrDownIsTop:YES lastN:0];
        }else if (_chapterView.chapterScroll<=0){
            [self upOrDownIsTop:NO lastN:0];
            self.backButtonView.frame = CGRectMake(0, SCREEN_HEIGHT/3-_chapterView.chapterScroll, SCREEN_WIDTH, backButtonViewHeight);
            self.chapterView.frame = CGRectMake(0, SCREEN_HEIGHT/3-_chapterView.chapterScroll+backButtonViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT-64);
            self.bookImageView.frame = CGRectMake(_chapterView.chapterScroll/2, 0, SCREEN_WIDTH-_chapterView.chapterScroll, SCREEN_HEIGHT/3-_chapterView.chapterScroll);
        }
        else{
            [self upOrDownIsTop:NO lastN:last_za];
            lastFrame_zy = SCREEN_HEIGHT/3-_chapterView.chapterScroll;
            self.backButtonView.frame = CGRectMake(0, lastFrame_zy, SCREEN_WIDTH, backButtonViewHeight);
            self.chapterView.frame = CGRectMake(0, lastFrame_zy+backButtonViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT-64);
        }
        
        
    }else if ([keyPath isEqualToString:@"detailsScroll"]) {
        last_a = (SCREEN_HEIGHT/3 - _detailsView.detailsScroll)/(SCREEN_HEIGHT/3);
        last_a = 1.3 - last_a;
        if (_detailsView.detailsScroll>=SCREEN_HEIGHT/3-64) {
            self.detailsView.frame = CGRectMake(0, 64+backButtonViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT);
            [self upOrDownIsTop:YES lastN:0];
        }else if (_detailsView.detailsScroll<=0){
            [self upOrDownIsTop:NO lastN:0];
            self.backButtonView.frame = CGRectMake(0, SCREEN_HEIGHT/3-_detailsView.detailsScroll, SCREEN_WIDTH, backButtonViewHeight);
            self.detailsView.frame = CGRectMake(0, SCREEN_HEIGHT/3-_detailsView.detailsScroll+backButtonViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT-64);
            self.bookImageView.frame = CGRectMake(_detailsView.detailsScroll/2, 0, SCREEN_WIDTH-_detailsView.detailsScroll, SCREEN_HEIGHT/3-_detailsView.detailsScroll);
        }
        else{
            [self upOrDownIsTop:NO lastN:last_a];
            lastFrame_y = SCREEN_HEIGHT/3-_detailsView.detailsScroll;
            self.backButtonView.frame = CGRectMake(0, lastFrame_y, SCREEN_WIDTH, backButtonViewHeight);
            self.detailsView.frame = CGRectMake(0, lastFrame_y+backButtonViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT);
        }
        
    }
}

@end
