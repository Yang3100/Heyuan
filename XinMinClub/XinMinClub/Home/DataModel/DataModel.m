//
//  DataModel.m
//  XinMinClub
//
//  Created by 赵劲松 on 16/3/31.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "DataModel.h"
#import "DownloadModule.h"
#import "SaveModule.h"
#import "playerViewController.h"

@interface DataModel() {
    DownloadModule *download;
    SaveModule *saveModule;
    NSString *filePath;
    NSFileManager *fileManager;
}

@end

@implementation DataModel

+ (instancetype)defaultDataModel {
    
    static DataModel *dataModel;
    if (!dataModel) {
        dataModel = [[super allocWithZone:NULL] init];
        [dataModel initData];
    }
    
    return dataModel;
}

/**
 *  跳转到播放器或者电子书
 *
 *  json   传入数据
 *  num    点击的是哪个
 *  vc     视图控制器
 *  transfer   传输数据的方式，
 *  第1种数据传输方式 -  从最近播放、下载、我喜欢点入的方式
 *  第2种数据传输方式 -  从文集点入的方式
 */
- (void)pushWhereWithJson:(NSDictionary*)json ThouchNum:(int)num WithVC:(UIViewController*)vc Transfer:(int)transfer Data:(SectionData *)data{
    NSString *ss = [[[json valueForKey:@"RET"] valueForKey:@"Sys_GX_ZJ"][num] valueForKey:@"GJ_MP3"];
    if (data) {        
        ss = data.clickMp3;
        if (![ss isEqualToString:@""]) {
            [playerViewController defaultDataModel].mp3Url = ss;
        }
    }
    if (![ss isEqualToString:@""]) {
        if (transfer==1) {
            [[playerViewController defaultDataModel] getDict:json];
        }else if (transfer==2){
            [[playerViewController defaultDataModel] getJson:json];
        }else{
            return;
        }
        [playerViewController defaultDataModel].touchNum = num;
        [playerViewController defaultDataModel].title = [DataModel defaultDataModel].bookName;
        [vc.navigationController pushViewController:[playerViewController defaultDataModel] animated:YES];
    }else{
        EBookViewController *evc = [EBookViewController shareSingleOne];
//        [[EBookViewController alloc] init];
        if (transfer==1) {
            [evc fristGetDataWithDict:json thouchNum:num];
        }else if (transfer==2){
            [evc secondGetDataWithJson:json thouchNum:num];
        }else{
            return;
        }
        [vc presentViewController:evc animated:YES completion:^{
            evc.kj_title = [DataModel defaultDataModel].bookName;
        }];
    }
}

- (void)initData {
    
    download = [[DownloadModule alloc] init];
    saveModule = [SaveModule defaultObject];
    _process = [[ProcessSelect alloc] init];
    fileManager = [NSFileManager defaultManager];
    
    _addBook = NO;
    _playTimeOn = NO;
    _addRecent = NO;
    
    _allSection = [NSMutableArray array];
    _allSectionID = [NSMutableArray array];
    _allSectionAndID = [NSMutableDictionary dictionaryWithCapacity:10];
    
    _myBook = [NSMutableArray array];
    _myBookAndID = [NSMutableDictionary dictionaryWithCapacity:10];
    
    _allBook = [NSMutableArray array];
    _allBookAndID = [NSMutableDictionary dictionaryWithCapacity:10];
    
    _deleteSection = [NSMutableArray array];
    
    _downloadingSections = [NSMutableArray array];
    _downloadSection = [NSMutableArray array];
    _downloadSectionList = [NSMutableArray array];
    
    _playingArray = [NSMutableArray arrayWithCapacity:10];
    
    _recentPlay = [NSMutableArray array];
    _recentPlayAndID = [NSMutableDictionary dictionaryWithCapacity:10];
    _recentPlayIDAndCount = [NSMutableDictionary dictionaryWithCapacity:10];
    _recentPlayIDAndCount = [UserDataModel defaultDataModel].userRecentPlayIDAndCount;
    
    _userLikeBook = [NSMutableArray array];
    _userLikeBookID = [UserDataModel defaultDataModel].userLikeBookID;
    _recommandBook = [NSMutableArray array];
    _recommandBookID = [NSMutableArray array];
    
    _userLikeSection = [NSMutableArray array];
    _userLikeSectionID = [NSMutableArray array];
    //    _userLikeSectionID = [UserDataModel defaultDataModel].userLikeSectionID;
    
    //    _playTime = 60;
    //    if ([UserDataModel defaultDataModel].playTime) {
    //        _playTime = [[UserDataModel defaultDataModel].playTime intValue];
    //    }
    
//    [UserDataModel defaultDataModel].userLikeSection = _userLikeSection;
    
    [self getAllLocalBook];
    [self getLocalMP3List];
    [self getAllRecentPlaySection];
    [self getAllLocalSection];
    
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [self defaultDataModel];
}

