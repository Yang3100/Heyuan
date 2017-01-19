//
//  playerViewController.h
//  player
//
//  Created by 杨科军 on 2016/12/16.
//  Copyright © 2016年 杨科军. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "player.h"

@interface playerViewController : UIViewController

@property (nonatomic, assign) bool isPlay;  // 是否正在播放
@property (nonatomic, assign) bool isPrepare; //播放器装备完毕
@property (nonatomic, strong) player *kj_player; /**< 播放器 */
@property (nonatomic, assign) int currentLyricNum;// 当前歌词位置
@property (nonatomic, strong) NSMutableArray *currentSongs; // 当前歌单
@property (nonatomic, strong) NSMutableDictionary *dic;
@property (nonatomic, strong) NSMutableArray *lrcArray;
@property (nonatomic, strong) UIImageView *authorImageView; /**< 作者头像 */
@property (nonatomic, strong) NSString *mp3Url;

+ (instancetype)defaultDataModel;

//第1种数据传输方式 -  从最近播放、下载、我喜欢点入的方式
- (void)getDict:(NSDictionary*)dict;


//第2种数据传输方式 -  从文集点入的方式
// 小节数据Json
- (void)getJson:(NSDictionary*)json;
// 点击的那个小节
@property(nonatomic,assign) int touchNum;

- (void)instancePlay:(NSString *)state;

@end
