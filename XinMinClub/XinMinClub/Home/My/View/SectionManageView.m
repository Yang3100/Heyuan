//
//  SecionManageView.m
//  XinMinClub
//
//  Created by 赵劲松 on 16/4/14.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "SectionManageView.h"
#import "UserDataModel.h"
#import "DataModel.h"
#import "DownloadModule.h"

@interface SectionManageView () {
    CGRect selfFrame_;
    UserDataModel *userModel_;
    DataModel *dataModel_;
    DownloadModule *downloadMoudle_;
    
    UIControl *smBackView_;
    
    UIViewController *vc;
}

@property (nonatomic, strong) UIButton *downloadButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *fuckButton;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation SectionManageView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        userModel_ = [UserDataModel defaultDataModel];
        dataModel_ = [DataModel defaultDataModel];
        [self addSubview:self.likeButton];
        [self addSubview:self.cancelButton];
        [self addSubview:self.downloadButton];
        [self addSubview:self.fuckButton];
        [self addSubview:self.titleLabel];
        
    }
    return self;
}

- (void)setData:(SectionData *)data {
    _data = data;
    self.titleLabel.text = data.sectionName;
    _likeButton.enabled = YES;
    _downloadButton.enabled = YES;
    _downloadButton.enabled = YES;
    if (_data.isLike) {
        _likeButton.enabled = NO;
    }
    if (_data.isDownload) {
        _downloadButton.enabled = NO;
    }
    if ([dataModel_.downloadingSections containsObject:data]) {
        _downloadButton.enabled = NO;
    }
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        CGFloat x = 10;
        CGFloat y = -1;
        CGFloat w = [UIScreen mainScreen].bounds.size.width + 2;
        CGFloat h = 30;
        UILabel* label = [[UILabel alloc] init];
        label.frame = CGRectMake(x, y, w, h);
        label.backgroundColor = [UIColor clearColor]; // 背景颜色
//        label.text = @"第N章"; // 显示内容
        [label setFont:[UIFont systemFontOfSize:14]];
        label.textColor = DEFAULT_COLOR; // 文字颜色
//        [label roundedRectWithConerRadius:0 BorderWidth:1 borderColor:[UIColor colorWithWhite:0.847 alpha:1.000]];
        //        label.lineBreakMode = NSLineBreakByTruncatingTail; // 显示不下的时候尾部用...表示
        //        label.font = [UIFont systemFontOfSize:14.0f]; // 字体大小
        //        label.textAlignment = NSTextAlignmentCenter; // 设置文本对齐方式 中间对齐
        //        label.userInteractionEnabled = NO; // 让label支持触摸事件
        //        label.numberOfLines = 1; // 显示行数
        //        label.shadowColor = [UIColor grayColor]; // 文本阴影颜色
        //        label.shadowOffset = CGSizeMake(0, -1); // 偏移距离(阴影)
        //        label.highlighted = YES; //是否高亮显示
        //        label.layer.masksToBounds = YES; // 显示边框
        //        label.layer.cornerRadius = 5.0f; // 圆角半径
        //        label.layer.borderColor = [[UIColor grayColor] CGColor]; // 边框颜色
        //        label.layer.borderWidth = 1.0f; // 边框尺寸
        //        label.adjustsFontSizeToFitWidth = YES; //设置字体大小适应label宽度
        //        label.enabled = NO; // 文本是否可变
        
        _titleLabel = label;
    }
    return _titleLabel;
}


