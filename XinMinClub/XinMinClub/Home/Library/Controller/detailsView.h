//
//  detailsView.h
//  XinMinClub
//
//  Created by 杨科军 on 2016/12/21.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface detailsView : UIView

@property(nonatomic,assign) CGFloat detailsScroll;
@property(nonatomic,assign) BOOL isTopView; // 是不是显示在最上面

// 需求的数据
- (void)giveMeJson:(NSDictionary*)json;
@property(nonatomic,copy) NSString *bookID; // 书集ID

@end
