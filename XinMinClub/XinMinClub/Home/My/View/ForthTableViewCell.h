//
//  ForthTableViewCell.h
//  XinMinClub
//
//  Created by 赵劲松 on 16/4/25.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RecommendDelegate <NSObject>

@optional
- (void)recommendTable:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface ForthTableViewCell : UITableViewCell

@property (nonatomic, assign) id <RecommendDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITableView *recommendTable;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (nonatomic, strong) NSArray *recommencArray;

@end
