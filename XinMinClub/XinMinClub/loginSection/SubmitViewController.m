//
//  RegisterViewController.m
//  XinMinClub
//
//  Created by yangkejun on 16/3/18.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "SubmitViewController.h"
#import "UserDataModel.h"
#import "HomeViewController.h"
#import "loginViewController.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface SubmitViewController ()<UITextFieldDelegate> {
    UITextField *userField_, *authField_;
    UITextField *curTextField_;
    UILabel *userLabel_;
    UILabel *keyLabel_;
    UIButton *submitButton_;
    UIImageView *backImage_;
}

@property(nonatomic, copy) UITextField *password;
@property(assign, nonatomic) NSInteger timeCount;
@property(strong, nonatomic) NSTimer *timer;
@property (nonatomic, strong) UIButton *againRegister; // 再次请求按钮
@property (nonatomic, strong) UIButton *goBackButton;

@end

@implementation SubmitViewController

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
    NSLog(@"%@",self.iphoneNum);
    
    [self.view addSubview:self.backImage];
    [self.view addSubview:self.submitButton];
    [self.view addSubview:self.userLabel];
    [self.view addSubview:self.keyLabel];
    [self.view addSubview:self.authField];
    [self.view addSubview:self.userField];
    [self.view addSubview:self.password];
    [self.view addSubview:self.againRegister];
    [self.view addSubview:self.goBackButton];
    
    //添加观察者,监听键盘弹出，隐藏事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reduceTime:) userInfo:self repeats:YES];
    self.timeCount = 61;
}

// 返回
-(void)clickaddBtn{
    // 关闭计时器
    [self.timer invalidate];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)reduceTime:(NSTimer *)codeTimer {
    self.timeCount--;
    if (self.timeCount == 0) {
        NSLog(@"请重新获取验证码");
        _againRegister.enabled = YES;
        [self.view sendSubviewToBack:self.keyLabel];
        [self.view bringSubviewToFront:self.againRegister];
        [_againRegister setTitle:@"重新获取" forState:UIControlStateNormal];// 正常
        // 关闭计时器
        [self.timer invalidate];
    } else {
        NSString *str = [NSString stringWithFormat:@"%d秒", self.timeCount-1];
        keyLabel_.text = str;
        [self.view sendSubviewToBack:self.againRegister];
        [self.view bringSubviewToFront:self.keyLabel];
        _againRegister.enabled = NO;
    }
}

#pragma mark Views
- (UIImageView *)backImage{
    if (!backImage_) {
        backImage_ = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height + 3)];
        backImage_.image = [UIImage imageNamed:@"login.jpg"];
    }
    return backImage_;
}

//用户名输入提示
- (UILabel *)userLabel{
    if (!userLabel_) {
        userLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(50, SCREEN_HEIGHT/2-110, 80, 30)];
        userLabel_.text = @"+86";
        userLabel_.textColor = [UIColor whiteColor];
        userLabel_.layer.borderWidth = 0.5;
        userLabel_.textAlignment = NSTextAlignmentCenter;
    }
    return userLabel_;
}

// 验证码输入提示
- (UILabel *)keyLabel{
    if (!keyLabel_) {
        keyLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(50, SCREEN_HEIGHT/2-50, 80, 30)];
        keyLabel_.text = @"60秒";
        keyLabel_.textColor = [UIColor whiteColor];
        keyLabel_.layer.borderWidth = 0.5;
        keyLabel_.textAlignment = NSTextAlignmentCenter;
    }
    return keyLabel_;
}
- (UIButton *)againRegister{
    if (!_againRegister) {
        _againRegister = [UIButton buttonWithType:UIButtonTypeCustom];
        _againRegister.frame = CGRectMake(50, SCREEN_HEIGHT/2-50, 80, 30);
        _againRegister.layer.borderWidth = 0.5;
        [_againRegister setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal]; // 字体颜色
        [_againRegister.titleLabel setFont:[UIFont boldSystemFontOfSize:14]]; //定义按钮标题字体格式
        [_againRegister addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside]; // 绑定点击事件
        _againRegister.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//文字左对齐
    }
    return _againRegister;
}

