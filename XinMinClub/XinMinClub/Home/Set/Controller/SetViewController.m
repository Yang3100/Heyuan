//
//  SetViewController.m
//  XinMinClub
//
//  Created by Jason_zzzz on 16/3/24.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "SetViewController.h"
#import "SetCell.h"
#import "UIView+Draw.h"
#import "UserViewController.h"
#import "AboutApp.h"
#import "Help.h"
#import "SVProgressHUD.h"
#import "UserDataModel.h"
#import "cleanUpView.h"
#import "ICETutorialController.h"

#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height) // 屏幕高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width) // 屏幕宽度

#define DEFAULT_HEIGHT SCREEN_HEIGHT / 5

@interface SetViewController () <UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate,loginDelegate,forgetDelegate,registerDelegate,ICETutorialControllerDelegate> {
    NSArray *setArr;
    NSArray *setArr1;
    NSArray *setArr2;
    UIColor *borderColor;
    UserViewController *userVC;
    AboutApp *aboutApp;
    Help *help;
    UserDataModel *userModel_;
    UIAlertController *choiceAlert;
    UIDatePicker *timePicker_;
    UIView *timeBackView;
    UIControl *backView;
    UILabel *titleLabel;
    UISwitch *setTimeSwitch;
    CGRect titleLabelFrame;
    CGRect timeBackViewFrame;
    CGRect pickerFrame;
    UIButton *cancelButton;
    UIButton *sureButton;
    UIView *headView;
    UILabel *timeLabel;
    NSTimer *timer;
    UIAlertController *clearAlert;
    UIAlertController *sexAlert;
    
    loginViewController *kj_login;
    ForgetViewController *kj_forget;
    RegisterViewController *kj_register;
    ICETutorialController *icetutorial;
}

@property (nonatomic, strong) UITableView *setTableView;

@end

@implementation SetViewController

- (id)init {
    userModel_ = [UserDataModel defaultDataModel];
    if (self = [super init]) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
    setArr = @[@"个人资料",@"定时关闭",@"默认语言",@"清除缓存"];
    setArr1 = @[@"退出登录",@"关于"];
    setArr2 = @[@"",@"",@""];
    [self.view addSubview:self.setTableView];
    [self choiceAlert];
    [self clearAlert];
    [self sexAlert];
    [self setTimer];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_setTableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self backTapped];
}

static NSString *setCellIdentifier = @"setCell";
- (UITableView *)setTableView {
    if (!_setTableView) {
        CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        _setTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
        _setTableView.delegate = self;
        _setTableView.dataSource = self;
        _setTableView.backgroundColor = [UIColor whiteColor];
        [_setTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        UINib *nib = [UINib nibWithNibName:@"SetCell" bundle:nil];
        [_setTableView registerNib:nib forCellReuseIdentifier:setCellIdentifier];
    }
    return  _setTableView;
}

#pragma mark ProgressMethods

- (void)dismiss {
    [SVProgressHUD dismiss];
}

- (void)success {
    [SVProgressHUD showSuccessWithStatus:@"Clean Up!"];
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.5f];
}

#pragma mark Methods

- (void)sureLoginOut {
    [self presentViewController:choiceAlert animated:YES completion:nil];
}

- (void)setTimer {
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    timer.fireDate = [NSDate distantFuture];
}

- (void)setTimeLabel {
    timeLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", [DataModel defaultDataModel].playTime / 60 / 60, [DataModel defaultDataModel].playTime / 60 % 60, [DataModel defaultDataModel].playTime % 60];
}

- (void)sureClear {
    [self presentViewController:clearAlert animated:YES completion:nil];
}

// 清除分割线
- (void)clearSeparatorWithView:(UIView * )view{
    if(view.subviews != 0  )
    {
        if(view.bounds.size.height < 5)
        {
            view.backgroundColor = [UIColor clearColor];
        }
        
        [view.subviews enumerateObjectsUsingBlock:^( UIView *  obj, NSUInteger idx, BOOL *  stop) {
            [self clearSeparatorWithView:obj];
        }];
    }
}

- (void)defaultLanguage {
    [self presentViewController:sexAlert animated:YES completion:nil];
}

