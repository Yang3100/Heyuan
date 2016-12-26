//
//  BookView.h
//  XinMinClub
//
//  Created by 杨科军 on 16/6/26.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookViewController : UIViewController

@property(nonatomic,copy) NSString *rushidaoName; // 儒释道当中的那个
@property(nonatomic,copy) NSString *typeName; // 类名九宫格具体某个
@property(nonatomic,copy) NSArray *typeArray; // 九宫格类名

@property(nonatomic,assign) BOOL isRemoveArray;  // 控制是否清空数组元素

// 单例
+ (instancetype)shareObject;

// 请求数据
- (void)startGetDataWithType:(NSString*)type touchNum:(int)touchNum;

@end
