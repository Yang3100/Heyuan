//
//  ForgetViewController.m
//  XinMinClub
//
//  Created by yangkejun on 16/3/19.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "ForgetViewController.h"
#import "RegisterViewController.h"
#import "loginViewController.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define chushizuobiao ([UIScreen mainScreen].bounds.size.height/2)

@interface ForgetViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *backImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *curTextField;
@property (nonatomic, strong) UIButton *forgetButton;
@property (nonatomic, strong) UIButton *registerBtn;
@property (nonatomic, strong) UIButton *loadBtn;
@property (nonatomic, strong) UITextField *passwordField;
@property (nonatomic, strong) UITextField *verifyField;
@property (nonatomic, strong) UILabel *userLabel;
@property (nonatomic, strong) UILabel *keyLabel;
@property (nonatomic, strong) UIButton *againRegister;
@property(nonatomic, copy) UITextField *countryField;
@property(nonatomic, copy) UITextField *iphoneField;
@property(nonatomic, copy) UILabel *countryLabel;
@property(nonatomic, copy) UILabel *iphoneLabel;

// 计时器
@property(assign, nonatomic) NSInteger timeCount;
@property(strong, nonatomic) NSTimer *timer;

@end

@implementation ForgetViewController

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
    [self.view addSubview:self.countryLabel];
    [self.view addSubview:self.countryField];
    [self.view addSubview:self.iphoneLabel];
    [self.view addSubview:self.iphoneField];
    [self.view addSubview:self.againRegister];
    [self.view addSubview:self.forgetButton];
    [self.view addSubview:self.userLabel];
    [self.view addSubview:self.passwordField];
    [self.view addSubview:self.verifyField];
//    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.registerBtn];
    [self.view addSubview:self.loadBtn];
    
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

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Views

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 70, 30)];
        _titleLabel.textColor = RGB255_COLOR(68, 68, 68, 1);
        _titleLabel.text = @"忘记密码";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [_titleLabel setFont:[UIFont systemFontOfSize:16]];
    }
    return _titleLabel;
}

- (UIImageView *)backImage{
    if (!_backImage) {
        _backImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height + 3)];
        _backImage.image = loginCachePicture;
    }
    return _backImage;
}

//国家和地区输入提示
- (UILabel *)countryLabel{
    if (!_countryLabel) {
        _countryLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, chushizuobiao-110, 100, 30)];
        _countryLabel.text = @"国家和地区";
        _countryLabel.textAlignment = NSTextAlignmentCenter;
        _countryLabel.textColor = RGB255_COLOR(68, 68, 68, 1);
    }
    return _countryLabel;
}

// 国家和地区输入框
- (UITextField *)countryField{
    if (!_countryField) {
        _countryField = [[UITextField alloc] initWithFrame:CGRectMake(_countryLabel.center.x + 60, chushizuobiao-110, SCREEN_WIDTH/2, 30)];
        _countryField.placeholder = @"请输入国家地区";
        _countryField.text = @"中国";
        _countryField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _countryField .textColor = RGB255_COLOR(68, 68, 68, 1);
    }
    return _countryField;
}

//手机号码输入提示
- (UILabel *)iphoneLabel{
    if (!_iphoneLabel) {
        _iphoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, chushizuobiao-60, 100, 30)];
        _iphoneLabel.text = @"+86";
        _iphoneLabel.layer.borderWidth = 0.5;
        _iphoneLabel.layer.cornerRadius = 2.0;
        _iphoneLabel.textAlignment = NSTextAlignmentCenter;
        _iphoneLabel.textColor = RGB255_COLOR(68, 68, 68, 1);
    }
    return _iphoneLabel;
}

// 手机号码输入框
- (UITextField *)iphoneField{
    if (!_iphoneField) {
        _iphoneField = [[UITextField alloc] initWithFrame:CGRectMake(_iphoneLabel.center.x + 60, chushizuobiao-60, SCREEN_WIDTH/2, 30)];
        _iphoneField.placeholder = @"请输入手机号码";
        _iphoneField.keyboardType = UIKeyboardTypeNumberPad;
        _iphoneField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _iphoneField.returnKeyType = UIReturnKeyDone;//改变键盘为DONE键
        _iphoneField.delegate = self; //遵循协议,响应键盘弹出,隐藏事件,DONE键功能
        _iphoneField.textColor = RGB255_COLOR(68, 68, 68, 1);
    }
    return _iphoneField;
}