- (void)setPlayTime {
    
    [self backView];
    backView.hidden = NO;
    
    timePicker_.countDownDuration = [DataModel defaultDataModel].playTime;
    [UIView animateWithDuration:0.15 delay:0.1 options:UIViewAnimationOptionCurveEaseIn animations:^{
        backView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.354];
        timeBackView.frame = CGRectMake(0, SCREEN_HEIGHT - DEFAULT_HEIGHT - 5 , SCREEN_WIDTH, DEFAULT_HEIGHT + 5);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            timeBackView.frame = CGRectMake(0, SCREEN_HEIGHT - DEFAULT_HEIGHT , SCREEN_WIDTH, DEFAULT_HEIGHT);
        }completion:nil];
    }];
}

#pragma mark Views

- (UIAlertController *)clearAlert {
    if (!clearAlert) {
        clearAlert = [UIAlertController alertControllerWithTitle:@"确定清除缓存吗" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSString *filePath = [NSString stringWithFormat:@"%@/Documents/bookFile", NSHomeDirectory()];
            [fileManager removeItemAtPath:filePath error:nil];
            filePath = [NSString stringWithFormat:@"%@/Documents/mp3", NSHomeDirectory()];
            [fileManager removeItemAtPath:filePath error:nil];
            // 清除sdwebImage缓存的图片
            [[LoadAnimation defaultDataModel] clearTmpPics];
            
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
            [SVProgressHUD show];
            [self performSelector:@selector(success) withObject:nil afterDelay:0.6f];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [clearAlert addAction:cancelAction];
        [clearAlert addAction:takePhotoAction];
    }
    return clearAlert;
}

- (UIAlertController *)sexAlert {
    if (!sexAlert) {
        sexAlert = [UIAlertController alertControllerWithTitle:@"" message:@"选择默认语言" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *chineseAction = [UIAlertAction actionWithTitle:@"中文" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [DataModel defaultDataModel].setDefaultLanguage = ChineseFamiliar;
        }];
        UIAlertAction *chineseFuckAction = [UIAlertAction actionWithTitle:@"繁體" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [DataModel defaultDataModel].setDefaultLanguage = ChineseTraditional;
        }];
//        UIAlertAction *englishAction = [UIAlertAction actionWithTitle:@"English" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            [DataModel defaultDataModel].setDefaultLanguage = EnglishLanguage;
//        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [sexAlert addAction:chineseAction];
        [sexAlert addAction:chineseFuckAction];
//        [sexAlert addAction:englishAction];
        [sexAlert addAction:cancelAction];
    }
    return sexAlert;
}

- (UIAlertController *)choiceAlert {
    if (!choiceAlert) {
        choiceAlert = [UIAlertController alertControllerWithTitle:@"退出登录后不会删除数据"  message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"退出登录"style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
            [SVProgressHUD show];
            [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.5f];
            
            // 关闭播放器
            [[playerViewController defaultDataModel] timerForSetIsStop:YES];
            
            [userModel_ loginOut];
            // 删除本地账号密码
            [[shareObjectModel shareObject] deleteAccountAndPassword];
            [[self appRootViewController] dismissViewControllerAnimated:NO completion:^{
//                if (!kj_login) {
//                    kj_login = [[loginViewController alloc] init];
//                    kj_login.delegate = self;
//                }
                // 设置滚动的文字和图片
                ICETutorialPage *layer1 = [[ICETutorialPage alloc] initWithTitle:@"雅書華學舘" subTitle:@"仁愛謹信  知行合一" pictureName:@"引导页1" duration:3.0];
                ICETutorialPage *layer2 = [[ICETutorialPage alloc] initWithTitle:@"雅書華學舘" subTitle:@"雅讀詩書氣質華" pictureName:@"引导页2" duration:3.0];
                ICETutorialPage *layer3 = [[ICETutorialPage alloc] initWithTitle:@"樂 學 堂" subTitle:@"仁愛謹信  知行合一" pictureName:@"引导页3" duration:3.0];
                ICETutorialPage *layer4 = [[ICETutorialPage alloc] initWithTitle:@"樂 學 堂" subTitle:@"好學者不如樂學者" pictureName:@"引导页4" duration:3.0];
                NSArray *tutorialLayers = @[layer4,layer2,layer3,layer1];
                // Set the common style for the title.
                ICETutorialLabelStyle *titleStyle = [[ICETutorialLabelStyle alloc] init];
                [titleStyle setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17.0f]];
                [titleStyle setTextColor:RGB255_COLOR(122, 111, 77, 1)];
                [titleStyle setLinesNumber:1];
                [titleStyle setOffset:180];
                [[ICETutorialStyle sharedInstance] setTitleStyle:titleStyle];
                // Set the subTitles style with few properties and let the others by default.
                [[ICETutorialStyle sharedInstance] setSubTitleColor:RGB255_COLOR(212, 175, 116, 1)];
                [[ICETutorialStyle sharedInstance] setSubTitleOffset:150];
                // Init tutorial.
                icetutorial = [[ICETutorialController alloc] initWithPages:tutorialLayers delegate:self];
                // Run it.
                [icetutorial startScrolling];
                
                [[self appRootViewController] presentViewController:icetutorial animated:YES completion:nil];
                // 游客登录
                [DataModel defaultDataModel].isVisitorLoad = NO;
            }];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [choiceAlert addAction:cancelAction];
        [choiceAlert addAction:sureAction];
    }
    return choiceAlert;
}

