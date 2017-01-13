//
//  MyViewController.m
//  XinMinClub
//
//  Created by yangkejun on 16/3/19.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "MyViewController.h"
#import "FirstTableViewCell.h"
#import "SecondTableViewCell.h"
#import "ThirdTableViewCell.h"
#import "MyBookTableViewCell.h"
#import "ForthTableViewCell.h"
#import "UserViewController.h"
#import "TotalViewController.h"
#import "WMPageController.h"
#import "FinishDownload.h"
#import "SVProgressHUD.h"
#import "Downloading.h"
#import "ResentPlay.h"
#import "ILikePage.h"
#import "LocalPage.h"
//#import "DataModel.h"
//#import "UserDataModel.h"
#import "MyBookListController.h"
//#import "KJ_BackTableViewController.h"
#import "TableHeaderRefreshView.h"

#import "SectionViewController.h"

#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height) // 屏幕高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width) // 屏幕宽度

@interface MyViewController () <UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, SecondCellDelegate, RecommendDelegate, FirstDelegate> {
    UITableView *myTableView_;
    ForthTableViewCell *forthCell_;
    UIView *searchView_;
    UIButton *searchButton_;
    UIButton *speechButton_;
//    UserViewController *userController_;
    TotalViewController *totalController_;
    ResentPlay *resentPlay_;
    ILikePage *iLike_;
    WMPageController *pageController;
    WMPageController *downloadPC;
    NSArray *titleArr_;
    DataModel *dataModel_;
    UserDataModel *userModel_;
}

@property (nonatomic, strong) TableHeaderRefreshView *refreshHeaderView;

@end

@implementation MyViewController

static NSString * firstIdentifier = @"first";
static NSString * secondIdentifier = @"second";
static NSString * thirdIdentifier = @"third";
static NSString * forthIdentifier = @"forth";
static NSString * defaultIdentifier = @"cell";

- (id)init {
    dataModel_ = [DataModel defaultDataModel];
    userModel_ = [UserDataModel defaultDataModel];
    if (self = [super init]) {
        [dataModel_ addObserver:self forKeyPath:@"recommandBook" options:NSKeyValueObservingOptionNew context:nil];
        [USER_DATA_MODEL addObserver:self forKeyPath:@"userImage" options:NSKeyValueObservingOptionNew context:nil];
//        [userModel_ getRecommend];
    }
    return self;
}

- (void)dealloc {
    [dataModel_ removeObserver:self forKeyPath:@"recommandBook"];
    [USER_DATA_MODEL removeObserver:self forKeyPath:@"userImage"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    // 初始化刷新view
    self.refreshHeaderView = [[TableHeaderRefreshView alloc] initWithScrollView:myTableView_ hasNavigationBar:NO];
//    [[UserDataModel defaultDataModel] keepSession];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    static int i = 0;
    // 开始刷新
    if (!i) {
        [self.refreshHeaderView doRefresh];
        i = 1;
    }
    __weak __typeof(&*self)weakSelf = self;
    __weak __typeof(&*userModel_)weakUserModel_ = userModel_;
    [self.refreshHeaderView addRefreshingBlock:^{
        // you can do some net request or other refresh operation
        // ...
        [weakUserModel_ getRecommend];
        // here simulate do some refresh operation,and after 3s refresh complate
        double delayTime = 1.0;
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, delayTime * NSEC_PER_SEC);
        dispatch_after(time, dispatch_get_main_queue(), ^{
            [weakSelf.refreshHeaderView stopRefresh];
        });
    }];
    
    if (userModel_.isReload) {
        userModel_.isReload = NO;
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
        [myTableView_ reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
    }
    
    if (userModel_.threePartReload) {
//        userModel_.threePartReload = NO;
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
        [myTableView_ reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
    }
    
    if (dataModel_.addBook){
//        dataModel_.addBook = NO;
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:2];
        [myTableView_ reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
    }
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:1];
    [myTableView_ reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
}

- (void)initView {
//    [self.view addSubview:[self backImage]];
    [self.view addSubview:self.myTableView];
//    [myTableView_ setBackgroundView:[self backImage]];
//    userController_ = [[UserViewController alloc] init];
    
    UINib *nib = [UINib nibWithNibName:@"FirstTableViewCell" bundle:nil];
    [myTableView_ registerNib:nib forCellReuseIdentifier:firstIdentifier];
    nib = [UINib nibWithNibName:@"SecondTableViewCell" bundle:nil];
    [myTableView_ registerNib:nib forCellReuseIdentifier:secondIdentifier];
    nib = [UINib nibWithNibName:@"ThirdTableViewCell" bundle:nil];
    [myTableView_ registerNib:nib forCellReuseIdentifier:thirdIdentifier];
    nib = [UINib nibWithNibName:@"ForthTableViewCell" bundle:nil];
    [myTableView_ registerNib:nib forCellReuseIdentifier:forthIdentifier];
    // 去白带
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)initDataWithArr: (NSArray *)array {
    titleArr_ = [array copy];
}

- (UIImageView *)backImage {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Thebackgroundofpersonal"]];
    imageView.frame = CGRectMake(0, -64, SCREEN_WIDTH, SCREEN_HEIGHT);
    return imageView;
}

- (UITableView *)myTableView {
    if (!myTableView_) {
        myTableView_ = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 103) style:UITableViewStyleGrouped];
        myTableView_.dataSource = self;
        myTableView_.delegate = self;
        myTableView_.separatorStyle = NO;
    }
    myTableView_.backgroundColor = [UIColor colorWithWhite:0.953 alpha:1.000];
    myTableView_.tableHeaderView = [self searchView];
//    searchView_.backgroundColor = [UIColor clearColor];
    return myTableView_;
}

