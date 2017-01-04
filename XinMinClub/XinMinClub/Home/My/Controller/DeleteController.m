//
//  DeleteController.m
//  XinMinClub
//
//  Created by 赵劲松 on 16/4/13.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "DeleteController.h"
#import "BookCell.h"
#import "ToolCell.h"
#import "SectionData.h"
#import "DownloadModule.h"
#import "UserDataModel.h"

#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height) // 屏幕高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width) // 屏幕宽度

@interface DeleteController () <UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, ToolCellDelegate> {
    
    UITableView *deleteTable_;
    UIView *toolView_;
    UICollectionView *toolCollection_;
    UINib *nib_;
    NSMutableArray *willDeleteArr_;
    UIButton *leftButton;
}

@end

@implementation DeleteController

static NSString *bookCell = @"bookCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"批量操作";
    
    willDeleteArr_ = [NSMutableArray array];
    [self initViews];
}

- (void)initViews {
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    rightButton.frame = CGRectMake(0, 0, 40, 30);
    [rightButton setTitle:@"关闭" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem
    *rightBtnItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
    
    leftButton = [UIButton buttonWithType:UIButtonTypeSystem];
    leftButton.frame = CGRectMake(0, 0, 70, 30);
    [leftButton setTitle:@"全选" forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(selectAll) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem
    *leftButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    [self.view addSubview:[self deleteTable]];
    [self.view addSubview:[self toolCollection]];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    lineView.backgroundColor = [UIColor colorWithWhite:0.871 alpha:1.000];
    [toolCollection_ addSubview:lineView];
//    [self.view addSubview:[self toolView]];
}

#pragma mark Methods

- (void)closeView {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)selectAll {
    // 1、如果一样就清空willDelete数组
    if(_deleteArr.count == willDeleteArr_.count)
    {
        [leftButton setTitle:@"全选" forState:UIControlStateNormal];
        [willDeleteArr_ removeAllObjects];
    }
    // 2、否则就将shops数组中数据添加到deleteshops数组中
    else
    {
        [leftButton setTitle:@"取消全选" forState:UIControlStateNormal];
        // 先清空deleteshop数组
        if (willDeleteArr_.count) {
            [willDeleteArr_ removeAllObjects];
        }
        // 再添加数据
        for (NSInteger i = 0 ; i < _deleteArr.count ;i ++)
        {
            SectionData *s = [_deleteArr objectAtIndex:i];
            // 添加数据到_deleteShops数组
            [willDeleteArr_ addObject:s];
        }
    }
    
    [deleteTable_ reloadData];
}

#pragma mark Views

- (UITableView *)deleteTable {
    if (!deleteTable_) {
        CGFloat x = 0;
        CGFloat y = 0;
        CGFloat w = [UIScreen mainScreen].bounds.size.width;
        CGFloat h = [UIScreen mainScreen].bounds.size.height;
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(x, y, w, h / 7 * 6)  style:UITableViewStyleGrouped];
        tableView.delegate = self; // 设置tableView的委托
        tableView.dataSource = self; // 设置tableView的数据源
        tableView.editing = YES;
        tableView.allowsMultipleSelectionDuringEditing = YES;
//        tableView.allowsSelectionDuringEditing = YES;
        deleteTable_ = tableView;
        nib_ = [UINib nibWithNibName:@"BookCell" bundle:nil];
        [deleteTable_ registerNib:nib_ forCellReuseIdentifier:bookCell];
        deleteTable_.tableHeaderView = [self toolView];
    }
    return deleteTable_;
}

- (UIView *)toolView{
    if (!toolView_) {
        CGFloat x = 0;
        CGFloat y = 0;
        CGFloat w = [UIScreen mainScreen].bounds.size.width;
//        CGFloat h = [UIScreen mainScreen].bounds.size.height;
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        view.frame = CGRectMake(x,y,w,0.01);
        toolView_ = view;
    }
    return toolView_;
}

static NSString *toolCellIdentifier = @"toolCell";

- (UICollectionView *)toolCollection {
    if (!toolCollection_) {
        //创建并设置流布局
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        //每一个cell的大小
        flowLayout.itemSize = CGSizeMake(64, 80);
        //每一个cell的margin
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 50, 10, 50);
        //列与列/行与行之间的最小距离
        flowLayout.minimumLineSpacing = SCREEN_WIDTH - flowLayout.itemSize.width * 2 - flowLayout.sectionInset.left * 2;
        NSLog(@"%f %f %f",flowLayout.minimumLineSpacing,flowLayout.itemSize.width , flowLayout.sectionInset.left * 2);
        //两个而连续的cell之间的最小距离
        flowLayout.minimumInteritemSpacing = 1;
        //卷动的方向(默认是垂直的)
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        CGFloat x = 0;
        //        CGFloat y = 0;
        CGFloat w = [UIScreen mainScreen].bounds.size.width;
        CGFloat h = [UIScreen mainScreen].bounds.size.height;
        CGRect frame = CGRectMake(x,h / 7 * 6,w,h / 7);
        toolCollection_ = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
        toolCollection_.backgroundColor = [UIColor whiteColor];
        toolCollection_.delegate = self;
        toolCollection_.dataSource = self;
        
        UINib *nib = [UINib nibWithNibName:@"ToolCell" bundle:nil];
        [toolCollection_ registerNib:nib forCellWithReuseIdentifier:toolCellIdentifier];
    }
    return toolCollection_;
}

