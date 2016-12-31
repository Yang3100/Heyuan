//
//  Downloading.m
//  XinMinClub
//
//  Created by 赵劲松 on 16/3/30.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "Downloading.h"
#import "ManageCell.h"
#import "BookCell.h"
#import "SectionData.h"
#import "DataModel.h"
#import "ProcessSelect.h"
#import "SectionManageView.h"
#import "DeleteController.h"
#import "DownloadModule.h"

#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height) // 屏幕高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width) // 屏幕宽度

@interface Downloading () <ManageDelegate, SectionDelegate, SectionManageDelegate, DownloadDelegate, FinishDelegate> {
    
    UIView *searchView_;
    UINib *nib_;
    NSInteger selectedCell;
    DataModel *dataModel_;
    SectionManageView *smView_;
    UIControl *smBackView_;
    DeleteController *delete;
    DownloadModule *downloadModule;
}

@end

@implementation Downloading

static NSString *manageCell = @"manageCell";
static NSString *bookCell = @"bookCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    
    dataModel_ = [DataModel defaultDataModel];
    self.title = @"歌曲";
    // 选择的cell
    selectedCell = -1;
    UITableView *tableView = self.tableView;
    nib_ = [UINib nibWithNibName:@"ManageCell" bundle:nil];
    [tableView registerNib:nib_ forCellReuseIdentifier:manageCell];
    nib_ = [UINib nibWithNibName:@"BookCell" bundle:nil];
    [tableView registerNib:nib_ forCellReuseIdentifier:bookCell];
    self.tableView.tableHeaderView = [self searchView];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    dataModel_ = [DataModel defaultDataModel];
    downloadModule = [DownloadModule defaultDataModel];
    downloadModule.delegate = self;
    
    // 添加 下载总章节进度 和 下载中章节进度 的监听
    [dataModel_ addObserver:self forKeyPath:@"downloadingSections" options:NSKeyValueObservingOptionNew context:nil];
    [downloadModule.sectionData addObserver:self forKeyPath:@"progress" options:NSKeyValueObservingOptionNew context:nil];
    self.tableView.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
    // 滚动到第二行为首行
    //    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    //    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self smBackTap];
}

- (id)init {
    if (self = [super init]) {
        _downloadingNum = 10;
    }
    return self;
}

#pragma mark Views

- (UIView *)searchView {
    if (!searchView_) {
        searchView_ = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
    }
    searchView_.backgroundColor = [UIColor colorWithWhite:0.953 alpha:1.000];
    return searchView_;
}

#pragma mark FinishDelegate

- (void)finishDownloadSection {
    // 当完成一章下载后再次添加新的观察者观察新的对象
    [dataModel_.downloadingSection addObserver:self forKeyPath:@"progress" options:NSKeyValueObservingOptionNew context:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void)dealloc {
    [dataModel_.downloadingSection removeObserver:self forKeyPath:@"progress"];
}

#pragma mark ObserveMethods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    if ([object isKindOfClass:[SectionData class]]) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        BookCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.downloadProgress.progress = dataModel_.downloadingSection.progress;
        });
    }
    
//    NSLog(@"I heard about the change");
}

#pragma mark ManageDelegate

- (void)manageAll {
    delete = [[DeleteController alloc] init];
    delete.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:delete];
    delete.deleteArr = [DataModel defaultDataModel].downloadingSections;
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

- (void)playAll {
    NSLog(@"下載全部");
    ManageCell *cell = (ManageCell *)[self.view viewWithTag:10010];
    if (dataModel_.isDownloading) {
        [cell.playImage setImage:[UIImage imageNamed:@"playDownload"] forState:UIControlStateNormal];
        [cell.playLabel setTitle:@"下载全部" forState:UIControlStateNormal];
        dataModel_.isDownloading = NO;
        [downloadModule pauseDownload];
    }
    else {
        [cell.playImage setImage:[UIImage imageNamed:@"kjpause"] forState:UIControlStateNormal];
        [cell.playLabel setTitle:@"暂停全部" forState:UIControlStateNormal];
        dataModel_.isDownloading = YES;
        [downloadModule resumeDownload];
    }
}

