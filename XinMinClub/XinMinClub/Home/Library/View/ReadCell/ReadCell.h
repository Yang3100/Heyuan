//
//  ReadCell.h
//  XinMinClub
//
//  Created by yangkejun on 16/3/30.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ReadCell : UITableViewCell

@property(nonatomic, copy) NSString *readTitle;
@property(nonatomic, copy) NSString *readText;
@property (nonatomic, strong) NSString *readMp3;
@property(nonatomic, assign) NSInteger readNum;
@property(nonatomic,assign)BOOL state;
@property(nonatomic, copy) NSDictionary *infoDic;

@end
