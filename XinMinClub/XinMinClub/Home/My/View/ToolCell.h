//
//  ToolCell.h
//  XinMinClub
//
//  Created by 赵劲松 on 16/4/13.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ToolCellDelegate <NSObject>

@optional
- (void)manageSection: (NSInteger)tag;

@end

@interface ToolCell : UICollectionViewCell

@property (nonatomic, assign) id <ToolCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *toolCellButton;
@property (weak, nonatomic) IBOutlet UILabel *toolCellLabel;

@end
