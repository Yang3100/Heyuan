//
//  DistrictModel.h
//  picker
//
//  Created by 王帅 on 14/11/22.
//  Copyright (c) 2014年 Sylar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DistrictModel : NSObject

@property (nonatomic,assign)NSInteger ID;      //id
@property (nonatomic,strong)NSString *name;    //名称
@property (nonatomic,assign)NSInteger postcode;//邮政编码
@property (nonatomic,assign)NSInteger city_id;//省ID

@end
