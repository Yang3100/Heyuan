//
//  RegisterViewController.m
//  XinMinClub
//
//  Created by yangkejun on 16/3/18.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "RegisterViewController.h"
#import "SubmitViewController.h"
#import "loginViewController.h"
#import "UserAgreementViewController.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define chushizuobiao ([UIScreen mainScreen].bounds.size.height/2)

@interface RegisterViewController ()<UITextFieldDelegate,UIAlertViewDelegate> {
    UITextField *country_, *iPhone_;
    UITextField *curTextField_;
    UILabel *countryLabel_ , *iPhoneLabel_;
    UIButton *registerButton_;
    UIImageView *backImage_;
    UILabel *titleLabel_;
    UIButton *registerBtn_;
    UIButton *loadButton_;
}

@property(nonatomic, copy) UIButton *agreementLabel; // 用户协议Label

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
    
    [self.view addSubview:self.backImage];
    [self.view addSubview:self.registerButton];
    [self.view addSubview:self.agreementLabel];
    [self.view addSubview:self.countryLabel];
    [self.view addSubview:self.iPhoneLabel];
    [self.view addSubview:self.iPhone];
    [self.view addSubview:self.country];
//    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.loadButton];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(10, 20, 40, 40);
    if (SCREEN_WIDTH > 320) {
        button.frame = CGRectMake(10, 20, 40, 40);
    }
    [button setImage:[UIImage imageNamed:@"goback"] forState:UIControlStateNormal];
    [button setTintColor:[UIColor whiteColor]];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    //添加观察者,监听键盘弹出，隐藏事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Views
- (UILabel *)titleLabel {
    if (!titleLabel_) {
        titleLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 50, 30)];
        titleLabel_.textColor = RGB255_COLOR(68, 68, 68, 1);
        titleLabel_.text = @"注册";
        titleLabel_.textAlignment = NSTextAlignmentCenter;
        [titleLabel_ setFont:[UIFont systemFontOfSize:16]];
    }
    return titleLabel_;
}

- (UIImageView *)backImage{
    if (!backImage_) {
        backImage_ = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height + 3)];
        backImage_.image = loginCachePicture;
    }
    return backImage_;
}

//用户名输入提示
- (UILabel *)countryLabel{
    
    if (!countryLabel_) {
        countryLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(50, chushizuobiao-60, 90, 30)];
        countryLabel_.text = @"国家和地区";
        countryLabel_.textAlignment = NSTextAlignmentCenter;
        countryLabel_.textColor = RGB255_COLOR(68, 68, 68, 1);
    }
    return countryLabel_;
}

//密码输入提示
- (UILabel *)iPhoneLabel{
    if (!iPhoneLabel_) {
        iPhoneLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(50, chushizuobiao, 90, 30)];
        iPhoneLabel_.text = @"+86";
        iPhoneLabel_.layer.masksToBounds = YES;
        iPhoneLabel_.layer.borderWidth = 0.5;
        iPhoneLabel_.layer.cornerRadius = 2.0;
        iPhoneLabel_.layer.borderColor = [[UIColor grayColor] CGColor];
        iPhoneLabel_.textAlignment = NSTextAlignmentCenter;
        iPhoneLabel_.textColor = RGB255_COLOR(68, 68, 68, 1);
    }
    return iPhoneLabel_;
}

//用户名输入框
- (UITextField *)country{
    if (!country_) {
        country_ = [[UITextField alloc] initWithFrame:CGRectMake(countryLabel_.center.x + 50, chushizuobiao-60, SCREEN_WIDTH/2, 30)];
        country_.placeholder = @"请选择国家";
        country_.text = @"中国";
        country_.clearButtonMode = UITextFieldViewModeWhileEditing;
        country_.returnKeyType = UIReturnKeyNext;//改变键盘，右下角位NEXT键
        country_.delegate = self;//遵循协议,响应键盘弹出,隐藏事件,NEXT键功能
        country_ .textColor = RGB255_COLOR(68, 68, 68, 1);
        country_.enabled=NO;
    }
    return country_;
}

//密码输入框
- (UITextField *)iPhone{
    if (!iPhone_) {
        iPhone_ = [[UITextField alloc] initWithFrame:CGRectMake(countryLabel_.center.x + 50, chushizuobiao, SCREEN_WIDTH/2, 30)];
        iPhone_.placeholder = @"请输入手机号码";
        iPhone_.clearButtonMode = UITextFieldViewModeWhileEditing;
        iPhone_.returnKeyType = UIReturnKeyDone;//改变键盘为DONE键
        iPhone_.delegate = self; //遵循协议,响应键盘弹出,隐藏事件,DONE键功能
        iPhone_.textColor = RGB255_COLOR(68, 68, 68, 1);
        iPhone_.keyboardType = UIKeyboardTypeNumberPad;
    }
    return iPhone_;
}

