//
//  ILikeBook.m
//  XinMinClub
//
//  Created by 赵劲松 on 16/3/30.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "ILikeBook.h"
#import "EssayCell.h"
#import "ProcessSelect.h"
//#import "KJ_BackTableViewController.h"

@interface ILikeBook () {
    UINib *nib;
    DataModel *dataModel;
    UserDataModel *userModel;
    NSMutableArray *bookID;
}

@end

static NSString *EssayIdentifier = @"essay";

@implementation ILikeBook

- (void)viewDidLoad {
    [super viewDidLoad];
    dataModel = [DataModel defaultDataModel];
    userModel = [UserDataModel defaultDataModel];
    bookID = [NSMutableArray array];
    [self copyUserLikeBooID];
//    bookID = dataModel.userLikeBookID;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.01)];
    self.tableView.tableHeaderView = view;
    nib = [UINib nibWithNibName:@"EssayCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:EssayIdentifier];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (void)copyUserLikeBooID {
    [bookID removeAllObjects];
    for (NSString *s in dataModel.userLikeBookID) {
        [bookID addObject:s];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    if (bookID.count != userModel.userLikeBookID.count) {
        [self.tableView reloadData];
        [self copyUserLikeBooID];
    } else {
        if (bookID.count) {
            for (NSString *s in bookID) {
                if (![userModel.userLikeBookID containsObject:s]) {
                    [self.tableView reloadData];
                    [self copyUserLikeBooID];
                }
            }
        } else {
            if (userModel.userLikeBookID.count) {
                [self.tableView reloadData];
                [self copyUserLikeBooID];
            }
        }
    }
}

#pragma mark - Table view data source & Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BookData *data = [dataModel.userLikeBook objectAtIndex:[NSString stringWithFormat:@"%d", indexPath.row]];
    [self.navigationController pushViewController:[DATA_MODEL.process popBookWithData:data] animated:YES];
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
    return userModel.userLikeBookID .count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EssayCell *cell = [tableView dequeueReusableCellWithIdentifier:EssayIdentifier    forIndexPath:indexPath];
    BookData *book = [dataModel.allBookAndID objectForKey:[NSString stringWithFormat:@"%d", indexPath.row]];
    NSLog(@"%d",indexPath.row);
    cell.userName.text = book.bookName;//((SectionData *)dataModel_.allSection[indexPath.row]).bookName;
    //    cell.userDetail.text = ;//((SectionData *)dataModel_.allSection[indexPath.row]).author;
    [cell.userImageView sd_setImageWithURL:[NSURL URLWithString:book.imagePath] placeholderImage:cachePicture];
    if (book.bookImage) cell.userImageView.image = book.bookImage;
    cell.userDetail.text = book.authorName;
    [cell.userDetail setTextColor:DEFAULT_TINTCOLOR];
    
    if (indexPath.row == 0) {
        cell.headLine.hidden = YES;
    }

    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