- (NSArray *)getBookSecondLevelWithFirstLevel:(NSString *)firtLevelString andBookID:(NSString *)bookID{
    
    filePath = [NSString stringWithFormat:@"%@/Documents/bookFile/%@.plist", NSHomeDirectory(), bookID];
    if (![self createBookFile:filePath]) {
        return nil;
    }
    NSMutableDictionary *listDic;
    if (![[[NSMutableDictionary alloc]initWithContentsOfFile:filePath] objectForKey:@"list"]) {
        return nil;
    }
    else {
        listDic = [[[NSMutableDictionary alloc]initWithContentsOfFile:filePath] objectForKey:@"list"];
    }
    if (((NSArray *)[listDic objectForKey:firtLevelString]).count) {
        return nil;
    }
    return [listDic objectForKey:firtLevelString];
}

- (BOOL)createBookFile:(NSString *)path {
    if(![fileManager fileExistsAtPath:path]) {
        [fileManager createFileAtPath:path contents:nil attributes:nil];
        //设置属性值,没有的数据就新建，已有的数据就修改。
        NSMutableDictionary *usersDic = [NSMutableDictionary dictionaryWithCapacity:10];
        //        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"",nil];
        [usersDic setObject:[NSMutableDictionary dictionary] forKey:@"list"];
        [usersDic writeToFile:filePath atomically:YES];
        return YES;
    }
    return NO;
}

- (void)getLocalMP3List {
    filePath = [NSString stringWithFormat:@"%@/Library/Caches/mp3", NSHomeDirectory()];
    NSArray *arr = (NSArray *)[[NSFileManager defaultManager] contentsOfDirectoryAtPath:filePath error:nil];
    
    for (NSString *s in arr) {
        filePath = [NSString stringWithFormat:@"%@/Library/Caches/mp3/%@", NSHomeDirectory(), s];
        
        NSArray *sArr = [s componentsSeparatedByString:@"."];
        
        if ([sArr[0] isEqualToString:@""]) {
            continue;
        }
        if (![_downloadSectionList containsObject:sArr[0]]) {
            [_downloadSectionList addObject:sArr[0]];
        }
    }
}

- (BOOL)judgeLocalPath:(NSString *)path withUrl:(NSString *)url {
    
    // 判断是否为本地
    NSString *head = [[path componentsSeparatedByString:@"p"] firstObject];
    if ([head isEqualToString:@"htt"]) {
        return NO;
    }
    NSString *localLastPath = [[[path componentsSeparatedByString:@"/"] lastObject] componentsSeparatedByString:@"."][0];
    NSString *lastPath = [[[url componentsSeparatedByString:@"/"] lastObject] componentsSeparatedByString:@"."][0];
    
    if ([localLastPath isEqualToString:lastPath]) {
        return YES;
    }
    return NO;
}

- (void)getAllLocalSection {
    
//    [self getSection:@"sectionFile" into:_allSection];
}

- (void)addSectionToAll:(SectionData *)data {
    if (![_allSectionID containsObject:data.sectionID]) {
        _addAllBook = YES;
        [_allSection insertObject:data atIndex:0];
        [_allSectionID insertObject:data.sectionID atIndex:0];
        [_allSectionAndID setObject:[NSString stringWithFormat:@"%d",_allSectionAndID.count/2] forKey:data.sectionID];
        [_allSectionAndID setObject:data forKey:[NSString stringWithFormat:@"%ld",_allSectionAndID.count / 2]];
    }
}

- (void)getAllRecentPlaySection {
    
    [self getSection:@"recentPlaySection" into:_recentPlay];
}

