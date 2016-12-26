//
//  LocalPage.m
//  XinMinClub
//
//  Created by 赵劲松 on 16/4/4.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "LocalPage.h"
#import "UINavigationBar+Awesome.h"
#import "DataModel.h"
#import "LocalSection.h"
#import "LocalAuthor.h"
#import "LocalBook.h"

#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height) // 屏幕高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width) // 屏幕宽度

@interface LocalPage () <LocalAuthorDelegate, LocalEssayDelegate> {
    NSArray *titleArr_;
    LocalSection *localSection_;
    LocalAuthor *localAuthor;
    LocalBook *localBook_;
    
    DataModel *dataModel_;
    
    NSInteger sectionsNum;
    NSInteger authorNum;
    NSInteger bookNum;
}

@end

@implementation LocalPage

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
    NSString *section = [NSString stringWithFormat:@"%@",@"章节"];//%@",[NSNumber numberWithInteger:sectionsNum]];
    NSString *author = nil;//[NSString stringWithFormat:@"作者"];//%@",[NSNumber numberWithInteger:authorNum]];
    NSString *book = [NSString stringWithFormat:@"%@", @"文章"];//%@",[NSNumber numberWithInteger:bookNum]];
    titleArr_ = @[book,section];
    if (author) {
        titleArr_ = @[section,author,book];
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
    UIImage *rightImage = [[UIImage imageNamed:@"actionIconAdd"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithImage:rightImage style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
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
    if (!localSection_) {
        localSection_ = [[LocalSection alloc] initWithStyle:UITableViewStyleGrouped];
    }
    [self.navigationController pushViewController:localSection_ animated:YES];
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
        if (!localBook_) {
            localBook_ = [[LocalBook alloc] initWithStyle:UITableViewStyleGrouped];
            localBook_.localBook = bookNum;
            localBook_.delegate = self;
        }
        return localBook_;
    } else if (index == 1) {
        if (titleArr_.count == 2) {
            if (!localSection_) {
                localSection_ = [[LocalSection alloc] initWithStyle:UITableViewStyleGrouped];
                localSection_.localSection = sectionsNum;
            }
            return localSection_;
        }
        if (!localAuthor) {
            localAuthor = [[LocalAuthor alloc] initWithStyle:UITableViewStyleGrouped];
            localAuthor.localAuthor = authorNum;
            localAuthor.delegate = self;
        }
        return localAuthor;
    }
    if (!localBook_) {
        localBook_ = [[LocalBook alloc] initWithStyle:UITableViewStyleGrouped];
        localBook_.localBook = bookNum;
        localBook_.delegate = self;
    }
    
    return localBook_;
}


@end