- (UIView *)searchView {
    if (!searchView_) {
        searchView_ = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 8/*55*/)];
    }
    searchView_.backgroundColor = [UIColor colorWithWhite:0.953 alpha:1.000];
//    [searchView_ addSubview:self.searchButton];
//    [searchView_ addSubview:self.speechButton];
    searchView_.center = searchButton_.center;
    return searchView_;
}

- (UIButton *)searchButton {
    if (!searchButton_) {
        searchButton_ = [UIButton buttonWithType:UIButtonTypeSystem];
        searchButton_.frame = CGRectMake(SCREEN_WIDTH / 30, 10, SCREEN_WIDTH / 30 * 28, 35);
        [searchButton_ setTitle:@"🔍搜索" forState:UIControlStateNormal];
        [searchButton_ setTintColor:[UIColor colorWithWhite:0.754 alpha:1.000]];
        searchButton_.backgroundColor = [UIColor whiteColor];
        // 设圆角
        [searchButton_.layer setCornerRadius:4];
        // 是否限制边界，既画圆角
        [searchButton_ setClipsToBounds:YES];
    }
    return searchButton_;
}

- (UIButton *)speechButton {
    if (!speechButton_) {
        speechButton_ = [UIButton buttonWithType:UIButtonTypeCustom];
        speechButton_.frame = CGRectMake(0, 0, 30, 30);
        speechButton_.center = CGPointMake(SCREEN_WIDTH / 30 * 27, searchButton_.center.y);
        [speechButton_ setTitle:@"🐶" forState:UIControlStateNormal];
    }
    return speechButton_;
}

#pragma mark 键值监听

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"recommandBook"]) {
//        forthCell_ = [myTableView_ dequeueReusableCellWithIdentifier:forthIdentifier];
//        if (!forthCell_) {
//            forthCell_ = [[ForthTableViewCell alloc] init];
//        }
        forthCell_.recommencArray = dataModel_.recommandBook;
//        NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:3];
//        [myTableView_ reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
        [myTableView_ reloadData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [forthCell_.recommendTable reloadData];
        });
    }
    
    if ([keyPath isEqualToString:@"userImage"]) {
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
        [myTableView_ reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
    }
    
    //    NSLog(@"I heard about the change");
}

#pragma mark TableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        [_delegate pushUserController];
    }
    if (indexPath.section == 2) {
        if (indexPath.row > 0) {
            
//            BookData *data = dataModel_.myBook[indexPath.row - 1];
//            KJ_BackTableViewController *kj_svc = [[KJ_BackTableViewController alloc] init];
//            kj_svc.libraryTitle = data.bookName;
//            kj_svc.libraryAuthorName = data.authorName;
//            kj_svc.libraryType = data.type;
//            kj_svc.libraryDetails = data.details;
//            kj_svc.libraryLanguage = data.language;
//            kj_svc.libraryNum = data.bookID;
////            kj_svc.libraryAuthorImageUrl = data.imagePath;
//            kj_svc.libraryImageUrl = data.imagePath;
//hhhhhhhhhhh
//            SectionViewController *svc = [[SectionViewController alloc] init];
////            svc.title = [dica valueForKey:@"WJ_NAME"];
////            [svc getJsonData:dica];
//            [self.navigationController pushViewController:svc animated:NO];
            BookData *data = [dataModel_.myBookAndID objectForKey:[NSString stringWithFormat:@"%d", indexPath.row - 1]];
            //    NSLog(@"%@",[NSString stringWithFormat:@"%d", indexPath.row]);
            [self.navigationController pushViewController:[DATA_MODEL.process popBookWithData:data] animated:YES];
        }
        else {
            MyBookListController *bookList = [[MyBookListController alloc] init];
            bookList.title = @"我的文集";
            [self.navigationController pushViewController:bookList animated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 60;
    } else if (indexPath.section == 1) {
        return 110;
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            return 50;
        } else {
            return 80;
        }
    }
    return 280;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01;
    }
    return 10;
}

