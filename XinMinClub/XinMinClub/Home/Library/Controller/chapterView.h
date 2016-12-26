//
//  chapterView.h
//  XinMinClub
//
//  Created by 杨科军 on 2016/12/21.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface chapterView : UIView

@property(nonatomic,assign) CGFloat chapterScroll;
@property(nonatomic,copy) NSString *bookID; // 书集ID
- (void)gettype:(NSArray*)type;

@end
