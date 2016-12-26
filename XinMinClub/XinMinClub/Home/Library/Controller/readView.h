//
//  readView.h
//  XinMinClub
//
//  Created by 杨科军 on 2016/12/21.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface readView : UIView

@property(nonatomic,strong) NSArray *type;
@property(nonatomic,assign) BOOL isTopView; // 是不是显示在最上面

@property(nonatomic,strong) NSString *bookID; // 书集ID
@property(nonatomic,strong) NSArray *typeArray; // 章节数组

@end