- (void)getSection:(NSString *)directory into:(NSMutableArray *)array {
    filePath = [NSString stringWithFormat:@"%@/Library/Caches/%@", NSHomeDirectory(), directory];
    NSMutableArray *arr = (NSMutableArray *)[[NSFileManager defaultManager] contentsOfDirectoryAtPath:filePath error:nil];
    
    for (NSString *s in arr) {
        filePath = [NSString stringWithFormat:@"%@/Library/Caches/%@/%@", NSHomeDirectory(), directory, s];
        
        NSArray *sArr = [s componentsSeparatedByString:@"."];
        
        if ([sArr[0] isEqualToString:@""]) {
            continue;
        }
        //
        NSDictionary *json = [[NSDictionary alloc] initWithContentsOfFile:filePath];
        SectionData *data = [SectionData modelWithJSON:json];
        if ([data.author isEqualToString:@""]) {
            data.author = @"無名";
        }
        
        // 判断章节是否喜欢
        USER_DATA_MODEL.userLikeSectionID = DATA_MODEL.userLikeSectionID;
        USER_DATA_MODEL.userLikeSection = DATA_MODEL.userLikeSection;
        if (data.isLike) {
            if (![DATA_MODEL.userLikeSectionID containsObject:sArr[0]]) {
                [_userLikeSectionID addObject:data.sectionID];
                [_userLikeSection addObject:data];
            }
        }
        
        // 判断是否本地章节
        if ([_downloadSectionList containsObject:sArr[0]]) {
            data.isDownload = YES;
            data.clickMp3 = [NSString stringWithFormat:@"%@/Library/Caches/mp3/%@.mp3", NSHomeDirectory(), sArr[0]];
            [_downloadSection addObject:data];
        }
        
        [_recentPlayAndID setObject:[NSString stringWithFormat:@"%d",_recentPlayAndID.count/2] forKey:data.sectionID];
        [_recentPlayAndID setObject:data forKey:[NSString stringWithFormat:@"%ld",_recentPlayAndID.count / 2]];
        
        [self addSectionToAll:data];
//        NSLog(@"%@",data.dic);
        [array addObject:data];
    }
}

- (void)getAllLocalBook {
    
    filePath = [NSString stringWithFormat:@"%@/Library/Caches/bookFile", NSHomeDirectory()];
    NSMutableArray *arr = (NSMutableArray *)[[NSFileManager defaultManager] contentsOfDirectoryAtPath:filePath error:nil];
    //    if (arr.count) [arr removeObjectAtIndex:0];
    
    for (NSString *s in arr) {
        filePath = [NSString stringWithFormat:@"%@/Library/Caches/bookFile/%@", NSHomeDirectory(), s];
        NSMutableDictionary *usersDic;
        usersDic = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
        
        NSMutableDictionary *listDic;
        listDic = [[[NSMutableDictionary alloc]initWithContentsOfFile:filePath] objectForKey:@"list"];
        
        NSMutableDictionary *bookDic;
        bookDic = [usersDic objectForKey:@"book"];
        
        NSArray *sArr = [s componentsSeparatedByString:@"."];
        
        if ([sArr[0] isEqualToString:@""]) {
            continue;
        }
        
        NSMutableDictionary *secondLevelList = [NSMutableDictionary dictionaryWithCapacity:10];
        for (NSString *s in listDic[sArr[0]]) {
            NSArray *secondListDic = listDic[s];
            if (!secondListDic) {
                break;
            }
            [secondLevelList  setObject:secondListDic forKey:s];
        };
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             bookDic[@"bookName"],@"bookName",
                             bookDic[@"authorName"],@"authorName",
                             bookDic[@"imagePath"],@"imagePath",
                             bookDic[@"libraryDetails"], @"libraryDetails",
                             bookDic[@"libraryLanguage"], @"libraryLanguage",
                             bookDic[@"libraryType"], @"libraryType",
                             sArr[0],@"bookID",
                             bookDic[@"isMyBook"], @"isMyBook",
                             listDic[sArr[0]],@"firstLevelList",
                             secondLevelList,@"firstLevelListWithSecondLevelList",
                             nil];
        BookData *bookData = [[BookData alloc] initWithDic:dic];
        [_allBook addObject:bookData];
        [_allBookAndID setObject:bookData forKey:[NSString stringWithFormat:@"%d",_allBookAndID.count / 2]];
        [_allBookAndID setObject:[NSNull null] forKey:sArr[0]];
        NSLog(@"%@",bookDic);
        //        NSLog(@"%d",bookDic[@"isMyBook"]);
        if ([bookDic[@"isMyBook"] doubleValue] != 0.0) {
            [_myBook addObject:bookData];
            [_myBookAndID setObject:bookData forKey:[NSString stringWithFormat:@"%d",_myBookAndID.count / 2]];
            [_myBookAndID setObject:[NSNull null] forKey:sArr[0]];
        }
        
        // 判断文集是否喜欢
        if ([_userLikeBookID containsObject:sArr[0]]) {
            [_userLikeBook addObject:bookData];
        }
    }
}

