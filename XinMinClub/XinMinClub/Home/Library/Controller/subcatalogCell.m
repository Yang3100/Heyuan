//
//  subcatalogCell.m
//  XinMinClub
//
//  Created by 贺军 on 16/5/11.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "subcatalogCell.h"
#import "playerViewController.h"
//#import "TransferStationObject.h"
//#import "KJ_BackTableViewController.h"

@interface subcatalogCell()<UITableViewDelegate,UITableViewDataSource>{
    __weak IBOutlet UITableView *subcatalog;
    NSArray<NSDictionary*> *myData;   // 获取到的数据数组
}

@end

@implementation subcatalogCell

//  获取当前view所处的viewController重写读方法
- (UIViewController *)viewController{
    for (UIView *next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            // 上面if判断是否为UIViewController的子类
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    subcatalog.scrollEnabled = NO;
    subcatalog.dataSource=self;
    subcatalog.delegate=self;
}

- (void)setTitleArray:(NSArray *)titleArray{
    myData = titleArray;
    [subcatalog reloadData]; // 刷新table
}

- (void)setJsonData:(NSDictionary *)jsonData{
    _jsonData = jsonData;
    myData = [[jsonData valueForKey:@"RET"] valueForKey:@"Sys_GX_ZJ"];
    [subcatalog reloadData]; // 刷新table
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return myData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.text= [NSString stringWithFormat:@"     %@",[myData[indexPath.row] valueForKey:@"GJ_NAME" ]];
    cell.textLabel.textColor=[UIColor grayColor];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [self abcccc:indexPath.row];
    NSLog(@"touch小节%ld------%@",(long)indexPath.row,self.jsonData);
    [playerViewController defaultDataModel].touchNum = indexPath.row;
    [[playerViewController defaultDataModel] getJson:self.jsonData];
    [playerViewController defaultDataModel].title = [DataModel defaultDataModel].bookName;
    [[self viewController].navigationController pushViewController:[playerViewController defaultDataModel] animated:YES];

}


@end
