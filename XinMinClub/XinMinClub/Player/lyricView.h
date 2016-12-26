//
//  lyricTableView.h
//  player
//
//  Created by 杨科军 on 2016/12/16.
//  Copyright © 2016年 杨科军. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface lyricView : UIView

- (void)initView;
- (void)getLyric:(NSArray*)lyricArr;

@property(nonatomic,assign) NSInteger lyricLocation;//当前歌词滚动位子

@end
