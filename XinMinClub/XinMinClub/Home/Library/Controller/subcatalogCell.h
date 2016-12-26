//
//  subcatalogCell.h
//  XinMinClub
//
//  Created by 贺军 on 16/5/11.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SectionData.h"

@interface subcatalogCell : UITableViewCell

@property (nonatomic, strong) NSArray *titleArray; // 标题
@property (nonatomic, strong) NSDictionary *jsonData;  // 数据内容

@property (nonatomic, strong) NSArray<SectionData*> *kj_sectionDataArray;
@property (nonatomic, strong) NSString *imageUlr_kk;

@end
