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
    
    // 设置navigationBar背景透明
    [self kj_setNavigationBar];
    // KVO观察滚动距离
    [_chapterView addObserver:self forKeyPath:@"chapterScroll" options:NSKeyValueObservingOptionNew context:nil];
    [_detailsView addObserver:self forKeyPath:@"detailsScroll" options:NSKeyValueObservingOptionNew context:nil];
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
#warning aakk  json
    NSLog(@"json:%@",json);
    //    kj_svc.libraryAuthorImageUrl = [IP stringByAppendingString:[dica valueForKey:@"WJ_TITLE_IMG"]];
    // 保存数据到“我的”里面
    [[DataModel defaultDataModel] addAllLibrary:[json valueForKey:@"WJ_ID"] ImageUrl:[IP stringByAppendingString:[json valueForKey:@"WJ_IMG"]] BookName:[json valueForKey:@"WJ_NAME"] AuthorName:[json valueForKey:@"WJ_USER"] Type:[json valueForKey:@"WJ_TYPE"] Language:[json valueForKey:@"WJ_LANGUAGE"] Detail:[json valueForKey:@"WJ_CONTENT"]];
    NSString *imageUrlstring = [IP stringByAppendingString:[json valueForKey:@"WJ_IMG"]];
    NSURL *url = [NSURL URLWithString:imageUrlstring];
    [self.bookImageView sd_setImageWithURL:url placeholderImage:cachePicture];

    // 获取章节列表
    NSDictionary *dict = @{@"GJ_WJ_ID":[json valueForKey:@"WJ_ID"]};
    NSString *paramString = [networkSection getParamStringWithParam:@{@"FunName":@"Get_WJ_ZJ_TYPE", @"Params":dict}];
    [networkSection getRequestDataBlock:IPUrl :paramString block:^(NSDictionary *jsonDict) {
//        NSLog(@"Get_WJ_ZJ_TYPE:%@",jsonDict);
        
        // 主线程执行
        dispatch_async(dispatch_get_main_queue(), ^{
            NSArray *typeArray = [[[jsonDict valueForKey:@"RET"] valueForKey:@"DATA"] componentsSeparatedByString:@","];//分割数组当中的内容
            NSString *bookid = [json valueForKey:@"WJ_ID"];
            // 传递数据
            self.chapterView.bookID = bookid;
            [self.chapterView gettype:typeArray];
            self.detailsView.bookID = bookid;
            [self.detailsView giveMeJson:json];
            self.readView.bookID = bookid;
            self.readView.typeArray = typeArray;
        });
        
    }];
}

#pragma mark 视图区
- (void)initView{
    // 右侧消息按钮
    UIImage *rightImage = [[UIImage imageNamed:@"Join_the_corpus"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithImage:rightImage style:UIBarButtonItemStylePlain target:self action:@selector(rightAction)];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    // 左侧按钮
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(leftAction)];
    leftButtonItem.image = [UIImage imageNamed:@"daididefanhui"];
    //    leftButtonItem.imageInsets = UIEdgeInsetsMake(10, 10, 10, -15);
    self.navigationItem.leftBarButtonItem = leftButtonItem;
}

- (UIImageView*)bookImageView{
    if (!_bookImageView) {
        _bookImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT/3)];
    }
    return _bookImageView;
}

- (UIView*)backButtonView{
    if (!_backButtonView) {
        _backButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, lastFrame_y, SCREEN_WIDTH, backButtonViewHeight)];
        _backButtonView.backgroundColor = [UIColor redColor];
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
//        // KVO观察滚动距离
//        [_detailsView addObserver:self forKeyPath:@"detailsScroll" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _detailsView;
}