#pragma mark ToolCellDelegate

- (void)manageSection:(NSInteger)tag {
    if (tag == 10040) {
        if (willDeleteArr_.count > 0) {
            UIAlertController *choiceAlert = [UIAlertController alertControllerWithTitle:@"删除文章" message:@"确定删除所选的文章吗？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                // 删除
                for (SectionData *data in willDeleteArr_) {
                    DataModel *dataModel = [DataModel defaultDataModel];
                    NSString *s = [NSString stringWithFormat:@"%@",_deleteArr];
//                    if ([s containsString:[NSString stringWithFormat:@  "%@",dataModel.allSection]]) {
                    
                        if (_deleteArr == dataModel.recentPlay) {
                            data.isAddRecent = NO;
                            [dataModel.recentPlay removeObject:data];
                            [dataModel.recentPlayAndID removeObjectForKey:dataModel.recentPlayAndID[data.sectionID]];
                            [dataModel.recentPlayAndID removeObjectForKey:data.sectionID];
                        }
                        
                        if (_deleteArr == dataModel.allSection) {
                            [dataModel.allSection removeObject:data];
                            [dataModel.allSectionID removeObject:data.sectionID];
                            [dataModel.allSectionAndID removeObjectForKey: dataModel.allSectionAndID[data.sectionID]];
                            [dataModel.allSectionAndID removeObjectForKey:data.sectionID];
                        }
                        
                        if (_deleteArr == dataModel.downloadSection) {
                            data.isDownload = NO;
                            [dataModel.downloadSectionList removeObject:data.sectionID];
                            [dataModel.downloadSection removeObject:data];
                        }
                        
                        if (_deleteArr == dataModel.downloadingSections) {
                            [[dataModel mutableArrayValueForKey:@"downloadingSections"] removeObject:data];
                        }
                        
                        if (_deleteArr == dataModel.userLikeSection) {
                            data.isLike = NO;
                            [dataModel.userLikeSectionID removeObject:data.sectionID];
                            [dataModel.userLikeSection removeObject:data];
                        }

//                    }
//                    if ([s containsString:[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",dataModel.userLikeSection]]]) {
//                        if (data.isLike) {
//                            data.isLike = NO;
//                            [dataModel.userLikeSectionID removeObject:data.sectionID];
//                            [dataModel.userLikeSection removeObject:data];
//                        }
//                    }
//                    if ([s containsString:[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",dataModel.recentPlay]]]) {
//                        if (data.isAddRecent) {
//                            data.isAddRecent = NO;
//                            [dataModel.recentPlay removeObject:data];
//                        }
//                    }
//                    if ([s containsString:[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",dataModel.downloadSection]]]) {
//                        if (data.isDownload) {
//                            data.isDownload = NO;
//                            [dataModel.downloadSectionList removeObject:data.sectionID];
//                            [dataModel.downloadSection removeObject:data];
//                        }
//                    }
//                    if ([dataModel.downloadingSections containsObject:data]) {
//                        [[dataModel mutableArrayValueForKey:@"downloadingSections"] removeObject:data];
//                    }
                    [[SaveModule defaultObject] deleteFile:data.sectionID inDirectory:_deleteDirectoryName];
                    [[SaveModule defaultObject] deleteFile:data.sectionID inDirectory:@"mp3"];
                    [_deleteArr removeObject:data];
                }
                [[UserDataModel defaultDataModel] saveLocalData];
                [UIView transitionWithView:deleteTable_ duration: 0.4f options:UIViewAnimationOptionTransitionCrossDissolve animations: ^(void) {
                    [deleteTable_ reloadData];
                } completion:nil];
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [choiceAlert addAction:cancelAction];
            [choiceAlert addAction:deleteAction];
            [self presentViewController:choiceAlert animated:YES completion:nil];
        }
    }
    
    if (tag == 10041)
        if (willDeleteArr_.count > 0) {
            UIAlertController *choiceAlert = [UIAlertController alertControllerWithTitle:@"下载文章" message:@"确定下载所选的文章吗？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"下载" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                // 下载
                DataModel *dataModel = [DataModel defaultDataModel];
                if ([dataModel.downloadingSection isEqual:willDeleteArr_]) {
                    
                    [self dismissViewControllerAnimated:YES completion:nil];
                    return;
                }
                for (SectionData *s in willDeleteArr_) {
                    if (![dataModel.downloadingSections containsObject:s]) {
                        if (!s.isDownload) {                            
                            // 数组设置便于监听
                            NSLog(@"%@",s);
                            [[DownloadModule defaultDataModel].urlArr addObject:s.clickMp3];
                            [[dataModel mutableArrayValueForKey:@"downloadingSections"] addObject:s];
//                            NSLog(@"%@",[DownloadModule defaultDataModel].urlArr);
                        }
                    }
                }
                [self dismissViewControllerAnimated:YES completion:nil];
                [[UserDataModel defaultDataModel] saveLocalData];
//                [UIView transitionWithView:deleteTable_ duration: 0.4f options:UIViewAnimationOptionTransitionCrossDissolve animations: ^(void) {
//                    [deleteTable_ reloadData];
//                } completion:nil];
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [choiceAlert addAction:cancelAction];
            [choiceAlert addAction:deleteAction];
            [self presentViewController:choiceAlert animated:YES completion:nil];
        }
}

#pragma mark UICollectionViewDelegate & UICollectionViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ToolCell *toolCell = [collectionView dequeueReusableCellWithReuseIdentifier:toolCellIdentifier forIndexPath:indexPath];
    [toolCell.toolCellButton setTintColor:DEFAULT_COLOR];
    [toolCell.toolCellButton setImage:[UIImage imageNamed:@"shangcheng"] forState:UIControlStateNormal];
    toolCell.delegate = self;
    toolCell.toolCellButton.tag = 10040 + indexPath.row;
    if (indexPath.row == 1) {
        toolCell.toolCellLabel.text = @"下载";
        [toolCell.toolCellButton setImage:[UIImage imageNamed:@"xiazaiwenzhang"] forState:UIControlStateNormal];
    }
    toolCell.backgroundColor = [UIColor whiteColor];
    return toolCell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 2;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

#pragma mark UITableViewDelegate & UITableViewDataSource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 1、获得选中行
    SectionData *s = _deleteArr[indexPath.row];
    // 2、修改选中行的数据,将选中的cell添加到待删除数组中
    if ([willDeleteArr_ containsObject:s]) // 如果已经存在，再次点击就取消选中按钮
    {
        [willDeleteArr_ removeObject:s];
    }
    else    // 否则就添加待删除数组
    {
        [willDeleteArr_ addObject:s];
    }
    if (willDeleteArr_.count == _deleteArr.count) {
        [leftButton setTitle:@"取消全选" forState:UIControlStateNormal];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 1、获得选中行
    SectionData *s = _deleteArr[indexPath.row];
    // 2、修改选中行的数据,将选中的cell添加到待删除数组中
    if ([willDeleteArr_ containsObject:s]) // 如果已经存在，再次点击就取消选中按钮
    {
        [willDeleteArr_ removeObject:s];
    }
    if (willDeleteArr_.count != _deleteArr.count) {
        [leftButton setTitle:@"全选" forState:UIControlStateNormal];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BookCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:bookCell forIndexPath:indexPath];
    SectionData *s = (SectionData *)_deleteArr[indexPath.row];
    cell.sectionsName.text = ((SectionData *)_deleteArr[indexPath.row]).sectionName;
    if ([((SectionData *)_deleteArr[indexPath.row]).author isEqualToString:@""]) {
        cell.authorName.text = @"無名";
    } else {
        cell.authorName.text = ((SectionData *)_deleteArr[indexPath.row]).author;
    }
    
    if ([willDeleteArr_ containsObject:((SectionData *)_deleteArr[indexPath.row])]) {
//        [cell setSelected:YES animated:NO];
        [deleteTable_ selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
    
    cell.statusView.hidden = YES;
    cell.accessoryButton.hidden = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _deleteArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

@end
