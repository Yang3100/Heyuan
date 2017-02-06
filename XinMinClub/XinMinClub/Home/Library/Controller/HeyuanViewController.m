//
//  LibraryViewController.m
//  XinMinClub
//
//  Created by yangkejun on 16/3/19.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "HeyuanViewController.h"
#import "ADViewController.h"
#import "NineNine.h"
#import "WMLoopView.h"

@interface HeyuanViewController ()<WMLoopViewDelegate>{
    NSMutableArray *dataArray;
    UIImageView *image11111; // 占位视图
}

@end

@implementation HeyuanViewController

- (instancetype)init{
    if (self==[super init]) {
        //获取数据
        [self getData];
        dataArray = [NSMutableArray array];
    }
    return self;
}

- (void)getData{
    [[LoadAnimation defaultDataModel] startLoadAnimation];
    // 后台执行
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 后台对数据类型的需要
        NSDictionary *dict = @{@"Page_Index":@"1",@"Page_Count":@"15"};
        NSString *paramString = [networkSection getParamStringWithParam:@{@"FunName":@"Get_ADVERTISEMENT_DataList",@"Params":dict}];
        // 网络请求
        [networkSection getJsonDataWithUrlString:IPUrl param:paramString];
        
        //回调函数获取数据
        [networkSection setGetRequestDataClosuresCallBack:^(NSDictionary *json) {
//            NSLog(@"ADJson:%@",json);
            [dataArray removeAllObjects];
            NSArray *arr = [[json valueForKey:@"RET"] valueForKey:@"SYS_ADVERTISEMENT"];
            NSMutableArray *imageUrlArray = [NSMutableArray array];
            NSMutableArray *findUrlArray = [NSMutableArray array];
            NSMutableArray *findImageUrlArray = [NSMutableArray array];
            for (NSDictionary *dicc in arr) {
                NSString *url = [dicc valueForKey:@"ADV_URL"];
                if (![url isEqualToString:@""]&&url!=nil) {
                    NSString *str1 = [url substringWithRange:NSMakeRange(0, 3)];
                    if ([str1 isEqualToString:@"KC:"]){
                        [findUrlArray addObject:dicc];
                        NSString *urlString = [IP stringByAppendingString:[dicc valueForKey:@"ADV_IMAGE"]];
                        [findImageUrlArray addObject:urlString];
                    }else{
                        NSString *urlString = [IP stringByAppendingString:[dicc valueForKey:@"ADV_IMAGE"]];
                        [imageUrlArray addObject:urlString];
                        [dataArray addObject:dicc];
                        [DATA_MODEL getRecommand:dicc];
                    }
                }
            }
            [DataModel defaultDataModel].findAD = findUrlArray;
            [DataModel defaultDataModel].findADImage = findImageUrlArray;
            // 主线程执行
            dispatch_async(dispatch_get_main_queue(), ^{
                [[LoadAnimation defaultDataModel] endLoadAnimation];
                if (imageUrlArray.count==0) {
                    return ;
                }
                [image11111 removeFromSuperview];
                WMLoopView *wlv = [[WMLoopView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT/4) images:imageUrlArray autoPlay:YES delay:2 isLoopNetwork:YES];
                wlv.delegate = self;
                [self.view addSubview:wlv];
            });
        }];
        
    });
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView]; // 加载视图
}

- (void)initView{
    CGRect frame = CGRectMake(0, SCREEN_HEIGHT/4, SCREEN_WIDTH, SCREEN_HEIGHT-SCREEN_HEIGHT/4-108);
    
    // 占位视图
    image11111 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT/4)];
    image11111.image = cachePicture_375x222;
    [self.view addSubview:image11111];
    
    // 九宫格
    NineNine *nine = [[NineNine alloc] initWithSize:frame Interior:nil];
    [self.view addSubview:nine];
    
//    // 第一次进入
//    if (!DATA_MODEL.rushidaoTeach) {
//        FristLoadView *flv = [[FristLoadView alloc] init];
//        [flv useToWhere:@"rushidao"];
//        [self.view addSubview:flv];
//    }
    
    // 八卦
    gossipView *gv = [[gossipView alloc] initWithFrame:frame];
    [self.view addSubview:gv];

    // 主线程执行：
    dispatch_async(dispatch_get_main_queue(), ^{
        // 第一次进入
        if (!DATA_MODEL.baguaTeach) {
            FristLoadView *flv = [[FristLoadView alloc] init];
            [flv useToWhere:@"bagua"];
            [self.view addSubview:flv];
        }
    }); 

}

#pragma mark WMLoopViewDelegate
- (void)loopViewDidSelectedImage:(WMLoopView *)loopView index:(int)index{
    NSDictionary *dii = dataArray[index];
    
    NSString *url = [dii valueForKey:@"ADV_URL"];
    if (![url isEqualToString:@""]&&url!=nil) {
        NSString *str1 = [url substringWithRange:NSMakeRange(0, 3)];
        if ([str1 isEqualToString:@"KC:"]){
            
        }
        else if ([str1 isEqualToString:@"WJ:"]){
            NSString *wjID = [url substringFromIndex:3];
            // 获取章节列表
            NSDictionary *dict = @{@"ID":wjID};
            NSString *paramString = [networkSection getParamStringWithParam:@{@"FunName":@"Get_WeiJi_FromID", @"Params":dict}];
            [networkSection getRequestDataBlock:IPUrl :paramString block:^(NSDictionary *jsonDict) {
//                NSLog(@"Get_WJ_ZJ_TYPE:%@",jsonDict);
                // 主线程执行
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSDictionary *dica = [[jsonDict valueForKey:@"RET"] valueForKey:@"Sys_GX_WenJI"][0];
//                    NSLog(@"%@",dica);
                    SectionViewController *svc = [[SectionViewController alloc] init];
                    [svc getJsonData:dica];
                    
                    [[DataModel defaultDataModel] addAllLibrary:dica];
                    
                    [self.navigationController pushViewController:svc animated:YES];
                });
            }];

        }
        else{
            ADViewController *advc = [[ADViewController alloc] init];
            advc.ADTitle = [dii valueForKey:@"ADV_TITLE"];
            advc.ADID = [dii valueForKey:@"ADV_ID"];
            advc.ADImageUrl = [NSString stringWithFormat:@"%@%@",IP,[dii valueForKey:@"ADV_IMAGE"]];
            advc.shopName = [dii valueForKey:@"ADV_MERCHANT_NAME"];
            advc.shopID = [dii valueForKey:@"ADV_MERCHANT_ID"];
            advc.shopUrlString = [dii valueForKey:@"ADV_URL"];
            [self.navigationController pushViewController:advc animated:YES];
        }
        
    }
    
    
}

@end
