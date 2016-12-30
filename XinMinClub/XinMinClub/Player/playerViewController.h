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

@property (nonatomic, assign) bool isPlay;
@property (nonatomic, assign) bool isPrepare;//播放器装备完毕
@property (nonatomic, strong) player *kj_player; /**< 播放器 */
@property (nonatomic, assign) int currentLyricNum;// 当前歌词位置
@property (nonatomic, assign) bool isSingleComplete;//单首播放完毕
@property (nonatomic, copy) NSMutableDictionary *dic;
@property (nonatomic, copy) NSMutableArray *lrcArray;
@property(nonatomic, strong) UIImageView *authorImageView; /**< 作者头像 */

////第一种数据传输方式
//// 书集数据
//- (void)getDataBookName:(NSString*)bookName BookID:(NSString*)bookID BookImageUrl:(NSString*)imageUrl AutorImaeUrl:(NSString*)autorImageUrl;
//// 章节数据
//- (void)getDataSectionNameArray:(NSArray*)nameArr SectionID:(NSArray*)IDArr;
//// 传递的数据(小节数据)
//- (void)getDataMp3NameArray:(NSArray*)nameArr Mp3UrlArray:(NSArray*)mp3Arr LyricArray:(NSArray*)lyricArr AutorNameArray:(NSArray*)autoNameArr Mp3IDArray:(NSArray*)IDArr;

+ (instancetype)defaultDataModel;

//第2种数据传输方式
// 小节数据Json
- (void)getJson:(NSDictionary*)json;
// 点击的那个小节
@property(nonatomic,assign) int touchNum;

- (void)instancePlay:(NSString *)state;

@end
