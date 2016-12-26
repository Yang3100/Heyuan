//
//  LocalBook.m
//  XinMinClub
//
//  Created by 赵劲松 on 16/4/4.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "LocalBook.h"
#import "EssayCell.h"
#import "DataModel.h"

@interface LocalBook () {
    UINib *nib;
    DataModel *dataModel_;
}

@end

static NSString *EssayIdentifier = @"essay";

@implementation LocalBook

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dataModel_ = [DataModel defaultDataModel];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.01)];
    self.tableView.tableHeaderView = view;
    nib = [UINib nibWithNibName:@"EssayCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:EssayIdentifier];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
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
    return dataModel_.allBook.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EssayCell *cell = [tableView dequeueReusableCellWithIdentifier:EssayIdentifier    forIndexPath:indexPath];
    NSLog(@"%@",dataModel_.allBookAndID);
    BookData *book = [dataModel_.allBookAndID objectForKey:[NSString stringWithFormat:@"%d", indexPath.row]];
    NSLog(@"%d",indexPath.row);
    cell.userName.text = book.bookName;//((SectionData *)dataModel_.allSection[indexPath.row]).bookName;
    //    cell.userDetail.text = ;//((SectionData *)dataModel_.allSection[indexPath.row]).author;
    [cell.userImageView sd_setImageWithURL:[NSURL URLWithString:book.imagePath] placeholderImage:cachePicture];
    if (book.bookImage) cell.userImageView.image = book.bookImage;
    cell.userDetail.text = book.authorName;
    [cell.userDetail setTextColor:DEFAULT_TINTCOLOR];
    
    //    ((ThirdTableViewCell *)cell).bookImageView.image = book.bookImage;
    //    ((ThirdTableViewCell *)cell).bookName.text = book.bookName;
    //    CGRect frame = ((ThirdTableViewCell *)cell).footLine.frame;
    //    frame.size.height = 0.5;
    //    ((ThirdTableViewCell *)cell).footLine.frame = frame;
    //    ((ThirdTableViewCell *)cell).footLine.hidden = NO;
    //    if (indexPath.row == dataModel_.myBookAndID.count / 2) {
    //        ((ThirdTableViewCell *)cell).footLine.hidden = YES;
    //    }
    
    if (indexPath.row == 0) {
        cell.headLine.hidden = YES;
    }
    return cell;
}

@end
