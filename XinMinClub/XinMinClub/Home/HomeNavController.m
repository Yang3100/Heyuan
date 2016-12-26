//
//  HomeNavController.m
//  XinMinClub
//
//  Created by 赵劲松 on 16/5/5.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "HomeNavController.h"
#import "FBKVOController.h"
#import "DataModel.h"
#import "DownloadModule.h"
//#import "PalyerViewController.h"
//#import "ReaderTableViewController.h"
#import "UserDataModel.h"

@interface HomeNavController () {
    DataModel *dataModel;
    DownloadModule *downloadModule;
    UserDataModel *userDataModel;
}

@end

@implementation HomeNavController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    downloadModule = [DownloadModule defaultDataModel];
    
    dataModel = [DataModel defaultDataModel];
    userDataModel = [UserDataModel defaultDataModel];
    [dataModel addObserver:self forKeyPath:@"downloadingSections" options:NSKeyValueObservingOptionNew context:nil];
    [userDataModel getUserData];
    [userDataModel getUserImage];

//    [[PalyerViewController shareObject ] viewDidLoad];
//    [[ReaderTableViewController shareObject] viewDidLoad];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"downloadingSections"]) {
        if (!dataModel.isDownloading) {
            if (dataModel.downloadingSections.count != 0) {
                dataModel.isDownloading = YES;
                dataModel.downloadingSection = [dataModel.downloadingSections objectAtIndex:0];
                [downloadModule startDownload:dataModel.downloadingSection];
            }
        }
    }
}

@end
