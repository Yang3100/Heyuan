//
//  playerViewController.h
//  player
//
//  Created by 杨科军 on 2016/12/16.
//  Copyright © 2016年 杨科军. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface playerViewController : UIViewController

////第一种数据传输方式
//// 书集数据
//- (void)getDataBookName:(NSString*)bookName BookID:(NSString*)bookID BookImageUrl:(NSString*)imageUrl AutorImaeUrl:(NSString*)autorImageUrl;
//// 章节数据
//- (void)getDataSectionNameArray:(NSArray*)nameArr SectionID:(NSArray*)IDArr;
//// 传递的数据(小节数据)
//- (void)getDataMp3NameArray:(NSArray*)nameArr Mp3UrlArray:(NSArray*)mp3Arr LyricArray:(NSArray*)lyricArr AutorNameArray:(NSArray*)autoNameArr Mp3IDArray:(NSArray*)IDArr;

//第2种数据传输方式
// 小节数据Json
- (void)getJson:(NSDictionary*)json;
// 点击的那个小节
@property(nonatomic,assign) int touchNum;

@end
