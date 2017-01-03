//
//  TotalTableViewController.m
//  XinMinClub
//
//  Created by Jason_zzzz on 16/3/25.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "TotalTableViewController.h"
#import "ManageCell.h"
#import "BookCell.h"
#import "DataModel.h"
#import "UserDataModel.h"
#import "UINavigationBar+Awesome.h"
#import "SectionManageView.h"
#import "DeleteController.h"
#import "ProcessSelect.h"

#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height) // 屏幕高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width) // 屏幕宽度

@interface TotalTableViewController () <ManageDelegate, SectionDelegate, SectionManageDelegate> {
    
    UIView *searchView_;
    UIButton *searchButton_;
    UIButton *speechButton_;
    UINib *nib_;
    
    DataModel *dataModel_;
    UserDataModel *userModel_;
    SectionManageView *smView_;
    UIControl *smBackView_;

}

@end

@implementation TotalTableViewController

static NSString *manageCell = @"manageCell";
static NSString *bookCell = @"bookCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"章節";
    
    dataModel_ = [DataModel defaultDataModel];
    
    nib_ = [UINib nibWithNibName:@"ManageCell" bundle:nil];
    [self.tableView registerNib:nib_ forCellReuseIdentifier:manageCell];
    nib_ = [UINib nibWithNibName:@"BookCell" bundle:nil];
    [self.tableView registerNib:nib_ forCellReuseIdentifier:bookCell];
    self.tableView.tableHeaderView = [self searchView];
    // 设置navigationBar背景颜色
//    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor whiteColor]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];

    [self.tableView reloadData];
    NSIndexPath *indexPath;
    // 滚动到第二行为首行
    indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    if (dataModel_.allSection.count > 0) {        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
        });
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self smBackTap];
//    [self.navigationController.navigationBar lt_reset];
}

- (UIView *)searchView {
    if (!searchView_) {
        searchView_ = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01/*55*/)];
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
        [speechButton_ setTitle:@"" forState:UIControlStateNormal];
    }
    return speechButton_;
}

#pragma mark Actions

- (void)smBackTap {
    [SectionOperation backTap:smBackView_ statusView:smView_];
}

- (void)cacenl {
    [self smBackTap];
}

#pragma mark ManageDelegate

- (void)manageAll {
    DeleteController *delete = [[DeleteController alloc] init];
    delete.deleteArr = [DataModel defaultDataModel].allSection;
    delete.deleteDirectoryName = @"sectionFile";
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:delete];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

- (void)playAll {
    ProcessSelect *select = [[ProcessSelect alloc] init];
    [select processPlayAllButtonSelect:nil didSelectRowAtIndexPath:nil forData:dataModel_.allSection inViewController:self];
}

#pragma mark SectionManageDelegate

- (void)sectionManage:(NSInteger)tag {
    
    SectionOperation *sec = [[SectionOperation alloc] init];
    if (!smBackView_) {
        smBackView_ = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [smBackView_ addTarget:self action:@selector(smBackTap) forControlEvents:UIControlEventTouchUpInside];
        smView_ = [[SectionManageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0)];
    }
    [sec popManageView:self backView:smBackView_ statusView:smView_ tag:tag data:(SectionData *)dataModel_.allSection[tag - 11000]];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (dataModel_.allSection.count == 0) {
        return dataModel_.allSection.count;
    } else {
        return dataModel_.allSection.count + 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:manageCell forIndexPath:indexPath];
        ((ManageCell *)cell).manageDelegate = self;
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:bookCell forIndexPath:indexPath];
        ((BookCell *) cell).sectionsName.text = ((SectionData *)dataModel_.allSection[indexPath.row - 1]).sectionName;
        
        ((BookCell *) cell).authorName.text = ((SectionData *)dataModel_.allSection[indexPath.row - 1]).author;
        ((BookCell *) cell).statusView.hidden = YES;
        ((BookCell *) cell).accessoryButton.tag = indexPath.row - 1 + 11000;
        ((BookCell *) cell).delegate = self;
        if ([((SectionData *)dataModel_.allSection[indexPath.row - 1]).sectionID isEqual:dataModel_.playingSection.sectionID]) {
            ((BookCell *) cell).statusView.hidden = NO;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark TableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return;
    }

    ProcessSelect *select = [[ProcessSelect alloc] init];
    [select processTableSelect:tableView didSelectRowAtIndexPath:indexPath forData:dataModel_.allSection[indexPath.row - 1] inViewController:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

@end