#pragma mark - ICETutorialController delegate
- (void)tutorialController:(ICETutorialController *)tutorialController didClickOnLeftButton:(UIButton *)sender {
    //    NSLog(@"点击了登录");
    if (!kj_login) {
        kj_login = [[loginViewController alloc] init];
        kj_login.delegate = self;
    }
    [icetutorial presentViewController:kj_login animated:YES completion:nil];
}


- (void)tutorialController:(ICETutorialController *)tutorialController didClickOnRightButton:(UIButton *)sender {
    //    NSLog(@"点击了注册");
    if (!kj_register) {
        kj_register = [[RegisterViewController alloc] init];
        kj_register.delegate = self;
    }
    [icetutorial presentViewController:kj_register animated:YES completion:nil];
}

- (void)tutorialController:(ICETutorialController *)tutorialController didClickOnVisitorButton:(UIButton *)sender{
    // 游客登录
    HomeViewController *hvc = [[HomeViewController alloc] init];
    HomeNavController *nav = [[HomeNavController alloc] initWithRootViewController:hvc];
    [icetutorial presentViewController:nav animated:NO completion:^{
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"wechatLoadSucessful" object:nil];
        [DataModel defaultDataModel].isVisitorLoad = YES;
    }];
}


#pragma mark loginDelegate
- (void)loginToRegister:(UIViewController *)viewController{
    if (!kj_register) {
        kj_register = [[RegisterViewController alloc] init];
        kj_register.delegate = self;
    }
    [[self appRootViewController] presentViewController:kj_register animated:YES completion:nil];
}

- (void)loginToForget:(UIViewController *)viewController{
    if (!kj_forget) {
        kj_forget = [[ForgetViewController alloc] init];
        kj_forget.delegate = self;
    }
    [[self appRootViewController] presentViewController:kj_forget animated:YES completion:nil];
}
#pragma mark registerDelegate
- (void)registerToLogin:(UIViewController *)viewController{
    if (!kj_login) {
        kj_login = [[loginViewController alloc] init];
        kj_login.delegate = self;
    }
    [[self appRootViewController] presentViewController:kj_login animated:YES completion:nil];
}
#pragma mark forgetDelegate
- (void)forgetToRegister:(UIViewController *)viewController{
    if (!kj_register) {
        kj_register = [[RegisterViewController alloc] init];
        kj_register.delegate = self;
    }
    [[self appRootViewController] presentViewController:kj_register animated:YES completion:nil];
}
- (void)forgerToLogin:(UIViewController *)viewController{
    if (!kj_login) {
        kj_login = [[loginViewController alloc] init];
        kj_login.delegate = self;
    }
    [[self appRootViewController] presentViewController:kj_login animated:YES completion:nil];
}

