//
//  LocalAuthor.m
//  XinMinClub
//
//  Created by 赵劲松 on 16/4/4.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "LocalAuthor.h"
#import "AuthorCell.h"
#import "UIView+Draw.h"
#import "DataModel.h"

@interface LocalAuthor () {
    UINib *nib;
    DataModel *dataModel_;
}

@end

@implementation LocalAuthor

static NSString *authorIdentifier = @"author";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dataModel_ = [DataModel defaultDataModel];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.01)];
    self.tableView.tableHeaderView = view;
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    nib = [UINib nibWithNibName:@"AuthorCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:authorIdentifier];
}

#pragma mark - Table view data source & Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_delegate popEssayList];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 70;
    }
    
    return 80;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _localAuthor;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AuthorCell *cell = [tableView dequeueReusableCellWithIdentifier:authorIdentifier forIndexPath:indexPath];
    [cell.userImageView roundedRectWithConerRadius:cell.userImageView.bounds.size.width / 2 BorderWidth:0 borderColor:nil];
    if (indexPath.row == 0) {
        cell.headLine.hidden = YES;
    }
    cell.userName.text = ((SectionData *)dataModel_.allSection[indexPath.row]).author;
    return cell;
}

@end
