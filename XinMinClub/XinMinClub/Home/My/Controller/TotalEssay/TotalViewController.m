//
//  TotalViewController.m
//  XinMinClub
//
//  Created by Jason_zzzz on 16/3/25.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "TotalViewController.h"
#import "UINavigationBar+Awesome.h"
#import "TotalTableViewController.h"
#import "AuthorTableViewController.h"
#import "EssayTableViewController.h"
#import "DataModel.h"

#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height) // 屏幕高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width) // 屏幕宽度

@interface TotalViewController () <AuthorDelegate, EssayDelegate> {
    NSArray *titleArr_;
    TotalTableViewController *totalTVC_;
    AuthorTableViewController *authorTVC_;
    EssayTableViewController *essayTVC_;
    
    DataModel *dataModel_;
    
    NSInteger sectionsNum;
    NSInteger authorNum;
    NSInteger bookNum;
}

@end

@implementation TotalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置navigationBar背景透明
//    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"IMG_1960.jpg"]]];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (id)init {
    
    self.menuViewStyle = WMMenuViewStyleLine;
    
    dataModel_ = [DataModel defaultDataModel];
    sectionsNum = dataModel_.allSection.count;
    authorNum = dataModel_.allSection.count;
    bookNum = dataModel_.allSection.count;
    NSString *section = [NSString stringWithFormat:@"%@", @"文章"];//%@",[NSNumber numberWithInteger:sectionsNum]];
    NSString *author = nil;//[NSString stringWithFormat:@"作者"];///%@",[NSNumber numberWithInteger:authorNum]];
    NSString *book = [NSString stringWithFormat:@"%@", @"文集"];///%@",[NSNumber numberWithInteger:bookNum]];
    titleArr_ = @[book,section];
    if (author) {
        titleArr_ = @[book,author,section];
    }
    if (self = [super init]) {
        [self initView];
    }
    return self;
}

// 返回标题
- (NSArray<NSString *> *)titles {
    return titleArr_;
}

- (void)initView {
    
//    self.view.backgroundColor = [UIColor whiteColor];
    
    self.menuItemWidth = SCREEN_WIDTH / 3;
    if (titleArr_.count == 2) {
        self.menuItemWidth = LINE_WIDTH;
    }
    self.menuBGColor = [UIColor whiteColor];
    self.pageAnimatable = YES;
    self.titleSizeSelected = 14;
    self.titleSizeNormal = 14;
    self.titleColorNormal = [UIColor colorWithWhite:0.004 alpha:1.000];
    self.titleColorSelected = [UIColor colorWithRed:0.831 green:0.255 blue:0.251 alpha:1.000];
    
    // 返回按钮
    [self setNavigationBarBackButton:nil withText:@""];
    // 右侧消息按钮
//    UIImage *rightImage = [[UIImage imageNamed:@"actionIconAdd"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithImage:rightImage style:UIBarButtonItemStylePlain target:self action:nil];
//    self.navigationItem.rightBarButtonItem = rightButtonItem;
}


- (void)setNavigationBarBackButton:(UIImage *)image withText:(NSString *)text {
    if ([text isEqualToString:@""]) {
        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
    } else {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:text style:UIBarButtonItemStylePlain target:nil action:nil];
        self.navigationItem.backBarButtonItem = item;
    }
    UIImage *backButtonImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 30, 0, 0)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
}

#pragma mark AuthorDelegate

- (void)popEssayList {
    if (!totalTVC_) {
        totalTVC_ = [[TotalTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    }
    [self.navigationController pushViewController:totalTVC_ animated:YES];
}

#pragma mark - WMPageController DataSource

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.titles.count;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return self.titles[index];
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    
    if (index == 0) {
        //
        if (!essayTVC_) {
            essayTVC_ = [[EssayTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            essayTVC_.bookNum = bookNum;
            essayTVC_.delegate = self;
        }
    } else if (index == 1) {
        if (titleArr_.count == 2) {
            if (!totalTVC_) {
                totalTVC_ = [[TotalTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
                totalTVC_.sectionNum = sectionsNum;
            }
            return totalTVC_;
            return essayTVC_;
        }
        if (!authorTVC_) {
            authorTVC_ = [[AuthorTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            authorTVC_.authorNum = authorNum;
            authorTVC_.delegate = self;
        }
        return authorTVC_;
    }
    if (!essayTVC_) {
        essayTVC_ = [[EssayTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        essayTVC_.bookNum = bookNum;
        essayTVC_.delegate = self;
    }
    return essayTVC_;
}


@end
