//
//  RegisterViewController.m
//  XinMinClub
//
//  Created by yangkejun on 16/3/18.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "RegisterViewController.h"
#import "LoginViewController.h"
#import "SubmitViewController.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface RegisterViewController ()<UITextFieldDelegate,UIAlertViewDelegate> {
    UITextField *country_, *iPhone_;
    UITextField *curTextField_;
    UILabel *countryLabel_ , *iPhoneLabel_;
    UIButton *registerButton_;
    UIImageView *backImage_;
    UILabel *titleLabel_;
    UIButton *registerBtn_;
    UIButton *loadButton_;
    LoginViewController *loginViewController;
}

@property(nonatomic, copy) UILabel *agreementLabel; // 用户协议Label

@end

@implementation RegisterViewController

- (void)loadView{
    //自己创建UIControl添加事件
    UIControl *view = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [view addTarget:self action:@selector(resignResponder:) forControlEvents:UIControlEventTouchDown];
    view.backgroundColor = [UIColor clearColor];
    self.view = view;
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    loginViewController = [[LoginViewController alloc] init];
    
    [self.view addSubview:self.backImage];
    [self.view addSubview:self.registerButton];
    [self.view addSubview:self.countryLabel];
    [self.view addSubview:self.iPhoneLabel];
    [self.view addSubview:self.iPhone];
    [self.view addSubview:self.country];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.loadButton];
    [self.view addSubview:self.agreementLabel];
    
    //添加观察者,监听键盘弹出，隐藏事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    
}

#pragma mark Views
- (UILabel *)titleLabel {
    if (!titleLabel_) {
        titleLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 50)];
        titleLabel_.textColor = [UIColor whiteColor];
        titleLabel_.text = @"注册";
        titleLabel_.textAlignment = NSTextAlignmentCenter;
        [titleLabel_ setFont:[UIFont systemFontOfSize:32]];
    }
    return titleLabel_;
}

- (UIImageView *)backImage{
    if (!backImage_) {
        backImage_ = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height + 3)];
        backImage_.image = [UIImage imageNamed:@"login.jpg"];
    }
    return backImage_;
}

//用户名输入提示
- (UILabel *)countryLabel{
    
    if (!countryLabel_) {
        countryLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(50, SCREEN_HEIGHT/2-110, 90, 30)];
        countryLabel_.text = @"国家和地区";
        countryLabel_.textAlignment = NSTextAlignmentCenter;
        countryLabel_.textColor = [UIColor whiteColor];
    }
    return countryLabel_;
}

//密码输入提示
- (UILabel *)iPhoneLabel{
    if (!iPhoneLabel_) {
        iPhoneLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(50, SCREEN_HEIGHT/2-50, 90, 30)];
        iPhoneLabel_.text = @"+86";
        iPhoneLabel_.layer.masksToBounds = YES;
        iPhoneLabel_.layer.borderWidth = 0.5;
        iPhoneLabel_.layer.borderColor = [[UIColor grayColor] CGColor];
        iPhoneLabel_.textAlignment = NSTextAlignmentCenter;
        iPhoneLabel_.textColor = [UIColor whiteColor];
    }
    return iPhoneLabel_;
}

//用户名输入框
- (UITextField *)country{
    if (!country_) {
        country_ = [[UITextField alloc] initWithFrame:CGRectMake(countryLabel_.center.x + 50, SCREEN_HEIGHT/2-110, SCREEN_WIDTH/2, 30)];
        country_.placeholder = @"请选择国家";
        country_.text = @"中国";
        country_.clearButtonMode = UITextFieldViewModeWhileEditing;
        country_.returnKeyType = UIReturnKeyNext;//改变键盘，右下角位NEXT键
        country_.delegate = self;//遵循协议,响应键盘弹出,隐藏事件,NEXT键功能
        country_ .textColor = [UIColor whiteColor];
        country_.enabled=NO;
    }
    return country_;
}

//密码输入框
- (UITextField *)iPhone{
    if (!iPhone_) {
        iPhone_ = [[UITextField alloc] initWithFrame:CGRectMake(countryLabel_.center.x + 50, SCREEN_HEIGHT/2-50, SCREEN_WIDTH/2, 30)];
        iPhone_.placeholder = @"请输入手机号码";
        iPhone_.clearButtonMode = UITextFieldViewModeWhileEditing;
        iPhone_.returnKeyType = UIReturnKeyDone;//改变键盘为DONE键
        iPhone_.delegate = self; //遵循协议,响应键盘弹出,隐藏事件,DONE键功能
        iPhone_.textColor = [UIColor whiteColor];
        iPhone_.keyboardType = UIKeyboardTypeNumberPad;
    }
    return iPhone_;
}

// 注册按钮
- (UIButton *)registerButton{
    if (!registerButton_) {
        registerButton_ = [UIButton buttonWithType:UIButtonTypeSystem];
        registerButton_.frame = CGRectMake(50, SCREEN_HEIGHT/2, SCREEN_WIDTH-100, 50);
        [registerButton_ setTitle:@"注册" forState:UIControlStateNormal];
        registerButton_.backgroundColor = [UIColor colorWithWhite:0.065 alpha:0.800];
        [registerButton_ addTarget:self action:@selector(registerAction:) forControlEvents:UIControlEventTouchUpInside];
        registerButton_.tintColor = [UIColor whiteColor];
    }
    return registerButton_;
}

- (UILabel *)agreementLabel{
    if (!_agreementLabel) {
        _agreementLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, SCREEN_HEIGHT/2+60, SCREEN_WIDTH - 120, 30)];
        _agreementLabel.tintColor = [UIColor whiteColor];
        _agreementLabel.text = @"注册即表示同意<XXXX用户协议>";
        _agreementLabel.font = [UIFont systemFontOfSize:13];
        _agreementLabel.textColor = [UIColor grayColor];
    }
    return _agreementLabel;
}

