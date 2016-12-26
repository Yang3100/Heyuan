//
//  ProcessSelect.h
//  XinMinClub
//
//  Created by 赵劲松 on 16/4/27.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ProcessSelect : NSObject

// 处理播放事件
- (void)processTableSelect:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath forData:(id)data inViewController:(UIViewController *)viewController;
// 处理播放全部
- (void)processPlayAllButtonSelect:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath forData:(id)data inViewController:(UIViewController *)viewController;

@end
