//
//  cleanUpView.m
//  XinMinClub
//
//  Created by 杨科军 on 2017/1/20.
//  Copyright © 2017年 yangkejun. All rights reserved.
//

#import "cleanUpView.h"

#define cleanHeight ([UIScreen mainScreen].bounds.size.height/14)

@interface cleanUpView(){
    BOOL isSelectFile;
    BOOL isSelectImage;
    BOOL isSelectMusic;
    UIButton *fileBut;
    UIButton *imageBut;
    UIButton *musicBut;
    
    BOOL isAllSelect;
    NSMutableArray *buttonArray;
}

@end

@implementation cleanUpView

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"清理缓存";
    isSelectFile = NO;
    isSelectImage = NO;
    isSelectMusic = NO;
    isAllSelect = NO;
    
    [self initView];
}

- (void)initView{
    UILabel *iamgeview = [[UILabel alloc] init];
    iamgeview.frame = CGRectMake(20, 64, SCREEN_WIDTH-90, cleanHeight-1);
    iamgeview.text = @"注意！清理后就消失了哦~";
    iamgeview.textColor = RGB255_COLOR(68.0, 68.0, 68.0, 1.0);
    [self.view addSubview:iamgeview];
    
    UIButton *bu = [UIButton buttonWithType:UIButtonTypeCustom];
    bu.frame = CGRectMake(SCREEN_WIDTH-70, 64, 50, cleanHeight-1);
    [bu setTitle:@"全选" forState:UIControlStateNormal];
    bu.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [bu setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    bu.tag = 6;
    [bu addTarget:self action:@selector(butAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bu];
    
    buttonArray = [NSMutableArray array];
    
    NSArray *nameArray = @[@"清除缓存文件",@"清除缓存图片",@"清除缓存音乐"];
    NSArray *sizeArray = @[[self fileCache],[self imageCache],[self musicCache]];
    for (int i = 0; i < 3; i++) {
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.frame = CGRectMake(20, iamgeview.frame.origin.y+cleanHeight*(i+1), SCREEN_WIDTH-40, cleanHeight-1);
        but.tag = i;
        [but addTarget:self action:@selector(butAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *im = [[UIImageView alloc] initWithFrame:CGRectMake(0, cleanHeight/4, cleanHeight/2, cleanHeight/2)];
        im.image = [UIImage imageNamed:@"select"];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(cleanHeight/2+10, cleanHeight/4,SCREEN_WIDTH-cleanHeight*2-40-cleanHeight/2, cleanHeight/2)];
        label.text = nameArray[i];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-cleanHeight*2-40, cleanHeight/4, cleanHeight*2, cleanHeight/2)];
        label2.text = sizeArray[i];
        label2.textAlignment = NSTextAlignmentRight;
        
        [but addSubview:im];
        [but addSubview:label];
        [but addSubview:label2];
        [self.view addSubview:but];
        [buttonArray addObject:but];
    }
    
    for (int a = 1; a < 5; a++) {
        UIImageView *ima = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SplitLine"]];
        ima.frame = CGRectMake(20, iamgeview.frame.origin.y+cleanHeight*a, SCREEN_WIDTH-40, 1);
        [self.view addSubview:ima];
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake((SCREEN_WIDTH-SCREEN_WIDTH/2)/2, iamgeview.frame.origin.y+6*cleanHeight-20, SCREEN_WIDTH/2, cleanHeight);
    button.tag = 5;
    [button addTarget:self action:@selector(butAction:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    [self.view addSubview:button];
}

- (IBAction)butAction:(UIButton*)sender{
    if (sender.tag==0) {
        fileBut = sender;
        UIImageView *image = sender.subviews[0];
        if (!isSelectFile) {
            isSelectFile = !isSelectFile;
            image.image = [UIImage imageNamed:@"select2"];
        }else{
            isSelectFile = !isSelectFile;
            image.image = [UIImage imageNamed:@"select"];
        }
    }else if (sender.tag==1) {
        imageBut = sender;
        UIImageView *image = sender.subviews[0];
        if (!isSelectImage) {
            isSelectImage = !isSelectImage;
            image.image = [UIImage imageNamed:@"select2"];
        }else{
            isSelectImage = !isSelectImage;
            image.image = [UIImage imageNamed:@"select"];
        }
    }else if (sender.tag==2) {
        musicBut = sender;
        UIImageView *image = sender.subviews[0];
        if (!isSelectMusic) {
            isSelectMusic = !isSelectMusic;
            image.image = [UIImage imageNamed:@"select2"];
        }else{
            isSelectMusic = !isSelectMusic;
            image.image = [UIImage imageNamed:@"select"];
        }
    }else if (sender.tag==5) {
        NSLog(@"cleanUp!!");
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD show];
        [self performSelector:@selector(success) withObject:nil afterDelay:0.6f];
        if (isSelectFile) {
            UILabel *label = fileBut.subviews[2];
            label.text = @"0.00K";
        }
        if (isSelectImage) {
            UILabel *label = imageBut.subviews[2];
            // 清除sdwebImage缓存的图片
            [[LoadAnimation defaultDataModel] clearTmpPics];
            label.text = @"0.00K";
        }
        if (isSelectMusic) {
            UILabel *label = musicBut.subviews[2];
            // 清除缓存音乐
            [player clearCache];
            label.text = @"0.00K";
        }
    }else if (sender.tag==6){
        fileBut = buttonArray[0];
        UIImageView *image1 = fileBut.subviews[0];
        imageBut = buttonArray[1];
        UIImageView *image2 = imageBut.subviews[0];
        musicBut = buttonArray[2];
        UIImageView *image3 = musicBut.subviews[0];
        if (!isAllSelect) {
            isAllSelect = !isAllSelect;
            [sender setTitle:@"全不选" forState:UIControlStateNormal];
            isSelectFile = YES;
            isSelectImage = YES;
            isSelectMusic = YES;
            image1.image = [UIImage imageNamed:@"select2"];
            image2.image = [UIImage imageNamed:@"select2"];
            image3.image = [UIImage imageNamed:@"select2"];
        }else{
            isAllSelect = !isAllSelect;
            [sender setTitle:@"全选" forState:UIControlStateNormal];
            isSelectFile = NO;
            isSelectImage = NO;
            isSelectMusic = NO;
            image1.image = [UIImage imageNamed:@"select"];
            image2.image = [UIImage imageNamed:@"select"];
            image3.image = [UIImage imageNamed:@"select"];
        }
    }
}

#pragma mark ProgressMethods

- (void)dismiss {
    [SVProgressHUD dismiss];
}

- (void)success {
    [SVProgressHUD showSuccessWithStatus:@"Clean Up!"];
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.5f];
}

#pragma mark 图片缓存
- (NSString*)imageCache{
    float tmpSize = [[SDImageCache sharedImageCache] getDiskCount];
    NSString *clearCacheName = tmpSize >= 1 ? [NSString stringWithFormat:@"%.2fM",tmpSize] : [NSString stringWithFormat:@"%.2fK",tmpSize * 1024];
    NSLog(@"%@",clearCacheName);
    return clearCacheName;
}

#pragma mark 音乐缓存
- (NSString*)musicCache{
    float tmpSize = [SUFileHandle fileSize]/1000.0/1000;
    NSString *clearCacheName = tmpSize >= 1 ? [NSString stringWithFormat:@"%.2fM",tmpSize] : [NSString stringWithFormat:@"%.2fK",tmpSize * 1024];
    NSLog(@"%@",clearCacheName);
    return clearCacheName;
}

#pragma mark 文件缓存
- (NSString*)fileCache{
    float tmpSize = [self fileSize]/1000.0/1000;
    NSString *clearCacheName = tmpSize >= 1 ? [NSString stringWithFormat:@"%.2fM",tmpSize] : [NSString stringWithFormat:@"%.2fK",tmpSize * 1024];
    NSLog(@"%@",clearCacheName);
    return clearCacheName;
}

- (unsigned long long)fileSize{
    // 总大小
    unsigned long long size = 0;
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *path = [[[NSHomeDirectory() stringByAppendingPathComponent:@"Library"] stringByAppendingPathComponent:@"Caches"] stringByAppendingPathComponent:@"recentPlaySection"]; // 缓存文件路径
    BOOL isDir = NO;
    BOOL exist = [manager fileExistsAtPath:path isDirectory:&isDir];
    
    // 判断路径是否存在
    if (!exist) return size;
    if (isDir) { // 是文件夹
        NSDirectoryEnumerator *enumerator = [manager enumeratorAtPath:path];
        for (NSString *subPath in enumerator) {
            NSString *fullPath = [path stringByAppendingPathComponent:subPath];
            size += [manager attributesOfItemAtPath:fullPath error:nil].fileSize;
        }
    }else{ // 是文件
        size += [manager attributesOfItemAtPath:path error:nil].fileSize;
    }
    return size;
}

@end