#pragma mark TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // 因为dataModel.allBookAndID存储了用以验证的bookID，所以有一份多余的数据
    if (dataModel_.myBookAndID.count / 2 > 2) {
        return 4;
    }
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 2) {
        if ((dataModel_.myBookAndID.count / 2 + 1) > 5) {
            return 5;
        }
        return dataModel_.myBookAndID.count / 2 + 1;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:firstIdentifier forIndexPath:indexPath];
        ((FirstTableViewCell *)cell).userImageView.image = userModel_.userImage;
        // 圆形图片实际上就是设圆角
        [((FirstTableViewCell *)cell).userImageView.layer setCornerRadius:19.5];
        // 是否限制边界，既画圆角
        [((FirstTableViewCell *)cell).userImageView setClipsToBounds:YES];
        ((FirstTableViewCell *)cell).userName.text = userModel_.userName;
        ((FirstTableViewCell *)cell).userDetail.text = userModel_.userIntroduction;
        ((FirstTableViewCell *)cell).delegate = self;
        if ([userModel_.userIntroduction isEqualToString:@""]) {
            ((FirstTableViewCell *)cell).userDetail.text = @"还没有简介！";
        }
        
    } else if (indexPath.section == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:secondIdentifier forIndexPath:indexPath];
        SecondHomeTableViewCell *c = ((SecondHomeTableViewCell *) cell);
        c.delegate = self;
        c.totalLabel.text = [NSString stringWithFormat:@""];//%d",dataModel_.allSection.count];
        c.downloadLabel.text = [NSString stringWithFormat:@""];//%d", dataModel_.downloadSection.count];
        c.recentLabel.text = [NSString stringWithFormat:@""];//%d", dataModel_.recentPlay.count];
        c.likeLabel.text = [NSString stringWithFormat:@""];//%d", dataModel_.userLikeSection.count];
        c.fontColor = [UIColor blackColor];
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:defaultIdentifier];
            
            if (!cell) {
                cell = [[MyBookTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:defaultIdentifier];
            }
            cell.textLabel.text = @"我的文集";
            [cell addSubview:[((MyBookTableViewCell *)cell) footLine]];
//            [cell.textLabel setTextColor:[UIColor whiteColor]];
            [cell.textLabel setFont:[UIFont systemFontOfSize:17]];
            int num = (dataModel_.myBookAndID.count / 2) > 4 ? 4 : (dataModel_.myBookAndID.count / 2);
            ((MyBookTableViewCell *)cell).label.text = [NSString stringWithFormat:@"%d", dataModel_.myBookAndID.count/2];
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:thirdIdentifier forIndexPath:indexPath];
            BookData *book = [dataModel_.myBookAndID objectForKey:[NSString stringWithFormat:@"%d", indexPath.row - 1]];
            ((ThirdTableViewCell *)cell).bookImageView.image = book.bookImage;
            [((ThirdTableViewCell *)cell).bookImageView sd_setImageWithURL:[NSURL URLWithString:book.imagePath] placeholderImage:cachePicture];
            ((ThirdTableViewCell *)cell).bookName.text = book.bookName;
            [((ThirdTableViewCell *)cell).bookDetail setTextColor:DEFAULT_TINTCOLOR];
            ((ThirdTableViewCell *)cell).bookDetail.text = book.authorName;
            CGRect frame = ((ThirdTableViewCell *)cell).footLine.frame;
            frame.size.height = 0.5;
            ((ThirdTableViewCell *)cell).footLine.frame = frame;
            ((ThirdTableViewCell *)cell).footLine.hidden = NO;
            if (indexPath.row == dataModel_.myBookAndID.count / 2) {
                ((ThirdTableViewCell *)cell).footLine.hidden = YES;
            }
        }
    } else if (indexPath.section == 3) {
//        if (forthCell_) {
//            cell = (UITableViewCell *)forthCell_;
//        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:forthIdentifier forIndexPath:indexPath];
//        }
        forthCell_ = (ForthTableViewCell *)cell;
        forthCell_.backView.backgroundColor = [UIColor colorWithWhite:0.953 alpha:1.000];
        forthCell_.delegate = self;
        forthCell_.recommencArray = dataModel_.recommandBook;
        [forthCell_.recommendTable roundedRectWithConerRadius:5 BorderWidth:0 borderColor:nil];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section == 1 || indexPath.section == 3 || indexPath.section == 2) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        if (indexPath.row != 0) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

