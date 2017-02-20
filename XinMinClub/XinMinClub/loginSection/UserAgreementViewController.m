//
//  UserAgreementViewController.m
//  XinMinClub
//
//  Created by 杨科军 on 2017/2/3.
//  Copyright © 2017年 yangkejun. All rights reserved.
//

#import "UserAgreementViewController.h"

@interface UserAgreementViewController ()

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation UserAgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"和源用户协议";
    
    // 右侧消息按钮
    UIImage *rightImage = [[UIImage imageNamed:@"goback"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithImage:rightImage style:UIBarButtonItemStylePlain target:self action:@selector(rightAction)];
    self.navigationItem.leftBarButtonItem = rightButtonItem;
    
    [self.view addSubview:self.webView];
}

- (void)rightAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
        _webView.backgroundColor = [UIColor whiteColor];
        NSURL *url = [NSURL URLWithString:@"http://www.kingwant.com/BizFunction/app_protocol.html"];
        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
        [_webView loadRequest:request];
    }
    return _webView;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
