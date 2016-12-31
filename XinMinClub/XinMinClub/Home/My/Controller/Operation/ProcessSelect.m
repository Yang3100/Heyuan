    //
//  ProcessSelect.m
//  XinMinClub
//
//  Created by 赵劲松 on 16/4/27.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "ProcessSelect.h"
#import "BookCell.h"
#import "DataModel.h"
//#import "TransferStationObject.h"
#import "UserDataModel.h"
#import "SectionViewController.h"
//#import "KJ_BackTableViewController.h"
//#import "PalyerViewController.h"
//#import "ReaderTableViewController.h"

@interface ProcessSelect () {
//    TransferStationObject *transfer_;
    UIViewController *controller;
    
    NSMutableArray <NSMutableDictionary *> *saveDictArray;
    NSMutableDictionary *saveDictionary;
    
    NSArray *sectionArray;
    
    NSInteger saveTag; // 点击的是哪个cell
    
    // 传给播放器的数组
    NSMutableArray *detailsListArray;
    NSMutableArray *detailsListIDArray;
    NSMutableArray *detailsMp3Array;
    NSMutableArray *detailsNameArray;
    NSMutableArray *detailsCNArray;
    NSMutableArray *detailsANArray;
    NSMutableArray *detailsENArray;
}

@end

@implementation ProcessSelect

- (id)init {
    if (self = [super init]) {
//        transfer_ = [TransferStationObject shareObject];
    }
    return self;
}

- (void)initArr {
    
    sectionArray = [NSArray array];
    
    saveDictArray =[NSMutableArray array];
    
    detailsListIDArray = [NSMutableArray array];
    detailsListArray = [NSMutableArray array];
    detailsMp3Array = [NSMutableArray array];
    detailsNameArray = [NSMutableArray array];
    detailsCNArray = [NSMutableArray array];
    detailsANArray = [NSMutableArray array];
    detailsENArray = [NSMutableArray array];
}

- (void)processPlayAllButtonSelect:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath forData:(id)data inViewController:(UIViewController *)viewController {
    
    controller = viewController;
    
    [self initArr];
    [self playAll:0 section:data];
}

- (UIViewController *)popBookWithData:(BookData *)data {
    SectionViewController *svc = [[SectionViewController alloc] init];
    svc.title = data.bookName; // 书集名字
    
    [DataModel defaultDataModel].bookImageUrl = data.imagePath; // 书集封面Url
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:10];
    [dic setObject:data.imagePath forKey:@"WJ_IMG"];
    [dic setObject:data.bookName forKey:@"WJ_NAME"];
    [dic setObject:data.authorName forKey:@"WJ_USER"];
    [dic setObject:data.type forKey:@"WJ_TYPE"];
    [dic setObject:data.details forKey:@"WJ_CONTENT"];
    [dic setObject:data.language forKey:@"WJ_LANGUAGE"];
    [dic setObject:data.bookID forKey:@"WJ_ID"];
    [dic setObject:data.imagePath forKey:@"WJ_IMG"];
    [svc getJsonData:[[NSMutableDictionary alloc] initWithDictionary:dic]];
    
    return svc;
}

- (void)playAll:(NSInteger)num section:(id)data {
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:10];
    arr = (NSMutableArray *)data;
    sectionArray = arr;
    // 传递书集名字
    SectionData *da = arr[num];
//    _libraryName = da.libraryTitle;
    
    [[SaveModule defaultObject] saveRecentPlaySection:da withSectionID:da.clickSectionID];
    [DataModel defaultDataModel].playingSection = da;
    
    // 保存点击的是哪个cell
    saveTag = num;
    // 整理数组
    [self arrangeAndSaveDataArray:arr];
    // 存入到字典当中
    [self saveDataToDictionary:arr];
    NSInteger a = [[saveDictArray[saveTag] valueForKey:@"CN"] integerValue]==1 ? 1:0; //a=1点击这个有中文
    NSInteger b = [[saveDictArray[saveTag] valueForKey:@"AN"] integerValue]==1 ? 1:0;
    NSInteger c = [[saveDictArray[saveTag] valueForKey:@"EN"] integerValue]==1 ? 1:0;
    
    // 默认简体中文
    switch ([DataModel defaultDataModel].setDefaultLanguage) {
        case 0: // 默认中文
            if (a) {
                [self popWithArray:detailsCNArray];
            }else{
//                [self alertView:@[@(a),@(b),@(c)]];
            }
            break;
        case 1: // 默认繁体
            if (b) {
                [self popWithArray:detailsANArray];
            }else{
//                [self alertView:@[@(a),@(b),@(c)]];
            }
            break;
        case 2: // 默认英文
            if (c) {
                [self popWithArray:detailsENArray];
            }else{
//                [self alertView:@[@(a),@(b),@(c)]];
            }
            break;
    }
}

#pragma mark 整理与保存传入过来的数据到各个数组当中
- (void)arrangeAndSaveDataArray:(NSMutableArray *)data {
    [detailsListIDArray removeAllObjects]; // 清空数组
    [detailsListArray removeAllObjects]; // 清空数组
    [detailsMp3Array removeAllObjects]; // 清空数组
    [detailsCNArray removeAllObjects]; // 清空数组
    [detailsANArray removeAllObjects]; // 清空数组
    [detailsENArray removeAllObjects]; // 清空数组
    [detailsNameArray removeAllObjects];
    
    for (NSInteger k = 0; k < data.count; k++) {
        SectionData *da = data[k];
        [detailsListArray addObject:da.clickTitle];
        [detailsListIDArray addObject:da.clickSectionID];
        [detailsMp3Array addObject:da.clickMp3];
        [detailsCNArray addObject:da.clickSectionCNText];
        [detailsANArray addObject:da.clickSectionANText];
        [detailsENArray addObject:da.clickSectionENText];
        [detailsNameArray addObject:da.clickAuthor];
    }
}