// 注册按钮
- (UIButton *)registerButton{
    if (!registerButton_) {
        registerButton_ = [UIButton buttonWithType:UIButtonTypeSystem];
        registerButton_.frame = CGRectMake(50, chushizuobiao+50, SCREEN_WIDTH-100, 50);
        [registerButton_ setTitle:@"注册" forState:UIControlStateNormal];
        registerButton_.backgroundColor = RGB255_COLOR(0.0, 0.0, 0.0, 0.35);
        [registerButton_ addTarget:self action:@selector(registerAction:) forControlEvents:UIControlEventTouchUpInside];
        registerButton_.tintColor = [UIColor whiteColor];
    }
    return registerButton_;
}

- (UIButton *)agreementLabel{
    if (!_agreementLabel) {
        _agreementLabel = [UIButton buttonWithType:UIButtonTypeCustom];
        _agreementLabel.frame = CGRectMake(40, chushizuobiao+110, SCREEN_WIDTH - 120, 30);
        _agreementLabel.tintColor = [UIColor grayColor];
        [_agreementLabel setTitle:@"注册即表示同意<和源用户协议>" forState:UIControlStateNormal];
        [_agreementLabel addTarget:self action:@selector(agreementLabellll) forControlEvents:UIControlEventTouchDragInside];
        _agreementLabel.titleLabel.font = [UIFont systemFontOfSize:13];
        _agreementLabel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _agreementLabel.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
    }
    return _agreementLabel;
}

- (void)agreementLabellll{
    UserAgreementViewController *advc = [[UserAgreementViewController alloc] init];
    UINavigationController *root = [[UINavigationController alloc] initWithRootViewController:advc];
    [self presentViewController:root animated:YES completion:nil];
}

- (UIButton *)loadButton{
    if (!loadButton_) {
        loadButton_ = [UIButton buttonWithType:UIButtonTypeSystem];
        loadButton_.frame = CGRectMake(SCREEN_WIDTH-110, chushizuobiao+110, 80, 30);
        loadButton_.tintColor = RGB255_COLOR(68, 68, 68, 1);
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
    loginViewController *lvc = [[loginViewController alloc] init];
    [self presentViewController:lvc animated:YES completion:nil];
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
    NSString *kj_iphoneNum = [NSString stringWithFormat:@"%@",iPhone_.text];
    // 获取手机号
    NSString *paramString = [networkSection getParamStringWithParam:@{@"FunName":@"Get_Phone_List", @"Params":@{@"Phones":kj_iphoneNum}}];
    // 网络请求
    [networkSection getLoadJsonDataWithUrlString:IPUrl param:paramString];
    
    //回调函数获取数据
    [networkSection setGetLoadRequestDataClosuresCallBack:^(NSDictionary *json) {
        NSLog(@"-----%@",json);
        NSString *dataString = [[json valueForKey:@"RET"] valueForKey:@"DATA"];
        if ([dataString isEqualToString:@"No"]) {
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [self addAlertView];
            });
        }else{
            NSLog(@"手机号已存在!!!");
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [self addAlertViewIphone];
            });
        }
    }];
}

-(void)addAlertViewIphone{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"手机号码已被注册" message:@"请直接登录" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        dispatch_async(dispatch_get_main_queue(), ^(void){           
            loginViewController *lvc = [[loginViewController alloc] init];
            [self presentViewController:lvc animated:NO completion:nil];
        });
    }];
    [alertController addAction:action1];
    [self presentViewController:alertController animated:YES completion:NULL];
}

-(void)addAlertView{
    NSString *kj_iphoneNum = [NSString stringWithFormat:@"%@",iPhone_.text];
    NSString *s = @"我们将发送验证都手机号码：+86\n";
    NSString *sss = [s stringByAppendingString:kj_iphoneNum];
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
//    NSLog(@"%@",param);    // 把拼接后的字符串转换为data，设置请求体
    
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
                    [self addAlertViewTitle:@"网络连接失败😔😔" Message:@"😥😥请稍后再试!!!"];
                });
        }
        else
            dispatch_async(dispatch_get_main_queue(), ^(void){
                // 无网络
                [self addAlertViewTitle:@"网络连接失败😱😱" Message:@"😀😀请检查你的网络!!!"];
            });
    }];
    // 执行任务
    [dataTask resume];
}

#pragma mark 弹出AlertView
-(void)addAlertViewTitle:(NSString*)title Message:(NSString*)message{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:action1];
    [self presentViewController:alertController animated:YES completion:NULL];
}

@end