//用户名输入框
- (UITextField *)userField{
    if (!userField_) {
        userField_ = [[UITextField alloc] initWithFrame:CGRectMake(userLabel_.center.x + 50, SCREEN_HEIGHT/2-110, SCREEN_WIDTH/2, 30)];
        userField_.placeholder = @"请输入你的手机号";
        userField_.text = self.iphoneNum;
        userField_.keyboardType = UIKeyboardTypePhonePad;
        userField_.clearButtonMode = UITextFieldViewModeWhileEditing;
        userField_.returnKeyType = UIReturnKeyNext;//改变键盘，右下角位NEXT键
        userField_.delegate = self;//遵循协议,响应键盘弹出,隐藏事件,NEXT键功能
        userField_ .textColor = [UIColor whiteColor];
    }
    return userField_;
}

//验证码输入框
- (UITextField *)authField{
    if (!authField_) {
        authField_ = [[UITextField alloc] initWithFrame:CGRectMake(userLabel_.center.x + 50, SCREEN_HEIGHT/2-50, SCREEN_WIDTH/2-20, 30)];
        authField_.placeholder = @"请输入5位验证码";
        authField_.clearButtonMode = UITextFieldViewModeWhileEditing;
        authField_.keyboardType = UIKeyboardTypePhonePad;
        authField_.delegate = self; //遵循协议,响应键盘弹出,隐藏事件,DONE键功能
        authField_.textColor = [UIColor whiteColor];
    }
    return authField_;
}

// 密码
- (UITextField *)password{
    if (!_password) {
        _password = [[UITextField alloc]initWithFrame:CGRectMake(50, SCREEN_HEIGHT/2, SCREEN_WIDTH-100, 30)];
        _password.placeholder = @"请创建6-16位包含数字和字母的密码";
        _password.clearButtonMode = UITextFieldViewModeWhileEditing;
        _password.returnKeyType = UIReturnKeyDone;//改变键盘为DONE键
        _password.secureTextEntry = YES; //密码输入模式
        _password.delegate = self; //遵循协议,响应键盘弹出,隐藏事件,DONE键功能
        _password.textColor = [UIColor whiteColor];
    }
    return _password;
}

//提交按钮
- (UIButton *)submitButton{
    if (!submitButton_) {
        submitButton_ = [UIButton buttonWithType:UIButtonTypeSystem];
        submitButton_.frame = CGRectMake(50, SCREEN_HEIGHT/2+40, SCREEN_WIDTH-100, 50);
        [submitButton_ setTitle:@"提交" forState:UIControlStateNormal];
        submitButton_.backgroundColor = [UIColor colorWithWhite:0.065 alpha:0.800];
        [submitButton_ addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
        submitButton_.tintColor = [UIColor whiteColor];
    }
    return submitButton_;
}
- (UIButton *)goBackButton{
    if (!_goBackButton) {
        CGFloat x = 10;
        CGFloat y = 30;
        CGFloat w = 50;
        CGFloat h = 30;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(x, y, w, h);
        [button setTitle:@"返回" forState:UIControlStateNormal];//正常
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal]; // 字体颜色
        [button addTarget:self action:@selector(gobackButton:) forControlEvents:UIControlEventTouchUpInside]; // 绑定点击事件
        button.showsTouchWhenHighlighted = YES; // 设置按钮按下会发光
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//文字左对齐
        _goBackButton = button;
    }
    return _goBackButton;
}

#pragma mark Actions
// 返回按钮
- (void)gobackButton:(UIButton *)sender{
    // 设置切换动画
    CATransition *animation = [CATransition animation];
    animation.duration = 0.4;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"cube";
    animation.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:animation forKey:nil];
    [self dismissViewControllerAnimated:NO completion:nil];
}
//移除响应者
- (IBAction)resignResponder:(id)sender{
    [userField_ resignFirstResponder];
    [authField_ resignFirstResponder];
    [_password resignFirstResponder];
}
//键盘弹出时不产生遮挡关系的设置
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
//键盘隐藏
- (void)keyboardHide:(NSNotification *)notify{
    CGRect frame = self.view.frame;
    frame = CGRectMake(frame.origin.x, 0, frame.size.width, frame.size.height);
    self.view.frame = frame;
}

