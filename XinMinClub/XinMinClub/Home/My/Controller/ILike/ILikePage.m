//
//  ILikePage.m
//  XinMinClub
//
//  Created by Jason_zzzz on 16/3/25.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "ILikePage.h"
#import "UINavigationBar+Awesome.h"
#import "ILikeSection.h"
#import "ILikeAuthor.h"
#import "ILikeBook.h"

#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height) // 屏幕高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width) // 屏幕宽度

@interface ILikePage () <ILikeAuthorDelegate> {
    NSArray *titleArr_;
    ILikeSection *iLikeSection_;
    ILikeAuthor *iLikeAuthor_;
    ILikeBook *iLikeBook_;
    
    NSInteger sectionsNum;
    NSInteger authorNum;
    NSInteger bookNum;
}

@end

@implementation ILikePage

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
    sectionsNum = 15;
    authorNum = 6;
    bookNum = 15;
    NSString *section = [NSString stringWithFormat:@"%@", @"章节"];///%@",[NSNumber numberWithInteger:sectionsNum]];
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
    
    self.title = @"我喜欢";
    
    self.menuItemWidth = SCREEN_WIDTH / 3;
    if (titleArr_.count == 2) {
        self.menuItemWidth = LINE_WIDTH;
    }
    self.menuBGColor = [UIColor whiteColor];
    self.pageAnimatable = YES;
    self.titleSizeSelected = 14;
    self.titleSizeNormal = 14;
    self.titleColorNormal = [UIColor colorWithWhite:0.836 alpha:1.000];
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
    [self.navigationController pushViewController:iLikeSection_ animated:YES];
}

#pragma mark - WMPageController DataSource

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.titles.count;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return self.titles[index];
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    
    if (index == 1) {
        //
        if (!iLikeSection_) {
            iLikeSection_ = [[ILikeSection alloc] initWithStyle:UITableViewStyleGrouped];
            iLikeSection_.sectionNum = sectionsNum;
        }
        return iLikeSection_;
    } else if (index == 0) {
        if (titleArr_.count == 2) {
            if (!iLikeBook_) {
                iLikeBook_ = [[ILikeBook alloc] initWithStyle:UITableViewStyleGrouped];
                iLikeBook_.bookNum = bookNum;
//                iLikeBook_.delegate = self;
            }
            return iLikeBook_;
        }
        if (!iLikeAuthor_) {
            iLikeAuthor_ = [[ILikeAuthor alloc] initWithStyle:UITableViewStyleGrouped];
            iLikeAuthor_.authorNum = authorNum;
            iLikeAuthor_.delegate = self;
        }
        return iLikeAuthor_;
    }
    if (!iLikeBook_) {
        iLikeBook_ = [[ILikeBook alloc] initWithStyle:UITableViewStyleGrouped];
        iLikeBook_.bookNum = bookNum;
//        iLikeBook_.delegate = self;
    }
    
    return iLikeBook_;
}


@end
