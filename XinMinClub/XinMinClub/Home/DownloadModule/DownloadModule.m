//
//  DownloadModule.m
//  XinMinClub
//
//  Created by 赵劲松 on 16/5/4.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "DownloadModule.h"

#define URL @"http://p1.pichost.me/i/40/1639665.png"

@interface DownloadModule() <NSURLSessionDownloadDelegate> {
    NSURLSessionDownloadTask *task_;
    NSData *resumeData_;
    NSURLSession *session_;
    NSTimer *timer;
    dispatch_queue_t progressQueue;
    NSFileManager *fileManager;
    NSString *mp3Dir;
}

@end

@implementation DownloadModule

+ (instancetype)defaultDataModel {
    
    static DownloadModule *download;
    if (!download) {
        download = [[super allocWithZone:NULL] init];
        [download initData];
    }
    
    return download;
}

- (void)initData {
    progressQueue = dispatch_queue_create("progressQueue", DISPATCH_QUEUE_CONCURRENT);
    _urlArr = [NSMutableArray arrayWithCapacity:10];
//    urlArr = @[@"",@"http://e.hiphotos.baidu.com/zhidao/pic/item/b3b7d0a20cf431ad9fhttp://d.3987.com/fengg_150130/010.jpgdc6d1e4836acaf2edd988e.jpg",@"http://d.3987.com/shuione_140808/004.jpg",@"http://www.bz55.com/uploads/allimg/150305/140-150305104F3.jpg",@"http://www.bz55.com/uploads/allimg/150305/140-150305104F2.jpg",@"http://www.bz55.com/uploads/allimg/150305/140-150305104F4-50.jpg",@"http://www.bz55.com/uploads/allimg/150305/140-150305104F6-50.jpg"];
    
    fileManager = [NSFileManager defaultManager];
    //  如果不存在就创建文件夹
    mp3Dir = [NSString stringWithFormat:@"%@/Library/Caches/%@", NSHomeDirectory(), @"mp3"];
    BOOL isDir = NO;
    BOOL existed = [fileManager fileExistsAtPath:mp3Dir isDirectory:&isDir];
    if (!(isDir == YES && existed == YES))
    {
        [fileManager createDirectoryAtPath:mp3Dir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    /**********************************************************/
    
    //    删除文件夹及文件级内的文件：
    //    NSString *imageDir = [NSString stringWithFormat:@"%@/Caches/%@", NSHomeDirectory(), dirName];
    //    NSFileManager *fileManager = [NSFileManager defaultManager];
    //    [fileManager removeItemAtPath:imageDir error:nil];
    /**********************************************************/
}

- (void)addProgressValue {
    if ((int)_sectionData.progress == 1) {
        DataModel *dataModel = [DataModel defaultDataModel];
        dataModel.isDownloading = NO;
        _sectionData.isDownload = YES;
        timer.fireDate = [NSDate distantFuture];
        if (dataModel.downloadingSections.count > 0) {
            [[dataModel mutableArrayValueForKey:@"downloadingSections"] removeObjectAtIndex:0];
            if (dataModel.downloadingSections.count > 1) {
                dataModel.downloadingSection = [dataModel.downloadingSections objectAtIndex:0];
            }
        }
        [_delegate finishDownloadSection];
        return;
    }
    _sectionData.progress = _sectionData.progress + 0.01;
    NSLog(@"%@:%f", _sectionData.sectionName, _sectionData.progress);
}

- (void)startDownload:(SectionData *)sectionData {
    
    _sectionData = sectionData;
//    timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(addProgressValue) userInfo:nil repeats:YES];
//    // 将timer加入到当前的run loop中,并将run loop mode设置为UITrackingRunLoopMode或NSRunLoopCommonModes,这样,即使用户触摸了屏幕,也不会导致timer暂停界面刷新.
//    [[NSRunLoop currentRunLoop] addTimer:timer forMode:UITrackingRunLoopMode];

    // 创建请求对象
    NSString *encodeUrlString = [sectionData.clickMp3 stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:encodeUrlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 创建会话配置对象
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    // 创建会话对象
    session_ = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
    
    
    // 获取downloadTask对象
    task_ = [session_ downloadTaskWithRequest:request];
    [task_ resume];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
    
    // 将下载的文件拷贝到/Cache目录中
    NSString *mp3URLString = [NSString stringWithFormat:@"%@/%@.mp3",mp3Dir,_sectionData.clickSectionID];
    NSURL *desURL = [NSURL URLWithString:[NSString stringWithFormat:@"file://%@",mp3URLString]];
    
    [fileManager removeItemAtURL:desURL error:nil];// 删除同名文件
    [fileManager copyItemAtURL:location toURL:desURL error:nil];// 目标目录有同名文件会报错
    
    if ((int)_sectionData.progress == 1) {
        DataModel *dataModel = [DataModel defaultDataModel];
        dataModel.isDownloading = NO;
        _sectionData.isDownload = YES;
        if (![dataModel.downloadSectionList containsObject:_sectionData.clickSectionID]) {
            [dataModel.downloadSectionList addObject:_sectionData.clickSectionID];
            [dataModel.downloadSection addObject:_sectionData];
        } else {
            
        }
        if (![dataModel.allSectionID containsObject:_sectionData.clickSectionID]) {
            [dataModel.allSectionID addObject:_sectionData.clickSectionID];
            [dataModel.allSection insertObject:_sectionData atIndex:0];
        }
        timer.fireDate = [NSDate distantFuture];
        NSLog(@"finish:%@",dataModel.downloadingSection.sectionName);
        if (dataModel.downloadingSections.count > 0) {
            [[dataModel mutableArrayValueForKey:@"downloadingSections"] removeObjectAtIndex:0];
            if (dataModel.downloadingSections.count > 1) {
                dataModel.downloadingSection = [dataModel.downloadingSections objectAtIndex:0];
            }
        }
        [_delegate finishDownloadSection];
        return;
    }
}

// 提供对于较大文件每一次传得数据包，已经接受的数据包，总共需要下载的数据包的数据
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    
    _sectionData.progress = totalBytesWritten / 1.0 / totalBytesExpectedToWrite;
//    NSLog(@"%f",_sectionData.progress);
}

// 暂停下载
- (void)pauseDownload {
    [task_ cancelByProducingResumeData:^(NSData * resumeData) {
        resumeData_ = resumeData;
        NSLog(@"XXX - %ld",(unsigned long)resumeData_.length);
    }];
    task_ = nil;
}

// 继续下载
- (void)resumeDownload {
    NSLog(@"AB%ld",(unsigned long)resumeData_.length);
    task_ = [session_ downloadTaskWithResumeData:resumeData_];
    [task_ resume];
}

@end
