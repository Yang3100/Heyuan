//
//  ADViewController.m
//  XinMinClub
//
//  Created by yangkejun on 16/3/22.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "ADViewController.h"

@interface ADViewController ()

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation ADViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=_ADTitle;
    
    // 右侧消息按钮
    UIImage *rightImage = [[UIImage imageNamed:@"Join_the_corpus"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithImage:rightImage style:UIBarButtonItemStylePlain target:self action:@selector(rightAction)];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    [self.view addSubview:self.webView];
}

- (void)rightAction{
    NSLog(@"gotoShop!!!");
}

- (UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
        _webView.backgroundColor = [UIColor whiteColor];
        NSURL *url = [NSURL URLWithString:_shopUrlString];
        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
        [_webView loadRequest:request];
    }
    return _webView;
}

@end



