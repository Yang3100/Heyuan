//
//  KJ_BookCell2.h
//  XinMinClub
//
//  Created by 杨科军 on 16/5/23.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KJ_BookCell2 : UITableViewCell

@property(nonatomic)BOOL kj_toTop;//到了顶部
@property(nonatomic)BOOL kj_selfToTop;//自己时候到了顶部

@property (nonatomic, strong) NSArray *kj_typeArray;
@property (nonatomic, strong) NSDictionary *kj_dataDict;

@end