#pragma mark Actions

- (void)smBackTap {
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        smBackView_.backgroundColor = [UIColor clearColor];
        smView_.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0);
    } completion:^(BOOL finished) {
        smBackView_.hidden = YES;
    }];
}

- (void)cacenl {
    [self smBackTap];
}

#pragma mark SectionManageDelegate

- (void)sectionManage:(NSInteger)tag {
    if (!smBackView_) {
        smBackView_ = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [smBackView_ addTarget:self action:@selector(smBackTap) forControlEvents:UIControlEventTouchUpInside];
        smBackView_.hidden = YES;
        smBackView_.backgroundColor = [UIColor clearColor];
        [self.view.superview.window addSubview:smBackView_];
    }
    
    CGRect frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0);
    smView_ = [[SectionManageView alloc] initWithFrame:frame];
    smView_.backgroundColor = [UIColor whiteColor];
    smView_.delegate = self;
    [self.view.superview.window addSubview:smView_];
    smView_.data = (SectionData *)dataModel_.downloadSection[tag - 14000];
    [SectionOperation sectionManage:smBackView_ StatusView:smView_ andViewController:nil];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (dataModel_.downloadingSections.count == 0) {
        return dataModel_.downloadingSections.count;
    } else {
        return dataModel_.downloadingSections.count + 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        
        nib_ = [UINib nibWithNibName:@"ManageCell" bundle:nil];
        [self.tableView registerNib:nib_ forCellReuseIdentifier:manageCell];
        cell = [tableView dequeueReusableCellWithIdentifier:manageCell forIndexPath:indexPath];
        if (dataModel_.isDownloading) {
            [((ManageCell *)cell).playImage setImage:[UIImage imageNamed:@"kjpause"] forState:UIControlStateNormal];
            [((ManageCell *)cell).playLabel setTitle:@"暂停全部" forState:UIControlStateNormal];
        }
        else {
            [((ManageCell *)cell).playImage setImage:[UIImage imageNamed:@"playDownload"] forState:UIControlStateNormal];
            [((ManageCell *)cell).playLabel setTitle:@"下载全部" forState:UIControlStateNormal];
        }
        ((ManageCell *)cell).playLabel.enabled = YES;
        ((ManageCell *)cell).playImage.hidden = NO;
        ((ManageCell *)cell).manageDelegate = self;
        cell.tag = 10010;
    } else {
        nib_ = [UINib nibWithNibName:@"BookCell" bundle:nil];
        [self.tableView registerNib:nib_ forCellReuseIdentifier:bookCell];
        cell = [tableView dequeueReusableCellWithIdentifier:bookCell forIndexPath:indexPath];
        ((BookCell *) cell).sectionsName.text = ((SectionData *)dataModel_.downloadingSections[indexPath.row - 1]).sectionName;
        
        ((BookCell *) cell).authorName.text = ((SectionData *)dataModel_.downloadingSections[indexPath.row - 1]).author;
        ((BookCell *) cell).statusView.hidden = YES;
        ((BookCell *) cell).delegate = self;
        ((BookCell *) cell).accessoryButton.tag = indexPath.row - 1 + 14000;
        if ([((SectionData *)dataModel_.downloadingSections[indexPath.row - 1]).sectionID isEqual:dataModel_.playingSection.sectionID]) {
            ((BookCell *) cell).statusView.hidden = NO;
        }
        ((BookCell *) cell).accessoryButton.hidden = YES;
        ((BookCell *) cell).downloadProgress.hidden = NO;
//        ((BookCell *) cell).downloadProgress.progress = 0.3;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark TableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    ProcessSelect *select = [[ProcessSelect alloc] init];
//    [select processTableSelect:tableView didSelectRowAtIndexPath:indexPath forData:dataModel_.downloadingSection inViewController:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

@end