#pragma mark RecommendDelegate

- (void)recommendTable:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"点击了推荐");
}

#pragma mark Action

static NSInteger selfSign = 0;

- (void)success {
    if (selfSign) {
        [SVProgressHUD showSuccessWithStatus:@"已签到"];
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.5f];
        return;
    }
    selfSign = 1;
    [SVProgressHUD showSuccessWithStatus:@"签到成功"];
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.5f];
}

- (void)dismiss {
    [SVProgressHUD dismiss];
}

#pragma mark CellDelegate

- (void)sign {

//    shareView *s = [[shareView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) shareData:nil];
//    [s pushViewWithController:nil view:s];
//    
//    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
//    [SVProgressHUD show];
//    [self performSelector:@selector(success) withObject:nil afterDelay:0.6f];
}

- (void)clickButton:(NSInteger)tag {
    if (tag == 1010) {
        NSArray *arr = @[@"全部",@"本地"];
        [self initDataWithArr:arr];
        if (!pageController) {
            NSArray *WMViewControllers = @[[TotalViewController class],[LocalPage class]];
            pageController = (WMPageController *)[self p_defaultControllers:WMViewControllers withClass:[WMPageController class]];
            //在导航栏上展示
            pageController.menuHeight = 44;
            pageController.menuViewStyle = WMMenuViewStyleDefault;
            pageController.titleSizeSelected = 18;
            pageController.titleSizeNormal = 18;
            pageController.showOnNavigationBar = YES;
            pageController.menuBGColor = [UIColor clearColor];
            pageController.titleColorNormal = [UIColor colorWithRed:0.831 green:0.686 blue:0.690 alpha:1.000];
            pageController.titleColorSelected = [UIColor whiteColor];
            pageController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:nil action:nil];
        }
        [self.navigationController pushViewController:pageController animated:YES];
    } else if (tag == 1011) {
        NSArray *arr = @[@"已下载",@"正在下载"];
        [self initDataWithArr:arr];
        if (!downloadPC) {
            NSArray *WMViewControllers = @[[FinishDownload class],[Downloading class]];
            downloadPC = (WMPageController *)[self p_defaultControllers:WMViewControllers withClass:[WMPageController class]];
            downloadPC.menuHeight = 44;
            downloadPC.menuViewStyle = WMMenuViewStyleDefault;
            downloadPC.titleSizeSelected = 18;
            downloadPC.titleSizeNormal = 18;
            downloadPC.showOnNavigationBar = YES;
            downloadPC.menuBGColor = [UIColor clearColor];
            downloadPC.titleColorNormal = [UIColor colorWithRed:0.831 green:0.686 blue:0.690 alpha:1.000];
            downloadPC.titleColorSelected = [UIColor whiteColor];
            downloadPC.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:nil action:nil];
        }
        [self.navigationController pushViewController:downloadPC animated:YES];
    } else if (tag == 1012) {
        if (!resentPlay_) {
            resentPlay_ = [[ResentPlay alloc] initWithStyle:UITableViewStyleGrouped];
//            resentPlay_.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:nil action:nil];
        }
        [self.navigationController pushViewController:resentPlay_ animated:YES];
    } else if (tag == 1013) {
        if (!iLike_) {
            iLike_ = [[ILikePage alloc] init];
            resentPlay_.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:nil action:nil];
        }
        [self.navigationController pushViewController:iLike_ animated:YES];
    }
}

- (UIViewController *)p_defaultControllers:(NSArray *)viewControllers withClass: (id)class{
    WMPageController *pageVC;
    pageVC = [[WMPageController alloc] initWithViewControllerClasses:viewControllers andTheirTitles:titleArr_];

    pageVC.menuItemWidth = 80;
    NSNumber *a = [NSNumber numberWithInt:10];
    NSNumber *b = [NSNumber numberWithInt:0];
    NSNumber *c = [NSNumber numberWithInt:30];
    pageVC.itemsMargins = @[a,b,c];
    pageVC.postNotification = YES;
    pageVC.bounces = YES;
    pageVC.pageAnimatable = YES;
    return pageVC;
}

@end
