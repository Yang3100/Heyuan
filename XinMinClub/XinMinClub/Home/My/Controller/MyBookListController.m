//
//  MyBookListController.m
//  XinMinClub
//
//  Created by 赵劲松 on 16/4/27.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "MyBookListController.h"
#import "UserDataModel.h"
#import "SaveModule.h"
#import "LibraryCollectionCell.h"
//#import "KJ_BackTableViewController.h"
#import "EssayCell.h"
#import "DataModel.h"

@interface MyBookListController () <UICollectionViewDataSource> {
    NSArray *listArray;//分类列表
    NSMutableArray *libraryArray; // 下面文库数据
    UICollectionView *bookCollectionView;
    UINib *nib;
    DataModel *dataModel_;
}

@end

static NSString *EssayIdentifier = @"essay";

@implementation MyBookListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dataModel_ = [DataModel defaultDataModel];
    if (dataModel_.addAllBook) {
        dataModel_.addAllBook = NO;
        [self.tableView reloadData];
    }
    if (dataModel_.addBook) {
        dataModel_.addBook = NO;
        [self.tableView reloadData];
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.01)];
    self.tableView.tableHeaderView = view;
    nib = [UINib nibWithNibName:@"EssayCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:EssayIdentifier];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (dataModel_.addAllBook) {
        dataModel_.addAllBook = NO;
        [self.tableView reloadData];
    }
}

#pragma mark - Table view data source & Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
#warning aa aaaaaaaaaaaa
//    BookData *data = [dataModel_.allBookAndID objectForKey:[NSString stringWithFormat:@"%d", indexPath.row * 2]];
//    KJ_BackTableViewController *kj_svc = [[KJ_BackTableViewController alloc] init];
//    kj_svc.libraryTitle = data.bookName;
//    kj_svc.libraryAuthorName = data.authorName;
//    kj_svc.libraryType = data.type;
//    kj_svc.libraryDetails = data.details;
//    kj_svc.libraryLanguage = data.language;
//    kj_svc.libraryNum = data.bookID;
//    kj_svc.libraryImageUrl = data.imagePath;
//    
//    [self.navigationController pushViewController:kj_svc animated:YES];
    
    //    [_delegate popEssayList];
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
    return dataModel_.allBookAndID.count / 2;
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


- (id)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (UIImageView *)imageView {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UserDataModel defaultDataModel].userImage];
    imageView.frame = CGRectMake(200, 100, 160, 160);
    return imageView;
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
// 返回指定section中cell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    for (NSInteger k = 100; k<listArray.count+100; k++) {
        if (collectionView.tag==k) {
            return libraryArray.count;
        }
    }
    return 0;
}
// 返回指定位置的cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LibraryCollectionCell *cell = nil;
    for (NSInteger m = 100; m<listArray.count+100; m++) {
        if (collectionView.tag == m) {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"libraryCollectionCell" forIndexPath:indexPath];
            SectionData *data = libraryArray[indexPath.row];
            cell.libraryImageUrl = data.libraryImageUrl;
            cell.readtotal = data.libraryReadTotal;
            return cell;
        }
    }
    
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"libraryCollectionCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor grayColor];
    return cell;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [[UserDataModel defaultDataModel] saveUserImage];
//    [[UserDataModel defaultDataModel] getUserImage];
    
//    [[UserDataModel defaultDataModel] saveUserInternetData];
//
//    [[UserDataModel defaultDataModel] getUserData];
    
//    [[UserDataModel defaultDataModel] saveRecommend];
//    [[UserDataModel defaultDataModel] deleteRecommend];
    
//    [[UserDataModel defaultDataModel] saveLike];
//    [[UserDataModel defaultDataModel] getRecommend];
//    [[UserDataModel defaultDataModel] getLike];
//    [[SaveModule defaultObject] saveSectionListWithBookID:@"1" firstLevel:@[@"1.1",@"1.2",@"1.3"]];
//    [[SaveModule defaultObject] setSectionListWithBookID:@"1" firstLevel:@[@"1.1"] secondLevel:@[@"1.1.1",@"1.1.2",@"1.1.3",@"1.1.4"]];
}

@end