// 添加到我的文集
- (BOOL)addMyLibrary:(NSDictionary *)dic {
    
//    [saveModule saveBookDataWithBookID:libraryID bookData:nil isMyBook:YES];
//    
//    if ([[_myBookAndID allKeys] containsObject:libraryID]) {
//        return NO;
//    }
//    
//    NSLog(@"%@%@%@",url,authorName,libraryID);
//    UIImageView *imageView = [[UIImageView alloc] init];
//    NSURL *urlString = [NSURL URLWithString:url];
//    
//    [imageView sd_setImageWithURL:urlString completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        if (![[_myBookAndID allKeys] containsObject:libraryID]) {
//            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
//                                 libraryID,@"bookID",
//                                 image, @"bookImage",
//                                 url, @"imagePath",
//                                 authorName, @"authorName",
//                                 bookName, @"bookName",
//                                 type, @"libraryType",
//                                 language, @"libraryLanguage",
//                                 details, @"libraryDetails",
//                                 nil];
//            BookData *data = [[BookData alloc] initWithDic:dic];
//            [_myBook addObject:data];
//            [_myBookAndID setObject:[NSString stringWithFormat:@"%ld",_myBookAndID.count / 2] forKey:data.bookID];
//            [_myBookAndID setObject:data forKey:[NSString stringWithFormat:@"%ld",_myBookAndID.count / 2]];
//            _addBook = YES;
//            NSLog(@"____%@+++++",_myBookAndID);
//        }
//        
//    }];
//    return YES;
    
    
    if ([[_myBookAndID allKeys] containsObject:[dic valueForKey:@"WJ_ID"]]) {
        return NO;
    }
    
    BookData *data = [self getBookDataWithDic:dic];
    [_myBook addObject:data];
    [_myBookAndID setObject:[NSString stringWithFormat:@"%ld",_myBookAndID.count / 2] forKey:data.bookID];
    [_myBookAndID setObject:data forKey:[NSString stringWithFormat:@"%ld",_myBookAndID.count / 2]];
    _addBook = YES;
    
    [saveModule saveBookDataWithBookID:data.bookID bookData:[[BookData alloc] initWithDic:[NSDictionary dictionaryWithObjectsAndKeys:data.bookName,@"bookName",data.authorName,@"authorName",data.imagePath,@"imagePath", data.type, @"libraryType", data.language, @"libraryLanguage", data.details, @"libraryDetails", data.bookID, @"WJ_ID",nil]] isMyBook:YES];
    
    return YES;
}

// 添加到全部文集
- (BOOL)addAllLibrary:(NSDictionary *)dic {
    
    if ([[_allBookAndID allKeys] containsObject:[dic valueForKey:@"WJ_ID"]]) {
        return NO;
    }
    
    BookData *data = [self getBookDataWithDic:dic];
    [_allBookAndID setObject:[NSString stringWithFormat:@"%ld",_allBookAndID.count / 2] forKey:data.bookID];
    [_allBookAndID setObject:data forKey:[NSString stringWithFormat:@"%ld",_allBookAndID.count / 2]];
    _addAllBook = YES;
    
    [saveModule saveBookDataWithBookID:data.bookID bookData:[[BookData alloc] initWithDic:[NSDictionary dictionaryWithObjectsAndKeys:data.bookName,@"bookName",data.authorName,@"authorName",data.imagePath,@"imagePath", data.type, @"libraryType", data.language, @"libraryLanguage", data.details, @"libraryDetails", data.bookID, @"WJ_ID",nil]] isMyBook:NO];
    
    return YES;
}