#pragma mark 最顶层视图控制器
- (UIViewController *)appRootViewController{
    UIViewController*appRootVC=[UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController*topVC=appRootVC;
    while(topVC.presentedViewController) {
        topVC=topVC.presentedViewController;
    }
    return topVC;
}

- (UIControl *)backView {
    if (!backView) {
        backView = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//        [backView addTarget:self action:@selector(backTapped) forControlEvents:UIControlEventTouchUpInside];
        backView.hidden = YES;
        backView.backgroundColor = [UIColor clearColor];
        [self.view.superview.window addSubview:backView];
        [backView addSubview:[self timeBackView]];
    }
    return backView;
}

- (UIView *)timeBackView {
    if (!timeBackView) {
        timeBackViewFrame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0);
        timeBackView = [[UIView alloc] initWithFrame:timeBackViewFrame];
        timeBackViewFrame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, DEFAULT_HEIGHT);
        timeBackView.backgroundColor = [UIColor whiteColor];
        [timeBackView addSubview:[self headView]];
        [timeBackView addSubview:[self timePicker]];
        [self clearSeparatorWithView:[self timePicker]];
    }
    return timeBackView;
}

- (UIView *)headView {
    if (!headView) {
        CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, timeBackViewFrame.size.height / 5);
        headView = [[UIView alloc] initWithFrame:frame];
        headView.backgroundColor = [UIColor whiteColor];
        [headView addSubview:[self cancelButton]];
        [headView addSubview:[self sureButton]];
        //        [headView addSubview:[self headViewFootLine]];
    }
    return headView;
}

- (UIDatePicker *)timePicker {
    if (!timePicker_) {
        timePicker_ = [[UIDatePicker alloc] init];
        CGFloat y = headView.frame.size.height;
        CGFloat x = 20;
        timePicker_.frame = CGRectMake(x, y + 5, SCREEN_WIDTH - x, timeBackViewFrame.size.height - y - 5);
        timePicker_.datePickerMode = UIDatePickerModeCountDownTimer;
        timePicker_.backgroundColor = [UIColor whiteColor];
        //        datePicker_.minuteInterval = 3;//三分钟为单位,必须为60的约数
        //        [timePicker_ addTarget:self action:@selector(datePickerAction) forControlEvents:UIControlEventValueChanged];
        NSLog(@"%f",timePicker_.countDownDuration);
    }
    return timePicker_;
}

- (UIButton *)sureButton {
    if (!sureButton) {
        sureButton = [UIButton buttonWithType:UIButtonTypeSystem];
        sureButton.frame = CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH / 6, 0, SCREEN_WIDTH / 6, headView.frame.size.height);
        [sureButton setTitleColor:DEFAULT_COLOR forState:UIControlStateNormal];
        [sureButton setTitle:@"完成" forState:UIControlStateNormal];
        [sureButton addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return sureButton;
}

- (UIView *)headViewFootLine {
    CGRect frame = CGRectMake(0, headView.bounds.size.height - 1, SCREEN_WIDTH, 0.5);
    UIView *headViewFootLine = [[UIView alloc] initWithFrame:frame];
    headViewFootLine.backgroundColor = [UIColor colorWithWhite:0.869 alpha:1.000];
    return headViewFootLine;
}

- (UIButton *)cancelButton {
    if (!cancelButton) {
        cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
        cancelButton.frame = CGRectMake(0, 0, SCREEN_WIDTH / 6, headView.frame.size.height);
        [cancelButton setTitleColor:DEFAULT_COLOR forState:UIControlStateNormal];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return cancelButton;
}

#pragma mark Actions

- (void)timerAction {
    if ([DataModel defaultDataModel].playTime > 0) {
        
        [DataModel defaultDataModel].playTime--;
        [self setTimeLabel];
    }
    else if ([DataModel defaultDataModel].playTime == 0) {
        timer.fireDate = [NSDate distantFuture];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"playTime" object:nil];
        setTimeSwitch.on = NO;
        [self switchAction];
        [[playerViewController defaultDataModel] timerForSetIsStop:YES];
    }
}

- (void)backTapped {
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        backView.backgroundColor = [UIColor clearColor];
        timeBackView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0);
    } completion:^(BOOL finished) {
        backView.hidden = YES;
    }];
}

