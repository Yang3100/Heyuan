//
//  SaveClass.m
//  XinMinClub
//
//  Created by yangkejun on 16/4/7.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "SaveClass.h"
#import <AVKit/AVKit.h>

@interface SaveClass() <NSURLSessionDelegate>{
    NSUserDefaults *myVersionNumber;
    NSURLSessionDownloadTask *task_;
    NSURLSession *session_;
    NSData *resumeData_; // 保存下载的东西
    NSString *myBookImageD;
    int offId;
}

@end

@implementation SaveClass

+(instancetype)shareObject{
    static SaveClass *model = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        model = [[super allocWithZone:NULL] init];
    });
    return model;
}
// 根据书集的标号判断是否已经存在本地
- (NSArray*)isSave:(NSString *)bookNum VersionNumber:(NSString *)Version{
    myVersionNumber  =[[NSUserDefaults alloc]init];
    NSArray *versionNumber=[myVersionNumber  arrayForKey:@"bookNum"];
    for (int i=0;i<versionNumber.count;i++) {
        if ([versionNumber[i] isEqualToString:bookNum]) {
            NSArray *cache=[myVersionNumber  arrayForKey:bookNum];
            if ([cache[2] isEqualToString:Version]) {
                return cache;
            }
            return nil;//本地存在缓存
        }
    }

    return nil;
}


// 保存数据到本地(根据版本号和书的ID)
- (BOOL)saveData:(SaveData *)saveData bookNum:(NSString *)bookNum versionNum:(NSString *)versionNum{
    NSArray *versionNumber=[myVersionNumber  arrayForKey:@"bookNum"];
    NSArray *cache=[myVersionNumber  arrayForKey:bookNum];
    for (NSString *name in versionNumber) {
        if ([name isEqualToString:bookNum]) {
            return NO; //如果本地已经存在缓存,不进行本地存储
        }
    }
    myBookImageD=bookNum;
    NSMutableArray *myBookNum =[NSMutableArray array];
    NSMutableArray *versionNumber1=[versionNumber mutableCopy];
    NSMutableArray *mycache =[NSMutableArray array];
    NSMutableArray *cache1=[cache mutableCopy];
    if (cache1==nil) {
        [mycache addObject:@"MyCache"];
    }
    else{
        mycache=cache1;
    }
    if (versionNumber1==nil) {
        [myBookNum addObject:@"myBookNum"];
    }
    else{
        myBookNum=versionNumber1;
    }
    [myBookNum addObject:bookNum];
    SaveData *data=saveData;
    [mycache addObject:data.bookNum];
    [mycache addObject:data.versionNum];
    [mycache addObject:@"没有数据"];
    offId=3;
    [self downloadImage:data.bookImageUrl];
    [mycache addObject:data.bookTitle];
    [mycache addObject:data.bookAuthorName];
    [mycache addObject:@"没有数据"];
    [self downloadImage:data.bookAuthorImageUrl];
    [mycache addObject:data.bookContent];
    [mycache addObject:data.bookDetails];
    [myVersionNumber setObject:mycache forKey:bookNum];
    [myVersionNumber setObject:myBookNum forKey:@"bookNum"];
    [myVersionNumber synchronize];
    return YES;
}

// 删除本地全部数据
- (BOOL)deleteAllData{
    NSUserDefaults *Data=[[NSUserDefaults alloc]init];
    NSArray *versionNumber=[Data  arrayForKey:@"bookNum"];
    for (NSString *AllData in versionNumber) {
        [Data removeObjectForKey:AllData];
    }
    [Data removeObjectForKey:@"bookNum"];
    [Data synchronize];

    return YES;
}

- (void)downloadImage:(NSString *)Imageurl {
    
    // 创建请求对象
    NSString *encodeUrlString = [Imageurl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]; // 转码(有的web不支持中文)
    NSURL *url = [NSURL URLWithString:encodeUrlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 创建会话配置对象
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    // 创建会话对象(需要包含协议NSURLSessionDelegate)
    session_ = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
    
    // 获取dowloadTask对象
    task_ = [session_ downloadTaskWithRequest:request];
    
    [task_ resume]; // 恢复task
}
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    // 把URL转化为本地路径
    // 将下载的文件拷贝到/Liberary/Preferences目录
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *liberaryURL = [fileManager URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask][0]; // 追加路径
    NSURL *preferencesURL = [liberaryURL URLByAppendingPathComponent:@"Preferences"];
    NSURL *desURL = [preferencesURL URLByAppendingPathComponent:[location lastPathComponent]];
    
    // 拷贝路径
    [fileManager removeItemAtURL:desURL error:nil];// 如果之前有，就删除原文件
    [fileManager copyItemAtURL:location toURL:desURL error:nil];
      // 获得路径
        NSArray *cache=[myVersionNumber  arrayForKey:myBookImageD];
        NSMutableArray *NSMCache=[cache mutableCopy];
        NSMCache[offId]=[desURL path];
        [myVersionNumber setObject:NSMCache forKey:myBookImageD];
    offId=6;
}
-(void)aaaaa:(NSString*)a{
    NSArray *cache=[myVersionNumber  arrayForKey:a];
    NSLog(@"%@",cache);
}

@end
