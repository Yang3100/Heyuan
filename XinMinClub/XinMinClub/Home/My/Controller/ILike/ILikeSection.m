//
//  ILikeSection.m
//  XinMinClub
//
//  Created by 赵劲松 on 16/3/30.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "ILikeSection.h"
#import "ManageCell.h"
#import "BookCell.h"
#import "DataModel.h"
#import "UserDataModel.h"
#import "SectionData.h"
#import "DeleteController.h"
#import "SectionManageView.h"
#import "ProcessSelect.h"

#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height) // 屏幕高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width) // 屏幕宽度

@interface ILikeSection () <ManageDelegate, SectionDelegate, SectionManageDelegate> {
    
    UIView *searchView_;
    UIButton *searchButton_;
    UIButton *speechButton_;
    UINib *nib_;
    NSInteger selectedCell;
    UIImageView *backImageView_;
    UILabel *backLabel_;
    
    DataModel *dataModel_;
    UserDataModel *userModel_;
    SectionManageView *smView_;
    UIControl *smBackView_;
}

@end

@implementation ILikeSection

static NSString *manageCell = @"manageCell";
static NSString *bookCell = @"bookCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dataModel_ = [DataModel defaultDataModel];
    userModel_ = [UserDataModel defaultDataModel];
    NSLog(@"%@",[UserDataModel defaultDataModel].userID);
    
    self.title = @"文章";
    // 选择的cell
    selectedCell = -1;
    nib_ = [UINib nibWithNibName:@"ManageCell" bundle:nil];
    [self.tableView registerNib:nib_ forCellReuseIdentifier:manageCell];
    nib_ = [UINib nibWithNibName:@"BookCell" bundle:nil];
    [self.tableView registerNib:nib_ forCellReuseIdentifier:bookCell];
    self.tableView.tableHeaderView = [self searchView];
    like();
    [self.view addSubview:[self backImageView]];
    [self.view addSubview:[self backLabel]];
}

// 添加收藏
void like (){
//    NSString *likeID = @"like";
//    NSLog(@"%@",[DataModel defaultDataModel].allSection);
//    for (SectionData *s in [DataModel defaultDataModel].allSection) {
//        if ([likeID isEqualToString:s.sectionID]) {
//            if (![[UserDataModel defaultDataModel].userLikeSection containsObject:s]) {
//                [[UserDataModel defaultDataModel].userLikeSection insertObject:s atIndex:0];
//                [[UserDataModel defaultDataModel].userLikeSectionID insertObject:likeID atIndex:0];
////                [DataModel defaultDataModel].allSection 
//            }
//        }
//    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
    if (dataModel_.userLikeSection.count == 0) {
        backImageView_.hidden = NO;
        backLabel_.hidden = NO;
        self.tableView.userInteractionEnabled = NO;
    }
    else {
        backImageView_.hidden = YES;
        backLabel_.hidden = YES;
        self.tableView.userInteractionEnabled = YES;
    }
    
    [userModel_ judgeIsDelete];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self smBackTap];
}

- (UIView *)searchView {
    if (!searchView_) {
        searchView_ = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
    }
    searchView_.backgroundColor = [UIColor colorWithWhite:0.953 alpha:1.000];
    searchView_.center = searchButton_.center;
    return searchView_;
}

- (UIImageView *)backImageView {
    if (!backImageView_) {
        backImageView_ = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"12345.jpg"]];
        backImageView_.frame = CGRectMake(0, 0, SCREEN_WIDTH / 2, SCREEN_WIDTH / 2);
        backImageView_.center = CGPointMake(self.view.center.x, self.view.center.y - SCREEN_WIDTH / 3);
        backImageView_.alpha = 0.5;
    }
    return backImageView_;
}

- (UILabel *)backLabel {
    if (!backLabel_) {
        backLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 60)];
        backLabel_.text = @"还没有喜欢哦";
        [backLabel_ setFont:[UIFont systemFontOfSize:15]];
        backLabel_.textColor = [UIColor colorWithWhite:0.696 alpha:1.000];
        backLabel_.textAlignment = NSTextAlignmentCenter;
        backLabel_.backgroundColor = [UIColor clearColor];
        backLabel_.center = CGPointMake(self.view.center.x, backImageView_.frame.origin.y + backImageView_.bounds.size.height + 30);
    }
    return backLabel_;
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
    delete.deleteArr = [DataModel defaultDataModel].userLikeSection;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:delete];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

- (void)playAll {
    ProcessSelect *select = [[ProcessSelect alloc] init];
    [select processPlayAllButtonSelect:nil didSelectRowAtIndexPath:nil forData:dataModel_.userLikeSection inViewController:self];
}

#pragma mark SectionManageDelegate

- (void)sectionManage:(NSInteger)tag {
    
    SectionOperation *sec = [[SectionOperation alloc] init];
    if (!smBackView_) {
        smBackView_ = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [smBackView_ addTarget:self action:@selector(smBackTap) forControlEvents:UIControlEventTouchUpInside];
        smView_ = [[SectionManageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0)];
    }
    [sec popManageView:self backView:smBackView_ statusView:smView_ tag:tag data:(SectionData *)dataModel_.userLikeSection[tag - 16000]];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (dataModel_.userLikeSection.count == 0) {
        return dataModel_.userLikeSection.count;
    } else {
        return dataModel_.userLikeSection.count + 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:manageCell forIndexPath:indexPath];
        ((ManageCell *)cell).manageDelegate = self;
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:bookCell forIndexPath:indexPath];
        ((BookCell *) cell).sectionsName.text = ((SectionData *)dataModel_.userLikeSection[indexPath.row - 1]).sectionName;
        
        ((BookCell *) cell).authorName.text = ((SectionData *)dataModel_.userLikeSection[indexPath.row - 1]).author;
        if ([((BookCell *) cell).authorName.text isEqualToString:@""]) {
            ((BookCell *) cell).authorName.text = @"无名";
        }
        ((BookCell *) cell).statusView.hidden = YES;
        ((BookCell *) cell).delegate = self;
        ((BookCell *) cell).accessoryButton.tag = indexPath.row - 1 + 16000;
        if ([((SectionData *)dataModel_.userLikeSection[indexPath.row - 1]).sectionID isEqual:dataModel_.playingSection.sectionID]) {
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
    [select processTableSelect:tableView didSelectRowAtIndexPath:indexPath forData:userModel_.userLikeSection[indexPath.row - 1] inViewController:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

@end