- (BookData *)getBookDataWithDic:(NSDictionary *)dic {
    NSString *bookName = [dic valueForKey:@"WJ_NAME"];
    NSString *authorName = [dic valueForKey:@"WJ_USER"];
    NSString *type = [dic valueForKey:@"WJ_TYPE"];
    NSString *details = [dic valueForKey:@"WJ_CONTENT"];
    NSString *language = [dic valueForKey:@"WJ_LANGUAGE"];
    NSString *libraryID = [dic valueForKey:@"WJ_ID"];
    //        kj_svc.libraryAuthorImageUrl = [IP stringByAppendingString:[dic valueForKey:@"WJ_TITLE_IMG"]];
    NSString *url = [NSString stringWithFormat:@"%@%@",IP,[dic valueForKey:@"WJ_FM"]];
    
    UIImage *defaultImage = [UIImage imageNamed:@"19"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 libraryID,@"bookID",
                                 bookName, @"bookName",
                                 url, @"imagePath",
                                 authorName, @"authorName",
                                 type, @"libraryType",
                                 language, @"libraryLanguage",
                                 details, @"libraryDetails",
                                 defaultImage, @"bookImage",
                                 nil];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    NSURL *urlString = [NSURL URLWithString:url];
    [imageView sd_setImageWithURL:urlString completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [dict setObject:image forKey:@"bookImage"];
    }];
    
    BookData *data = [[BookData alloc] initWithDic:dict];
    return data;
}

- (void)addRecentPlay:(NSDictionary *)dic {
    
    SectionData *data = [self getSectionWithDic:dic];
    
    if ([[_allSectionAndID allKeys] containsObject:data.sectionID]) {
        data = _allSectionAndID[_allSectionAndID[data.sectionID]];
    }
    
    NSLog(@"%@",data.playCount);
    [SAVE_MODEL saveRecentPlaySection:data withSectionID:data.sectionID];
    NSLog(@"%@",data.playCount);
    if ([[_recentPlayAndID allKeys] containsObject:data.sectionID]) {
        return;
    }
    
    [_recentPlayAndID setObject:[NSString stringWithFormat:@"%lu",_recentPlayAndID.count/2] forKey:data.sectionID];
    [_recentPlayAndID setObject:data forKey:[NSString stringWithFormat:@"%ld",_recentPlayAndID.count / 2]];
//    ((SectionData *)_recentPlayAndID[_recentPlayAndID[data.sectionID]]).playCount = [NSString stringWithFormat:@"%ld",[((SectionData *)_recentPlayAndID[_recentPlayAndID[data.sectionID]]).playCount integerValue] + 1];
    DATA_MODEL.playingSection = data;
    [self addSectionToAll:data];
}

- (SectionData *)getSectionWithDic:(NSDictionary *)dic {
    
    NSString *sectionID = [dic valueForKey:@"GJ_ID"];
    NSString *sectionName = [dic valueForKey:@"GJ_NAME"];
    NSString *authorName = [dic valueForKey:@"GJ_ZJ"];
    NSString *type = [dic valueForKey:@"GJ_TYP1"];
    NSString *details = [dic valueForKey:@"GJ_CONTENT_CN"];
    NSString *image = [dic valueForKey:@"image"];
    NSString *mp3 = [NSString stringWithFormat:@"%@%@", IP ,[dic valueForKey:@"GJ_MP3"]];
    if ([[dic valueForKey:@"GJ_MP3"] isEqualToString:@""]) {
        mp3 = @"";
    }
    
    NSString *playCount = @"0";
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          sectionID,@"sectionID",
                          sectionName, @"sectionName",
                          authorName, @"author",
                          type, @"bookName",
                          details, @"libraryDetails",
                          mp3, @"mp3",
                          playCount, @"playCount",
                          dic, @"dic",
                          image, @"image",
                          nil];
    SectionData *data = [[SectionData alloc] initWithDic:dict];
    return data;
}

- (BOOL)downloadSection:(NSString *)sectionID {
    
    if (![DATA_MODEL.allSectionAndID objectForKey:sectionID]) {
        return NO;
    }
    
    if ([DATA_MODEL.downloadingSections containsObject:[DATA_MODEL.allSectionAndID objectForKey:[DATA_MODEL.allSectionAndID objectForKey:sectionID]]]) {
        return NO;
    }
    
    if ([DATA_MODEL.downloadSection containsObject:[DATA_MODEL.allSectionAndID objectForKey:[DATA_MODEL.allSectionAndID objectForKey:sectionID]]]) {
        return NO;
    }
    
    SectionData * data = [DATA_MODEL.allSectionAndID objectForKey:[DATA_MODEL.allSectionAndID objectForKey:sectionID]];
    
    if ([data.clickMp3 isEqualToString:@""]) {
        return NO;
    }
    
    // 数组变化
    [[DATA_MODEL mutableArrayValueForKey:@"downloadingSections"] addObject:data];
    DATA_MODEL.isDownloading = YES;
    [DownloadModule defaultDataModel];
    return YES;
}

@end
