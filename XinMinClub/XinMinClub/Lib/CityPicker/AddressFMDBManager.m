//
//  AddressFMDBManager.m
//  picker
//
//  Created by 王帅 on 14/11/21.
//  Copyright (c) 2014年 Sylar. All rights reserved.
//

#import "AddressFMDBManager.h"
#import "ProvinceAddressModel.h"
#import "CityAddressModel.h"
#import "DistrictModel.h"
#define kdocumentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
//获得存放数据库文件的沙盒地址
#define kDbFilePath [kdocumentPath stringByAppendingPathComponent:@"/cityData.sqlite"]
@implementation AddressFMDBManager

+ (AddressFMDBManager *)sharedAddressFMDBManager
{
    static AddressFMDBManager *afManager=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        afManager=[[AddressFMDBManager alloc] init];
        afManager.provinceArray=[[NSMutableArray alloc] initWithCapacity:1];
        afManager.cityArray=[[NSMutableArray alloc] initWithCapacity:1];
        afManager.districtArray=[[NSMutableArray alloc] initWithCapacity:1];
        [afManager creatDatabase];
    });
    return afManager;
}
//创建数据库
- (void)creatDatabase
{
    //根据地址创建数据库
    NSString *path = [[NSBundle mainBundle]pathForResource:@"cityData" ofType:@"sqlite"];
//    _cityData=[FMDatabase databaseWithPath:kDbFilePath];
    _cityData=[FMDatabase databaseWithPath:path];
    if (![_cityData open]) {
        NSLog(@"无法打开数据库");
//       [_cityData executeUpdate:@"/Users/yikang/Library/Developer/CoreSimulator/Devices/DBE84367-E595-412B-ADD0-F6888A8A5190/data/Containers/Data/Application/8CF7F97F-D53D-42E4-9ECA-6BD1AFA82CEB/Documents/cityData.sqlite"];
        
//       return _cityData;
    }
    NSLog(@"aaa＝%@",kDbFilePath);
 
}

//查询表数据:省的数组
- (NSArray *)selectAllProvince
{
    //定义一个结果集,存放查询的数据
    FMResultSet *rs=[_cityData executeQuery:@"select * from province"];
    //先清空数组
    [self.provinceArray removeAllObjects];
    //判断结果集中是否有数据,如果有则取出数据
    while ([rs next]) {
        ProvinceAddressModel *am=[[ProvinceAddressModel alloc] init];
        am.ID=[rs intForColumn:@"id"];
        am.name=[rs stringForColumn:@"name"];
        am.postcode=[rs intForColumn:@"postcode"];

        //将查询到的数据放入数组中
        [_provinceArray addObject:am];
    }
    
    return self.provinceArray;
}

//查询表数据:市的数组
- (NSArray *)selectAllCityFrom:(NSInteger)provinceId
{

//    NSLog(@"-=-=-=%ld",(long)provinceId);
    //定义一个结果集,存放查询的数据
    FMResultSet *rs=[_cityData executeQuery:@"select * from city where province_id=?",[NSNumber numberWithLong:provinceId]];
    //先清空数组
    [self.cityArray removeAllObjects];
    //判断结果集中是否有数据,如果有则取出数据
    while ([rs next]) {
        CityAddressModel *am=[[CityAddressModel alloc] init];
        am.ID=[rs intForColumn:@"id"];
        am.name=[rs stringForColumn:@"name"];
        am.postcode=[rs intForColumn:@"postcode"];
        am.province_id=[rs intForColumn:@"province_id"];
        //将查询到的数据放入数组中
        [_cityArray addObject:am];
    }

    return self.cityArray;
}

//根据市名查找市对应的id
- (NSInteger)selectIdFromCityWith:(NSString *)name
{
    
//    NSLog(@"-=-=-=%@",name);
    //定义一个结果集,存放查询的数据
    FMResultSet *rs=[_cityData executeQuery:@"select id from city where name=?",name];
    
    CityAddressModel *am=[[CityAddressModel alloc] init];
    //判断结果集中是否有数据,如果有则取出数据
    while ([rs next]) {
        am.ID=[rs intForColumn:@"id"];
        am.name=[rs stringForColumn:@"name"];
        am.postcode=[rs intForColumn:@"postcode"];
        am.province_id=[rs intForColumn:@"province_id"];

    }
    self.cityId=am.ID;
    return _cityId;
}




//查询表数据:区的数组
- (NSArray *)selectAllDistrictFrom:(NSInteger)cityId
{

    //为数据库设置缓存,提高查询效率
    [_cityData setShouldCacheStatements:YES];
    //定义一个结果集,存放查询的数据
    FMResultSet *rs=[_cityData executeQuery:@"select * from district where city_id=?",[NSNumber numberWithInteger:cityId]];
    //先清空数组
    [self.districtArray removeAllObjects];
    //判断结果集中是否有数据,如果有则取出数据
    while ([rs next]) {
        DistrictModel *am=[[DistrictModel alloc] init];
        am.ID=[rs intForColumn:@"id"];
        am.name=[rs stringForColumn:@"name"];
        am.postcode=[rs intForColumn:@"postcode"];
        am.city_id=[rs intForColumn:@"city_id"];
        //将查询到的数据放入数组中
        [_districtArray addObject:am];
    }
    
    return self.districtArray;
}





@end