- (UIButton *)likeButton {
    if (!_likeButton) {
        _likeButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _likeButton.frame = CGRectMake(0, 30, SCREEN_WIDTH/3, 40);
        _likeButton.backgroundColor = [UIColor clearColor];
        [_likeButton setTitle:@"喜欢" forState:UIControlStateNormal];
        [_likeButton setTintColor:DEFAULT_COLOR];
        [_likeButton addTarget:self action:@selector(likeAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _likeButton;
}

- (UIButton *)downloadButton {
    if (!_downloadButton) {
        _downloadButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _downloadButton.frame = CGRectMake(SCREEN_WIDTH/3, 30, SCREEN_WIDTH/3, 40);
        _downloadButton.backgroundColor = [UIColor clearColor];
        [_downloadButton setTitle:@"下载" forState:UIControlStateNormal];
        [_downloadButton setTintColor:DEFAULT_COLOR];
        [_downloadButton addTarget:self action:@selector(downloadAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _downloadButton;
}

- (UIButton *)fuckButton {
    if (!_fuckButton) {
        _fuckButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _fuckButton.frame = CGRectMake(SCREEN_WIDTH * 2 / 3, 30, SCREEN_WIDTH/3, 40);
        _fuckButton.backgroundColor = [UIColor clearColor];
        [_fuckButton setTintColor:DEFAULT_COLOR];
        [_fuckButton setTitle:@"分享" forState:UIControlStateNormal];
        [_fuckButton addTarget:self action:@selector(fuckAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fuckButton;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _cancelButton.frame = CGRectMake(-1, SCREEN_HEIGHT / 6 - 35 , SCREEN_WIDTH + 1, 35 + 1);
        if (SCREEN_WIDTH <= 320) {
            _cancelButton.frame = CGRectMake(-1, SCREEN_HEIGHT / 6 + 5 , SCREEN_WIDTH + 1, 35 + 1);
        }
        _cancelButton.backgroundColor = [UIColor whiteColor];
        [_cancelButton setTintColor:[UIColor colorWithWhite:0.796 alpha:1.000]];
        [_cancelButton roundedRectWithConerRadius:0 BorderWidth:1 borderColor:[UIColor colorWithWhite:0.847 alpha:1.000]];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

#pragma mark Actions


- (void)cancelAction {
    [_delegate cacenl];
}

- (void)fuckAction {
    [_delegate cacenl];
    ShareView *ocsv = [[ShareView alloc]init];
    if (!kStringIsEmpty(_data.clickMp3)) {
        ocsv.setShareContent = ShareMusic;
        if ([DataModel defaultDataModel].bookFMImageUrl) {
            ocsv.thumbImage = [DataModel defaultDataModel].bookFMImageUrl;
        }else{
            ocsv.thumbImage = networkCachePicture;
        }
        ocsv.title = _data.sectionName;
        ocsv.musicUrl = _data.clickMp3;
        if ([_data.author isEqualToString:@""]) {
            ocsv.describe = @"和源";
        }else{
            ocsv.describe = _data.author;
        }
    }else{
        ocsv.setShareContent = ShareText;
        ocsv.text = [NSString stringWithFormat:@"标题:%@\n%@",[_data.dic valueForKey:@"GJ_NAME"],[_data.dic valueForKey:@"GJ_CONTENT_CN"]];
    }
    [self addSubview:ocsv];
}

- (void)downloadAction {
    if (!_data.isDownload) {
        _downloadButton.enabled = NO;
        // 数组变化
        [DATA_MODEL downloadSection:_data.sectionID];
//        [[dataModel_ mutableArrayValueForKey:@"downloadingSections"] addObject:_data];
//        dataModel_.isDownloading = YES;
//        if (!downloadMoudle_) {
//            downloadMoudle_ = [[DownloadModule alloc] init];
//        }
        //        [downloadMoudle_ startDownload:_data];
    }
    NSLog(@"下载");
}

- (void)likeAction {
    if ([DataModel defaultDataModel].isVisitorLoad) {
        [[DataModel defaultDataModel] pushLoadViewController];
        return;
    }
    if (!_data.isLike) {
        _data.isLike = YES;
        _likeButton.enabled = NO;
        [userModel_.userLikeSectionID insertObject:self.data.sectionID atIndex:0];
//        NSLog(@"id:%@ %@ %p %@",self.data.sectionID,userModel_.userLikeSectionID[0],userModel_.userLikeSectionID,dataModel_.allSection[0]);
//        [userModel_.userLikeSectionID removeAllObjects];
        [dataModel_.userLikeSection insertObject:self.data atIndex:0];
        userModel_.isChange = YES;
//        [[UserDataModel defaultDataModel] saveLocalData];
        [SAVE_MODEL saveRecentPlaySection:_data withSectionID:_data.sectionID];
    }
}

@end
