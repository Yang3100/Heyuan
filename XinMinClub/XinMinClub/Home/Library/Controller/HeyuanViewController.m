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
    NSArray *dataArray;
}

@end

@implementation HeyuanViewController

- (instancetype)init{
    if (self==[super init]) {
        //获取数据
        [self getData];
    }
    return self;
}

- (void)getData{
    // 后台执行
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 后台对数据类型的需要
        NSDictionary *dict = @{@"Page_Index":@"1",@"Page_Count":@"15"};
        NSString *paramString = [networkSection getParamStringWithParam:@{@"FunName":@"Get_ADVERTISEMENT_DataList",@"Params":dict}];
        // 网络请求
        [networkSection getJsonDataWithUrlString:IPZUrl param:paramString];
        
        //回调函数获取数据
        [networkSection setGetRequestDataClosuresCallBack:^(NSDictionary *json) {
//            NSLog(@"ADJson:%@",json);
            dataArray = [[json valueForKey:@"RET"] valueForKey:@"SYS_ADVERTISEMENT"];
            NSMutableArray *imageUrlArray = [NSMutableArray array];
            for (NSDictionary *dicc in dataArray) {
                NSString *app = IPZ;
                NSString *urlString = [app stringByAppendingString:[dicc valueForKey:@"ADV_IMAGE"]];
                [imageUrlArray addObject:urlString];
            }
            // 主线程执行
            dispatch_async(dispatch_get_main_queue(), ^{
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
    // 九宫格
    NineNine *nine = [[NineNine alloc] initWithSize:frame Interior:nil];
    [self.view addSubview:nine];
    
    // 八卦
    gossipView *gv = [[gossipView alloc] initWithFrame:frame];
    [self.view addSubview:gv];
}

#pragma mark WMLoopViewDelegate
- (void)loopViewDidSelectedImage:(WMLoopView *)loopView index:(int)index{
    NSDictionary *dii = dataArray[index];
    ADViewController *advc = [[ADViewController alloc] init];
    advc.ADTitle = [dii valueForKey:@"ADV_TITLE"];
    advc.ADID = [dii valueForKey:@"ADV_ID"];
    advc.ADImageUrl = [NSString stringWithFormat:@"%@%@",IP,[dii valueForKey:@"ADV_IMAGE"]];
    advc.shopName = [dii valueForKey:@"ADV_MERCHANT_NAME"];
    advc.shopID = [dii valueForKey:@"ADV_MERCHANT_ID"];
    advc.shopUrlString = [dii valueForKey:@"ADV_URL"];
    [self.navigationController pushViewController:advc animated:YES];
}

@end