- (readView*)readView{
    if (!_readView) {
        _readView = [[readView alloc]initWithFrame:CGRectMake(0, backButtonViewHeight+64, SCREEN_WIDTH, SCREEN_HEIGHT-backButtonViewHeight-64)];
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
//    if ([[DataModel defaultDataModel] addMyLibrary:_libraryNum ImageUrl:_libraryImageUrl BookName:_libraryTitle AuthorName:_libraryAuthorName Type:(NSString *)_libraryType Language:(NSString *)_libraryLanguage Detail:(NSString *)_libraryDetails]) {
//        // 提示成功
//        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
//        [SVProgressHUD show];
//        [self performSelector:@selector(success) withObject:nil afterDelay:0.6f];
//    }else{
//        // 提示已经有了
//        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
//        [SVProgressHUD show];
//        [self performSelector:@selector(success11) withObject:nil afterDelay:0.6f];
//    }
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

- (void)abcdTag:(int)tag{
    for (int x=0; x<3; x++) {
        if (tag==x) {
            [[but_dict2 valueForKey:[NSString stringWithFormat:@"%d",x]] setTitleColor:RGB255_COLOR(219, 145, 39, 1) forState:UIControlStateNormal];
        }else{
            [[but_dict2 valueForKey:[NSString stringWithFormat:@"%d",x]] setTitleColor:RGB255_COLOR(1, 0, 0, 1) forState:UIControlStateNormal];
        }
    }
    if (tag==0) {
        _readView.isTopView = NO;
        _detailsView.isTopView = NO;
        [self.view bringSubviewToFront:self.chapterView];
        [self.view bringSubviewToFront:self.backButtonView];
        [self.view sendSubviewToBack:self.readView];
        [self.view sendSubviewToBack:self.detailsView];
        self.backButtonView.frame = CGRectMake(0, lastFrame_zy, SCREEN_WIDTH, backButtonViewHeight);
        self.chapterView.frame = CGRectMake(0, lastFrame_zy+backButtonViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT-64);
        if (last_za>=1) {
            [self.navigationController.navigationBar lt_reset];// 清除设置的navigationBar的属性
            self.backButtonView.frame = CGRectMake(0, 64, SCREEN_WIDTH, backButtonViewHeight);
            self.chapterView.frame = CGRectMake(0, 64+backButtonViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT-64);
            return;
        }
        // 设置navigationBar背景透明
        [self kj_setNavigationBar];
        self.navigationController.navigationBar.backgroundColor = RGB255_COLOR(219, 145, 39, last_za);
    }
    else if (tag==1) {
        _readView.isTopView = NO;
        _detailsView.isTopView = YES;
        [self.view bringSubviewToFront:self.detailsView];
        [self.view bringSubviewToFront:self.backButtonView];
        [self.view sendSubviewToBack:self.readView];
        [self.view sendSubviewToBack:self.chapterView];
        self.backButtonView.frame = CGRectMake(0, lastFrame_y, SCREEN_WIDTH, backButtonViewHeight);
        self.detailsView.frame = CGRectMake(0, lastFrame_y+backButtonViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT-64);
        if (last_a>=1) {
            [self.navigationController.navigationBar lt_reset];// 清除设置的navigationBar的属性
            self.backButtonView.frame = CGRectMake(0, 64, SCREEN_WIDTH, backButtonViewHeight);
            self.detailsView.frame = CGRectMake(0, 64+backButtonViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT-64);
            return;
        }
        // 设置navigationBar背景透明
        [self kj_setNavigationBar];
        self.navigationController.navigationBar.backgroundColor = RGB255_COLOR(219, 145, 39, last_a);
    }
    else{
        _readView.isTopView = YES;
        _detailsView.isTopView = NO;
        self.backButtonView.frame = CGRectMake(0, 64, SCREEN_WIDTH, backButtonViewHeight);
        [self.view bringSubviewToFront:self.readView];
        [self.view bringSubviewToFront:self.backButtonView];
        [self.navigationController.navigationBar lt_reset];// 清除设置的navigationBar的属性
    }
    
    
}

#pragma mark - KVO 观察者监听方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"chapterScroll"]) {
        last_za = (SCREEN_HEIGHT/3 - _chapterView.chapterScroll)/(SCREEN_HEIGHT/3);
        last_za = 1 - last_za + 0.3;
        if (_chapterView.chapterScroll>=SCREEN_HEIGHT/3-64) {
            [self.navigationController.navigationBar lt_reset];// 清除设置的navigationBar的属性
            self.backButtonView.frame = CGRectMake(0, 64, SCREEN_WIDTH, backButtonViewHeight);
            self.chapterView.frame = CGRectMake(0, 64+backButtonViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT);
        }else if (_chapterView.chapterScroll<=0){
            [self.view bringSubviewToFront:self.backButtonView];
            // 设置navigationBar背景透明
            [self kj_setNavigationBar];
            self.navigationController.navigationBar.backgroundColor = RGB255_COLOR(219, 145, 39, 0);
            self.backButtonView.frame = CGRectMake(0, SCREEN_HEIGHT/3-_chapterView.chapterScroll, SCREEN_WIDTH, backButtonViewHeight);
            self.chapterView.frame = CGRectMake(0, SCREEN_HEIGHT/3-_chapterView.chapterScroll+backButtonViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT-64);
            [self.view bringSubviewToFront:self.bookImageView];
            self.bookImageView.frame = CGRectMake(_chapterView.chapterScroll/2, 0, SCREEN_WIDTH-_chapterView.chapterScroll, SCREEN_HEIGHT/3-_chapterView.chapterScroll);
        }
        else{
            [self.view bringSubviewToFront:self.chapterView];
            [self.view bringSubviewToFront:self.backButtonView];
            // 设置navigationBar背景透明
            [self kj_setNavigationBar];
            self.navigationController.navigationBar.backgroundColor = RGB255_COLOR(219, 145, 39, last_za);
            lastFrame_zy = SCREEN_HEIGHT/3-_chapterView.chapterScroll;
            self.backButtonView.frame = CGRectMake(0, lastFrame_zy, SCREEN_WIDTH, backButtonViewHeight);
            self.chapterView.frame = CGRectMake(0, lastFrame_zy+backButtonViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT-64);
        }
        
        
    }else if ([keyPath isEqualToString:@"detailsScroll"]) {
        last_a = (SCREEN_HEIGHT/3 - _detailsView.detailsScroll)/(SCREEN_HEIGHT/3);
        last_a = 1.3 - last_a;
        if (_detailsView.detailsScroll>=SCREEN_HEIGHT/3-64) {
            [self.navigationController.navigationBar lt_reset];// 清除设置的navigationBar的属性
            self.backButtonView.frame = CGRectMake(0, 64, SCREEN_WIDTH, backButtonViewHeight);
            self.detailsView.frame = CGRectMake(0, 64+backButtonViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT);
        }else if (_detailsView.detailsScroll<=0){
            [self.view bringSubviewToFront:self.backButtonView];
            // 设置navigationBar背景透明
            [self kj_setNavigationBar];
            self.navigationController.navigationBar.backgroundColor = RGB255_COLOR(219, 145, 39, 0);
            self.backButtonView.frame = CGRectMake(0, SCREEN_HEIGHT/3-_detailsView.detailsScroll, SCREEN_WIDTH, backButtonViewHeight);
            self.detailsView.frame = CGRectMake(0, SCREEN_HEIGHT/3-_detailsView.detailsScroll+backButtonViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT-64);
            [self.view bringSubviewToFront:self.bookImageView];
            self.bookImageView.frame = CGRectMake(_detailsView.detailsScroll/2, 0, SCREEN_WIDTH-_detailsView.detailsScroll, SCREEN_HEIGHT/3-_detailsView.detailsScroll);
        }
        else{
            [self.view bringSubviewToFront:self.detailsView];
            [self.view bringSubviewToFront:self.backButtonView];
            // 设置navigationBar背景透明
            [self kj_setNavigationBar];
            self.navigationController.navigationBar.backgroundColor = RGB255_COLOR(219, 145, 39, last_a);
            lastFrame_y = SCREEN_HEIGHT/3-_detailsView.detailsScroll;
            self.backButtonView.frame = CGRectMake(0, lastFrame_y, SCREEN_WIDTH, backButtonViewHeight);
            self.detailsView.frame = CGRectMake(0, lastFrame_y+backButtonViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT);
        }
        
    }
}

@end