- (UIButton *)loadButton{
    if (!loadButton_) {
        loadButton_ = [UIButton buttonWithType:UIButtonTypeSystem];
        loadButton_.frame = CGRectMake(SCREEN_WIDTH-130, SCREEN_HEIGHT/2+100, 80, 30);
        loadButton_.tintColor = [UIColor whiteColor];
        [loadButton_ setTitle:@"登陆" forState:UIControlStateNormal];
        [loadButton_.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [loadButton_ addTarget:self action:@selector(loadAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return loadButton_;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark Actions
// 移除响应者
- (IBAction)resignResponder:(id)sender{
    [country_ resignFirstResponder];
    [iPhone_ resignFirstResponder];
}

// 键盘弹出时不产生遮挡关系的设置
- (void)keyboardShow:(NSNotification *)notify{
    NSValue *value = [notify.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGFloat keyboardHeight = value.CGRectValue.size.height;
    
    //获取当前输入框的y值，高度值及屏幕高度
    CGFloat y = curTextField_.frame.origin.y;
    CGFloat h = curTextField_.frame.size.height;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    //获取屏幕与控件高度差
    CGFloat deltaH = screenHeight - (y + h + keyboardHeight + self.view.frame.origin.y) - 80;
    
    //如果屏幕不够高
    if (deltaH < 0) {
        CGRect frame = self.view.frame;
        frame = CGRectMake(frame.origin.x, frame.origin.y + deltaH , frame.size.width, frame.size.height);
        self.view.frame = frame;
    }
}
// 键盘隐藏
- (void)keyboardHide:(NSNotification *)notify{
    CGRect frame = self.view.frame;
    frame = CGRectMake(frame.origin.x, 0, frame.size.width, frame.size.height);
    self.view.frame = frame;
}

//点击键盘下一项
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [iPhone_ becomeFirstResponder];
    return YES;
}

//textField开始编辑
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    curTextField_ = textField;
}

#pragma mark ButtonActions
// 登陆小按钮
- (IBAction)loadAction:(id)sender{
//    // 设置切换动画
    CATransition *animation = [CATransition animation];
    animation.duration = 0.6;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = kCATransitionMoveIn;
//    animation.subtype = kCATransitionFromTop;
    [self.view.window.layer addAnimation:animation forKey:nil];
    [self dismissViewControllerAnimated:NO completion:^{
        [_delegate registerLogin];
    }];
}

#pragma mark  手机号码规范
/**
 * 功能：校验手机号码
 */
- (BOOL)validateMobile:(NSString *)mobileNum{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188,183,184,178
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189,181,177
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|70|8[0-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188,183,184,178
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|78|8[2-478])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186,176
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|76|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,181,189,177
     22         */
    NSString * CT = @"^1((33|53|77|8[019])[0-9]|349)\\d{7}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES)) {
        return YES;
    }
    else {
        return NO;
    }
}
// 注册功能
- (IBAction)registerAction:(id)sender{
    // 判断手机号码是否大于等于11位
    if (![self validateMobile:iPhone_.text]){
        iPhone_.layer.borderColor = [[UIColor redColor] CGColor];
        [iPhone_ becomeFirstResponder];
        return;
    }
    [self addAlertView];
}
// 点击 < 按钮
- (void)gobackAction:(UIButton *)button {
    // 返回
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)addAlertView{
    NSString *s = @"我们将发送验证都手机号码：+86\n";
    NSString *ss = [NSString stringWithFormat:@"%@",iPhone_.text];
    NSString *sss = [s stringByAppendingString:ss];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确认手机号" message:sss preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self requestMessage];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消");
    }];
    [alertController addAction:action1];
    [alertController addAction:action2];
    [self presentViewController:alertController animated:YES completion:NULL];
}

- (void)requestMessage{
    // 创建会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    // 设置请求路径
    NSURL *URL=[NSURL URLWithString:IPUrl];//不需要传递参数
    
    // 创建请求对象
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];//默认为get请求
    request.timeoutInterval=20.0;//设置请求超时为5秒
    request.HTTPMethod=@"POST";//设置请求方法
    // 参数
    NSString *param = [NSString stringWithFormat:@"{\"FunName\":\"Set_Right_Code\",\"Params\":{\"DATA\":\"%@\"}}",iPhone_.text];
    NSLog(@"%@",param);    // 把拼接后的字符串转换为data，设置请求体
    
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // 解析数据
        if (data != nil) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            if (dict!=nil) {
                NSLog(@"登录返回的json%@",dict);
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    SubmitViewController *svc = [[SubmitViewController alloc] init];
                    svc.iphoneNum = iPhone_.text;
                    svc.country = country_.text;
                    [self presentViewController:svc animated:NO completion:nil];
                });
            }
            else
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    // 服务器无反应
                    [self addAlertView3];
                });
        }
        else
            dispatch_async(dispatch_get_main_queue(), ^(void){
                // 无网络
                [self addAlertView4];
            });
    }];
    // 执行任务
    [dataTask resume];
}

-(void)addAlertView3{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"网络连接失败😔😔" message:@"😥😥请稍后再试!!!" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"网络连接失败!!");
    }];
    [alertController addAction:action1];
    [self presentViewController:alertController animated:YES completion:NULL];
}

-(void)addAlertView4{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"网络连接失败😱😱" message:@"😀😀请检查你的网络!!!" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"网络连接失败!!");
    }];
    [alertController addAction:action1];
    [self presentViewController:alertController animated:YES completion:NULL];
}

@end

