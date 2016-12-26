//
//  LocalSection.m
//  XinMinClub
//
//  Created by 赵劲松 on 16/4/4.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "LocalSection.h"
#import "ManageCell.h"
#import "BookCell.h"
#import "DataModel.h"
#import "UserDataModel.h"
#import "SectionManageView.h"
#import "DeleteController.h"
#import "ProcessSelect.h"

#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height) // 屏幕高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width) // 屏幕宽度

@interface LocalSection () <ManageDelegate, SectionDelegate, SectionManageDelegate> {
    
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

@implementation LocalSection

static NSString *manageCell = @"manageCell";
static NSString *bookCell = @"bookCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"章节";
    
    dataModel_ = [DataModel defaultDataModel];
    // 选择的cell
//    dataModel_.lastPlay = -1;
    nib_ = [UINib nibWithNibName:@"ManageCell" bundle:nil];
    [self.tableView registerNib:nib_ forCellReuseIdentifier:manageCell];
    nib_ = [UINib nibWithNibName:@"BookCell" bundle:nil];
    [self.tableView registerNib:nib_ forCellReuseIdentifier:bookCell];
    self.tableView.tableHeaderView = [self searchView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
    NSIndexPath *indexPath;
    // 滚动到第二行为首行
    indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    if (dataModel_.downloadSection.count > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
        });
        // 选中播放行
//        indexPath = [NSIndexPath indexPathForRow:dataModel_.lastPlay inSection:0];
//        [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self smBackTap];
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
    delete.deleteArr = [DataModel defaultDataModel].downloadSection;
    delete.deleteDirectoryName = @"";
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:delete];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

- (void)playAll {
    ProcessSelect *select = [[ProcessSelect alloc] init];
    [select processPlayAllButtonSelect:nil didSelectRowAtIndexPath:nil forData:dataModel_.downloadSection inViewController:self];
}

#pragma mark SectionManageDelegate

- (void)sectionManage:(NSInteger)tag {
    
    SectionOperation *sec = [[SectionOperation alloc] init];
    if (!smBackView_) {
        smBackView_ = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [smBackView_ addTarget:self action:@selector(smBackTap) forControlEvents:UIControlEventTouchUpInside];
        smView_ = [[SectionManageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0)];
    }
    [sec popManageView:self backView:smBackView_ statusView:smView_ tag:tag data:(SectionData *)dataModel_.downloadSection[tag - 12000]];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (dataModel_.downloadSection.count == 0) {
        return dataModel_.downloadSection.count;
    } else {
        return dataModel_.downloadSection.count + 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:manageCell forIndexPath:indexPath];
        ((ManageCell *)cell).manageDelegate = self;
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:bookCell forIndexPath:indexPath];
        ((BookCell *) cell).sectionsName.text = ((SectionData *)dataModel_.downloadSection[indexPath.row - 1]).clickTitle;
        
        ((BookCell *) cell).authorName.text = ((SectionData *)dataModel_.downloadSection[indexPath.row - 1]).clickAuthor;
        ((BookCell *) cell).statusView.hidden = YES;
        ((BookCell *) cell).delegate = self;
        ((BookCell *) cell).accessoryButton.tag = indexPath.row - 1 + 12000;
        if ([((SectionData *)dataModel_.downloadSection[indexPath.row - 1]).clickSectionID isEqual:dataModel_.playingSection.clickSectionID]) {
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
    [select processTableSelect:tableView didSelectRowAtIndexPath:indexPath forData:dataModel_.downloadSection[indexPath.row - 1] inViewController:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

@end