// ---------------------------------------------

//用户名输入提示
- (UILabel *)userLabel{
    if (!_userLabel) {
        _userLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, chushizuobiao, 100, 30)];
        _userLabel.text = @"获取验证码";
        _userLabel.layer.borderWidth = 0.5;
        _userLabel.layer.cornerRadius = 2.0;
        _userLabel.textAlignment = NSTextAlignmentCenter;
        _userLabel.textColor = RGB255_COLOR(68, 68, 68, 1);
    }
    return _userLabel;
}
- (UIButton *)againRegister{
    if (!_againRegister) {
        _againRegister = [UIButton buttonWithType:UIButtonTypeCustom];
        _againRegister.frame=CGRectMake(50, chushizuobiao, 100, 30);
        _againRegister.layer.borderWidth = 0.5;
        [_againRegister setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal]; // 字体颜色
        [_againRegister.titleLabel setFont:[UIFont boldSystemFontOfSize:14]]; //定义按钮标题字体格式
        [_againRegister addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside]; // 绑定点击事件
        _againRegister.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//文字左对齐
    }
    return _againRegister;
}

// 验证码输入框
- (UITextField *)verifyField{
    if (!_verifyField) {
        _verifyField = [[UITextField alloc] initWithFrame:CGRectMake(_userLabel.center.x + 60, chushizuobiao, SCREEN_WIDTH/2, 30)];
        _verifyField.placeholder = @"请输入验证码";
        _verifyField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _verifyField.keyboardType = UIKeyboardTypeNumberPad;
        _verifyField.returnKeyType = UIReturnKeyNext;//改变键盘，右下角位NEXT键
        _verifyField.delegate = self;//遵循协议,响应键盘弹出,隐藏事件,NEXT键功能
        _verifyField .textColor = RGB255_COLOR(68, 68, 68, 1);
    }
    return _verifyField;
}

// 密码输入框
- (UITextField *)passwordField{
    if (!_passwordField) {
        _passwordField = [[UITextField alloc] initWithFrame:CGRectMake(50, chushizuobiao+50, SCREEN_WIDTH-100, 30)];
        _passwordField.placeholder = @"请创建6-16位包含数字和字母的新密码";
        _passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passwordField.returnKeyType = UIReturnKeyDone;//改变键盘为DONE键
        _passwordField.secureTextEntry = YES; //密码输入模式
        _passwordField.delegate = self; //遵循协议,响应键盘弹出,隐藏事件,DONE键功能
        _passwordField.textColor = [UIColor whiteColor];
    }
    return _passwordField;
}

// 重置密码按钮
- (UIButton *)forgetButton{
    if (!_forgetButton) {
        _forgetButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _forgetButton.frame = CGRectMake(50, chushizuobiao+90, SCREEN_WIDTH-100, 50);
        [_forgetButton setTitle:@"重置密码" forState:UIControlStateNormal];
        _forgetButton.backgroundColor = RGB255_COLOR(0.0, 0.0, 0.0, 0.35);
        [_forgetButton addTarget:self action:@selector(forgetAction:) forControlEvents:UIControlEventTouchUpInside];
        _forgetButton.tintColor = [UIColor whiteColor];
    }
    return _forgetButton;
}