-(void)saveDataToDictionary:(NSMutableArray *)data {
    //saveDictArray 存放编辑好键值对
    [saveDictArray removeAllObjects];
    for (NSInteger i=0; i<data.count; i++) {
        saveDictionary = [NSMutableDictionary dictionary];
        [saveDictionary addEntriesFromDictionary:@{@"arrayTag":@(0),@"CN":@(0),@"AN":@(0),@"EN":@(0)}];
        if(![detailsCNArray[i] isEqualToString:@""])
            [saveDictionary addEntriesFromDictionary:@{@"arrayTag":@(i),@"CN":@(1)}];
        if(![detailsANArray[i] isEqualToString:@""])
            [saveDictionary addEntriesFromDictionary:@{@"arrayTag":@(i),@"AN":@(1)}];
        if(![detailsENArray[i] isEqualToString:@""])
            [saveDictionary addEntriesFromDictionary:@{@"arrayTag":@(i),@"EN":@(1)}];
        [saveDictArray addObject:saveDictionary];
    }
}

- (void)popWithArray:(NSArray *)array{
    
    NSString *aUrl;
    if ([DataModel defaultDataModel].playingSection.libraryAuthorImageUrl!=nil) {
        aUrl = [DataModel defaultDataModel].playingSection.libraryAuthorImageUrl;
    }else {
        aUrl = @"";
    }
#warning aa aaaaaaaaaaaa
//    [[TransferStationObject shareObject] IncomingDataLibraryName:[DataModel defaultDataModel].playingSection.libraryTitle  ImageUrl:aUrl  AuthorName:detailsNameArray ClickCellNum:saveTag+1 SectionName:detailsListArray SectionMp3:detailsMp3Array SectionID:detailsListIDArray SectionText:array data:sectionArray block:^(BOOL successful) {
//        if (successful) {
//            [self kj_pushIsPlayerOrEBook:1];
//        }else
//            [self kj_pushIsPlayerOrEBook:2];
//    }];
}

- (void)processTableSelect:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath forData:(id)data inViewController:(UIViewController *)viewController{
    
    controller = viewController;
    
    NSMutableArray *arr = [NSMutableArray arrayWithObject:data];
    
    DataModel *dataModel_ = [DataModel defaultDataModel];
    
    if (indexPath.section == 0) {
        if (indexPath.row > 0) {
            
            SectionData *data = ((SectionData *)arr[0]);
            
            BookCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.statusView.hidden = NO;
            
            // 判断、设置播放状态等
            if (![data isEqual:((SectionData *)dataModel_.playingSection)]) {
                dataModel_.playingSection = arr[0];
                // 设置播放次数
                NSInteger a = [data.playCount intValue];
                a++;
                NSLog(@"%@playCount:%d", data.sectionName, a);
                data.playCount = [NSString stringWithFormat:@"%d",a];
//                [dataModel_.recentPlayIDAndCount setObject:data.playCount forKey:data.sectionID];
                
                // 设置cell选中状态
                NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
                [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
                
                [[UserDataModel defaultDataModel] saveLocalData];
                
                NSString *aUrl;
                if (data.libraryAuthorImageUrl!=nil) {
                    aUrl = data.libraryAuthorImageUrl;
                }else {
                    aUrl = @"";
                }
                #warning aa aaaaaaaaaaaa
//                [transfer_ IncomingDataLibraryName:data.libraryTitle  ImageUrl:aUrl  AuthorName:@[data.clickAuthor] ClickCellNum:1 SectionName:@[data.clickTitle] SectionMp3:@[data.clickMp3] SectionID:@[data.clickSectionID] SectionText:@[data.clickSectionCNText] data:arr block:^(BOOL successful) {
//                    if (successful) {
//                        [self kj_pushIsPlayerOrEBook:1];
//                    }else
//                        [self kj_pushIsPlayerOrEBook:2];
//                }];
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:10];
//                [dic setObject:<#(nonnull id)#> forKey:<#(nonnull id<NSCopying>)#>];
//                [dic setObject:<#(nonnull id)#> forKey:<#(nonnull id<NSCopying>)#>];
                playerViewController *svc = [playerViewController defaultDataModel];
                svc.title = data.bookName; // 书集名字
                [DataModel defaultDataModel].bookImageUrl = data.libraryImageUrl; // 书集封面Url
                [svc getDict:data.dic];
                [controller.navigationController pushViewController:svc animated:YES];
            } else {
//                [self kj_pushIsPlayerOrEBook:1];
            }
        }
    }
}

// 通知的方法
- (void)kj_pushIsPlayerOrEBook:(NSInteger)kj_integer{
    
    if (kj_integer==1) {
//        [controller.navigationController pushViewController:[PalyerViewController shareObject] animated:YES];
    }
    if (kj_integer==2) {
//        [controller.navigationController pushViewController:[ReaderTableViewController shareObject] animated:YES];
    }
}


@end