//点击键盘下一项
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [userField_ resignFirstResponder];
    [authField_ becomeFirstResponder];
    return YES;
}

// textField开始编辑
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    curTextField_ = textField;
}

#pragma mark  密码规范 判断密码是否包含数字和字母
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
// 提交功能
- (IBAction)submitAction:(id)sender{
    if (![userField_.text isEqualToString:self.iphoneNum]) {
        NSLog(@"请重新输入用户名");
        [userField_ becomeFirstResponder];
        [authField_ resignFirstResponder];
        [_password resignFirstResponder];
    }else if(authField_.text.length!=5){
        NSLog(@"请重新输入验证码");
        [userField_ resignFirstResponder];
        [authField_ becomeFirstResponder];
        [_password resignFirstResponder];
    }else if(![self judgePassWordLegal:_password.text]){
        NSLog(@"请重新输入密码");
        [self addAlertView511];
        [userField_ resignFirstResponder];
        [authField_ resignFirstResponder];
        [_password becomeFirstResponder];
    }else if([userField_.text isEqualToString:self.iphoneNum]&&authField_.text.length==5&&[self judgePassWordLegal:_password.text]){
        [self submitRequest];
        NSLog(@"提交中...");
    }else{
        NSLog(@"请核对你的验证码");
        [authField_ becomeFirstResponder];
    }
}

-(void)addAlertView511{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"密码输入错误!!!" message:@"请检查你的位数是否在6-16位，并且是否同时包含数字和字母!!!" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

    }];
    [alertController addAction:action1];
    [self presentViewController:alertController animated:YES completion:NULL];
}


// 重新获取验证码
- (IBAction)action:(UIButton *)sender{
    [self requestMessage];
    [self.view sendSubviewToBack:self.againRegister];
    [self.view bringSubviewToFront:self.keyLabel];
    self.keyLabel.text = @"60秒";
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reduceTime:) userInfo:self repeats:YES];
    self.timeCount = 61;
}

// 注册请求(点击了重新获取按钮之后执行)
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
    NSString *param = [NSString stringWithFormat:@"{\"FunName\":\"Set_Right_Code\",\"Params\":{\"DATA\":\"%@\"}}",self.iphoneNum];
//    NSLog(@"%@",param); 
    
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // 解析数据
        if (data != nil) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            if (dict!=nil) {
//                NSLog(@"登录返回的json%@",dict);
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

// 提交请求
- (void)submitRequest{
    // 创建会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    // 设置请求路径
    NSURL *URL=[NSURL URLWithString:IPUrl];//不需要传递参数
    
    // 创建请求对象
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];//默认为get请求
    request.timeoutInterval=20.0;//设置请求超时为5秒
    request.HTTPMethod=@"POST";//设置请求方法
    // 参数..
    NSString *param = [NSString stringWithFormat:@"{\"FunName\": \"Add_User\", \"Params\": { \"PhoneNo\": \"%@\", \"RightCode\": \"%@\", \"EARA\": \"%@\", \"PassWord\": \"%@\" }}",self.iphoneNum,authField_.text,self.country,_password.text];
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
                NSLog(@"xxxxx%@", dataString);
                if ([dataString isEqualToString:@"0"]) {
                    // 注册不成功
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self addAlertViewTitle:@"注册失败" Message:nil];
                    });
                }else if ([dataString isEqualToString:@"1"]){
                    // 验证码不正确
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self addAlertViewTitle:@"请确认验证码" Message:nil];
                    });
                }else if ([dataString isEqualToString:@"2"]){
                    // 手机已存在
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [self addAlertView];
//                    });
                }else{
                    // 注册成功
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self addAlertViewTitle:@"注册成功!!!" Message:@"欢迎使用和源!!!"];
                        HomeViewController *hvc = [[HomeViewController alloc] init];
                        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:hvc];
                        [self presentViewController:nav animated:YES completion:^{
                            // 保存到本地
                            [[shareObjectModel shareObject] setAccount:self.iphoneNum Password:_password.text];
                            [UserDataModel defaultDataModel].userID = dataString;
                        }];
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

@end