- (UIButton *)loadBtn{
    if (!_loadBtn) {
        _loadBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _loadBtn.frame = CGRectMake(28, chushizuobiao+145, 80, 30);
        _loadBtn.tintColor = RGB255_COLOR(68, 68, 68, 1);
        [_loadBtn setTitle:@"登录" forState:UIControlStateNormal];
        [_loadBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        _loadBtn.layer.masksToBounds = YES;
        _loadBtn.layer.cornerRadius = 5.0;
        _loadBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        [_loadBtn addTarget:self action:@selector(loadAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loadBtn;
}

- (UIButton *)registerBtn{
    if (!_registerBtn) {
        _registerBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _registerBtn.frame = CGRectMake(SCREEN_WIDTH-108, chushizuobiao+145, 80, 30);
        _registerBtn.tintColor = RGB255_COLOR(68, 68, 68, 1);
        [_registerBtn setTitle:@"注册" forState:UIControlStateNormal];
        [_registerBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        _registerBtn.layer.masksToBounds = YES;
        _registerBtn.layer.cornerRadius = 5.0;
        _registerBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        [_registerBtn addTarget:self action:@selector(registerAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerBtn;
}

#pragma mark 获取验证码
// 获取验证码
- (void)action:(UIButton *)sender{
    // 判断手机号是否等于11位
    if (_iphoneField.text.length == 11) {
    [self requestMessage];
    [self.view sendSubviewToBack:self.againRegister];
    [self.view bringSubviewToFront:self.userLabel];
    self.keyLabel.text = @"60秒";
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reduceTime:) userInfo:self repeats:YES];
    self.timeCount = 61;
    }else{
        [self addAlertViewTitle:@"获取验证码失败!!!" Message:@"请检查你的手机号码是否输入正确!!!"];
    }
}

- (void)reduceTime:(NSTimer *)codeTimer {
    self.timeCount--;
    if (self.timeCount == 0) {
        NSLog(@"请重新获取验证码");
        _againRegister.enabled = YES;
        [self.view sendSubviewToBack:self.userLabel];
        [self.view bringSubviewToFront:self.againRegister];
        [_againRegister setTitle:@"重新获取" forState:UIControlStateNormal];// 正常
        // 关闭计时器
        [self.timer invalidate];
    } else {
        NSString *str = [NSString stringWithFormat:@"%d秒", self.timeCount-1];
        _userLabel.text = str;
        [self.view sendSubviewToBack:self.againRegister];
        [self.view bringSubviewToFront:self.userLabel];
        _againRegister.enabled = NO;
    }
}

#pragma mark Actions
//移除响应者
- (IBAction)resignResponder:(id)sender{
    [_countryField resignFirstResponder];
    [_iphoneField resignFirstResponder];
    [_verifyField resignFirstResponder];
    [_passwordField resignFirstResponder];
}

//键盘弹出时不产生遮挡关系的设置
- (void)keyboardShow:(NSNotification *)notify{
    NSValue *value = [notify.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGFloat keyboardHeight = value.CGRectValue.size.height;
    
    //获取当前输入框的y值，高度值及屏幕高度
    CGFloat y = _curTextField.frame.origin.y;
    CGFloat h = _curTextField.frame.size.height;
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
//键盘隐藏
- (void)keyboardHide:(NSNotification *)notify{
    CGRect frame = self.view.frame;
    frame = CGRectMake(frame.origin.x, 0, frame.size.width, frame.size.height);
    self.view.frame = frame;
}

//点击键盘下一项
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_iphoneField resignFirstResponder];
    [_passwordField becomeFirstResponder];
    return YES;
}

//textField开始编辑
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    _curTextField = textField;
}

#pragma mark 正则表达式:手机号码校验
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

#pragma mark 正则表达式:判断长度大于6位小于16位并是否同时都包含且只有数字和字母
/**
 * 功能： 判断长度大于6位小于16位并是否同时包含且只有数字和字母
 */
-(BOOL)judgePassWordLegal:(NSString *)text{
    BOOL result = false;
    if (text.length>=6&&text.length<=16){
        NSString * regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,16}$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        result = [pred evaluateWithObject:text];
    }
    return result;
}

#pragma mark ButtonActions
// 重置密码功能
- (IBAction)forgetAction:(id)sender{
        if (![self validateMobile:_iphoneField.text]) {
            NSLog(@"请重新输入手机号");
            [_verifyField resignFirstResponder];
            [_passwordField resignFirstResponder];
            [_iphoneField becomeFirstResponder];
        }else if([_verifyField.text isEqualToString:@""]||_verifyField.text.length != 5){
            NSLog(@"请重新输入验证码");
            [_passwordField resignFirstResponder];
            [_iphoneField resignFirstResponder];
            [_verifyField becomeFirstResponder];
        }else if (![self judgePassWordLegal:_passwordField.text]){
            NSLog(@"请重新输入密码");
            [self addAlertView511];
            [_iphoneField resignFirstResponder];
            [_verifyField resignFirstResponder];
            [_passwordField becomeFirstResponder];
        }
        else if([self validateMobile:_iphoneField.text]&&_verifyField.text.length==5&&[self judgePassWordLegal:_passwordField.text]){
            NSLog(@"登陆中...");
            [self forgetRequest];
        }else{
            NSLog(@"请核对你的手机号码和验证码");
            [_iphoneField becomeFirstResponder];
        }
}

-(void)addAlertView511{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"密码输入错误!!!" message:@"请检查你的位数是否在6-16位，并且是否同时包含数字和字母!!!" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:action1];
    [self presentViewController:alertController animated:YES completion:NULL];
}

// 登录小按钮
- (IBAction)loadAction:(id)sender{
    NSLog(@"点击了登录");
    loginViewController *lvc = [[loginViewController alloc] init];
    [self presentViewController:lvc animated:YES completion:nil];
}
// 注册小按钮
- (IBAction)registerAction:(id)sender{
    NSLog(@"点击了注册");
    RegisterViewController *rvc = [[RegisterViewController alloc] init];
    [self presentViewController:rvc animated:YES completion:nil];
}

#pragma mark 网络请求
// 获取验证码(点击了重新获取按钮之后执行)
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
    NSString *s1 = @"{\"FunName\":\"Set_Right_Code\",\"Params\":{\"DATA\":\"";
    NSString *s2 = [NSString stringWithFormat:@"%@",_iphoneField.text];
    NSString *s3 = [s1 stringByAppendingFormat:@"%@",s2];
    NSString *S4 = @"\"}}";
    NSString *s5 = [s3 stringByAppendingFormat:@"%@",S4];
    NSString *param = s5;
//    NSLog(@"%@",param);    // 把拼接后的字符串转换为data，设置请求体
    
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // 解析数据
        if (data != nil) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            if (dict!=nil) {
//                NSLog(@"获取验证码返回的json%@",dict);
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
// 重置密码请求
- (void)forgetRequest{
    // 创建会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    // 设置请求路径
    NSURL *URL=[NSURL URLWithString:IPUrl];//不需要传递参数
    
    // 创建请求对象
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];//默认为get请求
    request.timeoutInterval=20.0;//设置请求超时为5秒
    request.HTTPMethod=@"POST";//设置请求方法
    // 参数..
    NSString *param = [NSString stringWithFormat:@"{\"FunName\": \"Get_Pass\", \"Params\": { \"PhoneNo\": \"%@\", \"RightCode\": \"%@\", \"EARA\": \"%@\", \"PassWord\": \"%@\" }}",_iphoneField.text,_verifyField.text,_countryField.text,_passwordField.text];
    NSLog(@"%@",param);
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // 解析数据
        if (data != nil) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            if (dict!=nil) {
//                NSLog(@"登录返回的json%@",dict);
                // Data为0表示注册失败,1表示验证码不对,2表示手机已存在,其他得到的是UserID
                NSString *dataString = [[dict valueForKey:@"RET"] valueForKey:@"DATA"];
//                NSLog(@"xxxxx%@", dataString);
                if ([dataString isEqualToString:@"1"]) {
                    // 验证码不正确
                    dispatch_async(dispatch_get_main_queue(), ^{
                       [self addAlertViewTitle:@"密码修改失败" Message:@"请确认你的验证码是否输入正确!!!"];
                    });
                }else{
                    // 密码修改成功
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self addAlertView];
                    });
                }
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
        NSLog(@"密码修改成功!!!");
    }];
    [alertController addAction:action1];
    [self presentViewController:alertController animated:YES completion:NULL];
}
-(void)addAlertView{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"密码修改成功!!!" message:@"请重新登录!!!" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        dispatch_async(dispatch_get_main_queue(), ^(void){            
            loginViewController *lvc = [[loginViewController alloc] init];
            [self presentViewController:lvc animated:YES completion:nil];
        });
    }];
    [alertController addAction:action1];
    [self presentViewController:alertController animated:YES completion:NULL];
}


@end