- (void)switchAction {
    [DataModel defaultDataModel].playTimeOn =![DataModel defaultDataModel].playTimeOn;
    timer.fireDate = [NSDate distantFuture];
    if ([DataModel defaultDataModel].playTimeOn) {
        timer.fireDate = [NSDate distantPast];
    }
}

- (void)cancelAction {
    [self backTapped];
}

- (void)sureAction {
    [self backTapped];
    [DataModel defaultDataModel].playTime = timePicker_.countDownDuration;
    [self setTimeLabel];
}

#pragma mark TableViewDelegate & Datasource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            if ([DataModel defaultDataModel].isVisitorLoad) {
                [[DataModel defaultDataModel] pushLoadViewController];
            }else{
            [_delegate pushUserDataView];
            }
        }
        if (indexPath.row == 1) {
            [self setPlayTime];
        }
        if (indexPath.row == 2) {
            [self defaultLanguage];
        }
        if (indexPath.row == 3) {
//            [self sureClear];
            cleanUpView *cuv = [[cleanUpView alloc] init];
            cuv.view.backgroundColor = [UIColor whiteColor];
            [self.navigationController pushViewController:cuv animated:NO];
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self sureLoginOut];
        }
        if (indexPath.row == 1) {
            if (!aboutApp) {
                aboutApp = [[AboutApp alloc] init];
            }
            [self.navigationController pushViewController:aboutApp animated:YES];
        }
//        if (indexPath.row == 2) {
//            if (!help) {
//                help = [[Help alloc] init];
//            }
//            [self.navigationController pushViewController:help animated:YES];
//        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return setArr.count;
    }
    return setArr1.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SetCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:setCellIdentifier forIndexPath:indexPath];
    if (indexPath.section == 0) {
        cell.setLabel.text = setArr[indexPath.row];
        if (indexPath.row == 0) {
            cell.setImage.image = userModel_.userImage;
        }
        if (indexPath.row == 1) {
            cell.timeSwitch.hidden = NO;
            cell.timeSwitch.transform = CGAffineTransformMakeScale(0.75, 0.75);
            cell.accessoryImage.hidden = YES;
            cell.timeLabel.hidden = NO;
            timeLabel = cell.timeLabel;
            setTimeSwitch = cell.timeSwitch;
            [setTimeSwitch addTarget:self action:@selector(switchAction) forControlEvents:UIControlEventValueChanged];
        }
    }
    else if (indexPath.section == 1) {
        cell.setLabel.text = setArr1[indexPath.row];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    borderColor = [UIColor colorWithWhite:0.782 alpha:1.000];
    cell.setImage.hidden = YES;
    cell.detailLabel.hidden = NO;
    
    [cell.footView roundedRectWithConerRadius:0 BorderWidth:1 borderColor:borderColor];
    [cell.topView roundedRectWithConerRadius:0 BorderWidth:1 borderColor:borderColor];
    cell.topCoverView.hidden = NO;
    
    if (indexPath.row == 0) {
        if (indexPath.section == 0) {
            cell.setImage.hidden = NO;
            [cell.setImage roundedRectWithConerRadius:15 BorderWidth:0 borderColor:nil];
        }
        [cell.topView roundedRectWithConerRadius:4 BorderWidth:1 borderColor:borderColor];
        [cell.footView roundedRectWithConerRadius:0 BorderWidth:1 borderColor:borderColor];
        cell.footCoverView.hidden = NO;
        cell.topCoverView.hidden = YES;
    }
    if (indexPath.section == 0) {
        if (indexPath.row == setArr.count - 1) {
            [cell.topView roundedRectWithConerRadius:0 BorderWidth:1 borderColor:borderColor];
            [cell.footView roundedRectWithConerRadius:4 BorderWidth:1 borderColor:borderColor];
        }
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == setArr1.count - 1) {
            [cell.topView roundedRectWithConerRadius:0 BorderWidth:1 borderColor:borderColor];
            [cell.footView roundedRectWithConerRadius:4 BorderWidth:1 borderColor:borderColor];
        }
    }
    
    cell.detailLabel.hidden = YES;
    cell.color = [UIColor whiteColor];
    return cell;
}

@end
