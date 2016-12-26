//
//  ILikeAuthor.m
//  XinMinClub
//
//  Created by 赵劲松 on 16/3/30.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "ILikeAuthor.h"
#import "AuthorCell.h"
#import "ManageCell.h"
#import "UIView+Draw.h"

@interface ILikeAuthor () {
    UINib *nib;
}

@end

@implementation ILikeAuthor

static NSString *authorIdentifier = @"author";
static NSString *manageCell = @"manageCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.01)];
    self.tableView.tableHeaderView = view;
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    nib = [UINib nibWithNibName:@"AuthorCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:authorIdentifier];
    nib = [UINib nibWithNibName:@"ManageCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:manageCell];
}

#pragma mark - Table view data source & Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row != 0) {
        [_delegate popEssayList];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 55;
        }
        return 70;
    }
    
    return 80;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _authorNum;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AuthorCell *cell;
    
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:manageCell forIndexPath:indexPath];
        ((ManageCell *)cell).manageButton.hidden = YES;
        [((ManageCell *)cell).manageLabel setTitle:@"一个作者"  forState:UIControlStateNormal];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:authorIdentifier forIndexPath:indexPath];
    }
    
    if (indexPath.row == 1) {
        cell.headLine.hidden = YES;
    }
    return cell;
}

@end
