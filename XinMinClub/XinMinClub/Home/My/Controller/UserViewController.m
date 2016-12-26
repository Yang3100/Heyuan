//
//  UserViewController.m
//  XinMinClub
//
//  Created by Jason_zzzz on 16/3/22.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "UserViewController.h"
#import "UserFirstCell.h"
#import "UIView+Draw.h"
#import "VPImageCropperViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "UserDataModel.h"
#import "SVProgressHUD.h"
#import "FBKVOController.h"

// cityPicker
#import "AddressFMDBManager.h"
#import "ProvinceAddressModel.h"
#import "CityAddressModel.h"
#import "DistrictModel.h"

#define PROVINCE_COMPONENT  0
#define CITY_COMPONENT      1
#define DISTRICT_COMPONENT  2

#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height) // 屏幕高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width) // 屏幕宽度

@interface UserViewController () <UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, UITextViewDelegate,UIImagePickerControllerDelegate, UIActionSheetDelegate, VPImageCropperDelegate, UIGestureRecognizerDelegate, UIPickerViewDelegate, UIPickerViewDataSource>{
    
    UINib *nib_;
    NSArray *userLabelArr_;
    NSArray *userDataArr_;
    UIDatePicker *datePicker_;
    NSIndexPath *indexPath_;
    UserFirstCell *cell_;
    
    FBKVOController *fbController;
    
    UIPickerView *sexPicker;
    // imagePicker
    UIImagePickerController *imagePicker;
    UIAlertController *choiceAlert;
    UIAlertController *sureAlert;
    
    // cityPicker
    UIPickerView *cityPicker;
    UIButton *button;
    // cityPickerDataModel
    NSMutableArray *province;
    NSMutableArray *city;
    NSMutableArray *district;
    NSString *selectedProvince;
    
    UserDataModel *userDataModel_;
}

@end

@implementation UserViewController

@synthesize userTableView = userTableView_;

static NSString * userFirstIdentifier = @"first";
static NSString * userSecondIdentifier = @"second";
static NSString * userThirdIdentifier = @"third";

- (void)viewDidLoad {
    [super viewDidLoad];
    userDataModel_ = [UserDataModel defaultDataModel];
    
    [self.view addSubview:[self userTableView]];
    
    [self initSelf];
    [self initCityPicker];
    [self imagePicker];
    [self sureAlert];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 禁止右划切换页面
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    if (userDataModel_.isReload) {
        userDataModel_.isReload = NO;
        [userTableView_ reloadData];
    }
    userDataModel_.isChange = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 允许右划切换页面
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    
}

static NSString *userFirstText = @"       ";

- (void)initSelf {
    
    self.title = @"个人资料";
    self.navigationController.delegate = self;
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    rightButton.frame = CGRectMake(0, 0, 40, 30);
    [rightButton setTitle:@"保存" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(saveUserData) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
    
    userLabelArr_ = @[userFirstText,@"昵称",@"性别",@"出生年月",@"所在城市",@"账号",@"简介"];
    userDataArr_ = @[@"更换头像",@"哟哈哈哈",@"男",@"1992-08-02",@"四川 成都 锦江区",@"17713458884",@"略"];
    
    nib_ = [UINib nibWithNibName:@"UserFirstCell" bundle:nil];
    [userTableView_ registerNib:nib_ forCellReuseIdentifier:userFirstIdentifier];
    nib_ = [UINib nibWithNibName:@"UserSecondCell" bundle:nil];
    [userTableView_ registerNib:nib_ forCellReuseIdentifier:userSecondIdentifier];
    nib_ = [UINib nibWithNibName:@"UserThirdCell" bundle:nil];
    [userTableView_ registerNib:nib_ forCellReuseIdentifier:userThirdIdentifier];
    
    //    UIControl *control = [[UIControl alloc] init];
    UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped)];
    gesture.delegate = self;
    [self.view addGestureRecognizer:gesture];
    
    //添加观察者,监听键盘弹出，隐藏事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)initCityPicker {
    province=[[NSMutableArray alloc] initWithCapacity:5];
    city=[[NSMutableArray alloc] initWithCapacity:5];
    district=[[NSMutableArray alloc] initWithCapacity:5];
    
    AddressFMDBManager *addFMDBManager=[AddressFMDBManager sharedAddressFMDBManager];
    
    //得到省份的model数组
    NSArray *arr=[NSArray arrayWithArray:[addFMDBManager selectAllProvince]];
    for (ProvinceAddressModel *provinceModel in arr) {
        [province addObject:provinceModel.name];
    }
    
    //得到市的model的数组
    NSArray *arr2=[NSArray arrayWithArray:[addFMDBManager selectAllCityFrom:1]];
    
    for (CityAddressModel *cityModel in arr2) {
        [city addObject:cityModel.name];
    }
    
    //得到区的model的数组
    NSArray *arr3=[NSArray arrayWithArray:[addFMDBManager selectAllDistrictFrom:1]];
    for (DistrictModel *districtModel in arr3) {
        [district addObject:districtModel.name];
    }

    selectedProvince = [province objectAtIndex: 0];
}

- (UIAlertController *)sureAlert {
    if (!sureAlert) {        
        sureAlert = [UIAlertController alertControllerWithTitle:nil message:@"是否放弃修改？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"放弃" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"继续编辑" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [sureAlert addAction:cancelAction];
        [sureAlert addAction:deleteAction];
    }
    return sureAlert;
}

#pragma mark (截获返回按钮事件)
-(BOOL) navigationShouldPopOnBackButton {
    
    [self judgeDataChange];
    [self backgroundTapped];
    if (userDataModel_.isChange) {
        [self presentViewController:sureAlert animated:YES completion:nil];
        return NO;
    }
    [self.navigationController popViewControllerAnimated:YES];
    return NO;
}

#pragma mark Views & (Gesture截获点击手势)

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    [self selfResign];
    // 若为UITableView（即点击了tableView），则不截获Touch事件
    if (![NSStringFromClass([touch.view class]) isEqualToString:@"UITableView"]) {
        return NO;
    }
    return  YES;
}

- (UIDatePicker *)datePicker{
    if (!datePicker_) {
        datePicker_ = [[UIDatePicker alloc] init];
        datePicker_.frame = CGRectMake(0, SCREEN_HEIGHT / 4 * 3, SCREEN_WIDTH, SCREEN_HEIGHT / 4);
        datePicker_.center = self.view.center;
        datePicker_.datePickerMode = UIDatePickerModeDate;
        datePicker_.backgroundColor = DEFAULT_LISTCOLOR;
        
        NSString *dateString = @"1900-01-01";
        NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
        [dateFormater setDateFormat:@"yyyy-MM-DD"];
        NSDate *minDate = [dateFormater dateFromString:dateString];
        
        NSDate *maxDate = [NSDate dateWithTimeIntervalSinceNow:0];
        datePicker_.minimumDate = minDate;
        datePicker_.maximumDate = maxDate;
//        datePicker_.minuteInterval = 3;//三分钟为单位,必须为60的约数
        [datePicker_ addTarget:self action:@selector(datePickerAction) forControlEvents:UIControlEventValueChanged];
    }
    return datePicker_;
}

- (UIPickerView *)sexPicker {
    if (!sexPicker) {
        sexPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT / 4)];
        sexPicker.dataSource = self;
        sexPicker.delegate = self;
        sexPicker.showsSelectionIndicator = YES;
        sexPicker.backgroundColor = DEFAULT_LISTCOLOR;
        [sexPicker selectRow: 0 inComponent: 0 animated: YES];
    }
    return sexPicker;
}

- (UIPickerView *)cityPicker {
    if (!cityPicker) {
        cityPicker = [[UIPickerView alloc] initWithFrame: CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT / 4)];
        cityPicker.dataSource = self;
        cityPicker.delegate = self;
        cityPicker.showsSelectionIndicator = YES;
        cityPicker.backgroundColor = DEFAULT_LISTCOLOR;
        [cityPicker selectRow: 0 inComponent: 0 animated: YES];
    }
    return cityPicker;
}

- (UITableView *)userTableView {
    if (!userTableView_) {
        userTableView_ = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
        userTableView_.dataSource = self;
        userTableView_.delegate = self;
    }
    userTableView_.backgroundColor = [UIColor whiteColor];
    [userTableView_ setSeparatorColor:[UIColor whiteColor]];
    //    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.01, 0.01)];
    //    userTabelView_.tableHeaderView = view;
    return userTableView_;
}

#pragma mark Actions

- (void)saveUserData {
    
    indexPath_ = [NSIndexPath indexPathForRow:0 inSection:1];
    cell_ = (UserFirstCell *)[userTableView_ cellForRowAtIndexPath:indexPath_];
    if (cell_.userDataField.text.length < 1) {
        [SVProgressHUD showErrorWithStatus:@"昵称不能为空"];
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.7f];
        return;
    }
    
    indexPath_ = [NSIndexPath indexPathForRow:0 inSection:userLabelArr_.count - 1];
    cell_ = (UserFirstCell *)[userTableView_ cellForRowAtIndexPath:indexPath_];
    if (cell_.userDetailDataField.text.length > 130) {
        [SVProgressHUD showErrorWithStatus:@"简介不能超过130个字符"];
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.7f];
        return;
    }
    
    // 判断资料是否改变
    if ([self judgeDataChange]) {
        for (NSInteger i = 0; i < userDataArr_.count; i++) {
            indexPath_ = [NSIndexPath indexPathForRow:0 inSection:i];
            cell_ = (UserFirstCell *)[userTableView_ cellForRowAtIndexPath:indexPath_];
            if (i == 0) {
                userDataModel_.userImage = cell_.userImage.image;
            }
            if (i == 1){
                userDataModel_.userName = cell_.userDataField.text;
            }
            if (i == 2){
                userDataModel_.userSex = cell_.userDataField.text;
            }
            if (i == 3){
                userDataModel_.userBornDate = cell_.userDataField.text;
            }
            if (i == 4){
                userDataModel_.userCity = cell_.userDataField.text;
            }
            if (i == 5){
                userDataModel_.userID = cell_.userDataField.placeholder;
            }
            if (i == userDataArr_.count - 1) {
                userDataModel_.userIntroduction = cell_.userDetailDataField.text;
            }
        }
        userDataModel_.isChange = NO;
    }
    
    [userDataModel_ saveLocalData];
    [userDataModel_ saveUserInternetData];
    [userDataModel_ saveUserImage];
    // 提示成功
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD show];
    [self performSelector:@selector(success) withObject:nil afterDelay:0.5f];
}

- (BOOL)judgeDataChange {
    for (NSInteger i = 0; i < userDataArr_.count; i++) {
        indexPath_ = [NSIndexPath indexPathForRow:0 inSection:i];
        cell_ = (UserFirstCell *)[userTableView_ cellForRowAtIndexPath:indexPath_];
        if (i == 0) {
            if (![userDataModel_.userImage isEqual:cell_.userImage.image]) {
                userDataModel_.isChange = YES;
                userDataModel_.isReload = YES;
            }
        }
        if (i == 1){
            if (![userDataModel_.userName isEqual:cell_.userDataField.text]) {
                userDataModel_.isChange = YES;
                userDataModel_.isReload = YES;
            }
        }
        if (i == 2){
            if (![userDataModel_.userSex isEqual:cell_.userDataField.text]) {
                userDataModel_.isChange = YES;
                userDataModel_.isReload = YES;
            }
        }
        if (i == 3){
            if (![userDataModel_.userBornDate isEqual:cell_.userDataField.text]) {
                userDataModel_.isChange = YES;
                userDataModel_.isReload = YES;
            }
        }
        if (i == 4){
            if (![userDataModel_.userCity isEqual:cell_.userDataField.text]) {
                userDataModel_.isChange = YES;
                userDataModel_.isReload = YES;
            }
        }
//        if (i == 5){
//            if (![userDataModel_.userID isEqual:cell_.userDataField.placeholder]) {
//                userDataModel_.isChange = YES;
//                userDataModel_.isReload = YES;
//            }
//        }
        if (i == userDataArr_.count - 1) {
            if (![userDataModel_.userIntroduction isEqual:cell_.userDetailDataField.text]) {
                userDataModel_.isChange = YES;
                userDataModel_.isReload = YES;
            }
        }
    }
    if (userDataModel_.isChange) {
        return YES;
    }
    return NO;
}

- (void)success {
    [SVProgressHUD showSuccessWithStatus:@"Success!"];
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.5f];
}

- (void)dismiss {
    [self backgroundTapped];
    [SVProgressHUD dismiss];
}

- (void)selfResign {
    NSArray *arr = @[@"1",@"2",@"3",@"4"];
    for (NSString *s in arr) {
        indexPath_ = [NSIndexPath indexPathForRow:0 inSection:[s intValue]];
        cell_ = (UserFirstCell *)[userTableView_ cellForRowAtIndexPath:indexPath_];
        [cell_.userDataField resignFirstResponder];
    }
}

- (void)backgroundTapped {
    [self selfResign];
    indexPath_ = [NSIndexPath indexPathForRow:0 inSection:userLabelArr_.count - 1];
    cell_ = (UserFirstCell *)[userTableView_ cellForRowAtIndexPath:indexPath_];
    [cell_.userDetailDataField resignFirstResponder];
}

- (void)datePickerAction {
    indexPath_ = [NSIndexPath indexPathForRow:0 inSection:3];
    UserFirstCell *cell = (UserFirstCell *)[userTableView_ cellForRowAtIndexPath:indexPath_];
    NSDate *select  = [datePicker_ date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *date = [dateFormatter stringFromDate:select];
    dispatch_async(dispatch_get_main_queue(), ^{
        cell.userDataField.text = date;
    });
}

#pragma mark TableViewDelegate & Datasource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        [self editPortrait];
    }
    //else if (indexPath.section == 4) {
//        [self cityPicker];
//    }
    else {
        [self backgroundTapped];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    if (section == 0 || section == 1 || section == 2 || section == 3 || section == 4) {
        return 50;
    } else if (section == userLabelArr_.count - 1) {
        return 160;
    }
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return userLabelArr_.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    fbController = [FBKVOController controllerWithObserver:self];
    
//    NSLog(@"%@********************",userDataModel_.userID);
    UserFirstCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:userFirstIdentifier forIndexPath:indexPath];
    
    cell.userDataField.enabled = NO;
    
    cell.userDataField.text = [userDataModel_.userName copy];
    if (indexPath.section == 0) {
        cell.userHeadView.hidden = NO;
        cell.userImage.hidden = NO;
        cell.userImage.image = userDataModel_.userImage;
        [cell.userImage roundedRectWithConerRadius:20 BorderWidth:0 borderColor:nil];
        cell.userDataField.text = userDataArr_[indexPath.section];
    }
    if (indexPath.section == 1){
        cell.userDataField.enabled = YES;
        cell.userDataField.text = userDataModel_.userName;
        // 建立通知中心，检测用户昵称输入
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldEditChanged:) name:UITextFieldTextDidChangeNotification object:cell.userDataField];
    }
    if (indexPath.section == 2){
//        cell.userDataField.placeholder = userDataModel_.userSex;
        cell.userDataField.text = userDataModel_.userSex;
        cell.userDataField.enabled = YES;
        cell.userDataField.inputView = [self sexPicker];
    }
    if (indexPath.section == 3){
        cell.userDataField.text = userDataModel_.userBornDate;
        cell.userDataField.enabled = YES;
        cell.userDataField.inputView = [self datePicker];
    }
    if (indexPath.section == 4){
        cell.userDataField.text = userDataModel_.userCity;
        cell.userDataField.enabled = YES;
        cell.userDataField.inputView = [self cityPicker];
    }
    if (indexPath.section == 5){
        cell.userDataField.placeholder = userDataModel_.userID;
        cell.userDataField.text = @"";
    }
    if (indexPath.section == userDataArr_.count - 1) {
//        cell.userDetailLabel.text = userLabelArr_[indexPath.section];
//        if (![userDataModel_.userIntroduction isEqualToString:@"还没有简介哦!"]) {
//        }
        cell.userLabel.hidden = YES;
        cell.userDetailLabel.hidden = NO;
        cell.userDetailDataField.hidden = NO;
        cell.userDataField.hidden = YES;
        cell.textNumber.hidden = NO;
        cell.userDetailDataField.delegate = self;
        cell.userDetailDataField.keyboardType = UIKeyboardTypeDefault;
        cell.textNumber.text = [NSString stringWithFormat:@"%d字", 130 - [userDataModel_.userIntroduction length]];
        cell.userDetailDataField.text = userDataModel_.userIntroduction;
    }
    [cell.userBackView roundedRectWithConerRadius:4 BorderWidth:1 borderColor:[UIColor colorWithWhite:0.782 alpha:1.000]];
    cell.userLabel.text = userLabelArr_[indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.userBackView.backgroundColor = [UIColor whiteColor];
    return cell;
}

#pragma mark- Picker Delegate & DataSource (地区信息,性别选择)

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if ([pickerView isEqual:sexPicker]) {
        return 1;
    }
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if ([pickerView isEqual:sexPicker]) {
        return 2;
    }
    if (component == PROVINCE_COMPONENT) {
        return [province count];
    }
    else if (component == CITY_COMPONENT) {
        return [city count];
    }
    else {
        return [district count];
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if ([pickerView isEqual:sexPicker]) {
        if (row == 0) {
            return @"男";
        }
        return @"女";
    }
    if (component == PROVINCE_COMPONENT) {
        return [province objectAtIndex: row];
    }
    else if (component == CITY_COMPONENT) {
        return [city objectAtIndex: row];
    }
    else {
        return [district objectAtIndex: row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if ([pickerView isEqual:sexPicker]) {
        indexPath_ = [NSIndexPath indexPathForRow:0 inSection:2];
        cell_ = (UserFirstCell *)[userTableView_ cellForRowAtIndexPath:indexPath_];
        cell_.userDataField.text = @"女";
        if (row == 0) {
            cell_.userDataField.text = @"男";
        }
        return;
    }
    if (component == PROVINCE_COMPONENT) {
        selectedProvince = [province objectAtIndex: row];
        
        AddressFMDBManager *addFMDBManager=[AddressFMDBManager sharedAddressFMDBManager];
        
        [city removeAllObjects];
        //得到市的model的数组
        NSArray *arr2=[NSArray arrayWithArray:[addFMDBManager selectAllCityFrom:row+1]];
        for (CityAddressModel *cityModel in arr2) {
            [city addObject:cityModel.name];
        }
        
        //获取城市id
        NSInteger cityId=[addFMDBManager selectIdFromCityWith:[city objectAtIndex:0]];
        
//        NSLog(@"城市id为:::%ld",cityId);
        [district removeAllObjects];
        //得到区的model的数组
        NSArray *arr3=[NSArray arrayWithArray:[addFMDBManager selectAllDistrictFrom:cityId]];
        for (DistrictModel *districtModel in arr3) {
            [district addObject:districtModel.name];
        }
        
        [cityPicker reloadComponent: CITY_COMPONENT];
        [cityPicker reloadComponent: DISTRICT_COMPONENT];
        [cityPicker reloadAllComponents];
        [cityPicker selectRow: 0 inComponent: CITY_COMPONENT animated: YES];
        [cityPicker selectRow: 0 inComponent: DISTRICT_COMPONENT animated: YES];
        
    } else if (component == CITY_COMPONENT) {
        //        NSInteger *provinceIndex = [province indexOfObject: selectedProvince];
        AddressFMDBManager *addFMDBManager=[AddressFMDBManager sharedAddressFMDBManager];
        NSString *cityName=[city objectAtIndex:row];
        NSInteger cityId=[addFMDBManager selectIdFromCityWith:cityName];
//        NSLog(@"====%@",cityName);
        [district removeAllObjects];
        //得到区的model的数组
        NSArray *arr3=[NSArray arrayWithArray:[addFMDBManager selectAllDistrictFrom:cityId]];
        for (DistrictModel *districtModel in arr3) {
            [district addObject:districtModel.name];
        }
        [cityPicker reloadComponent: DISTRICT_COMPONENT];
        [cityPicker selectRow: 0 inComponent: DISTRICT_COMPONENT animated: YES];
    }
    
    NSInteger provinceIndex = [cityPicker selectedRowInComponent: PROVINCE_COMPONENT];
    NSInteger cityIndex = [cityPicker selectedRowInComponent: CITY_COMPONENT];
    NSInteger districtIndex = [cityPicker selectedRowInComponent: DISTRICT_COMPONENT];
    
    NSString *provinceStr = [province objectAtIndex: provinceIndex];
    NSString *cityStr = [city objectAtIndex: cityIndex];
    NSString *districtStr = [district objectAtIndex:districtIndex];
    
    if ([provinceStr isEqualToString: cityStr] && [cityStr isEqualToString: districtStr]) {
        cityStr = @"";
        districtStr = @"";
    }
    else if ([cityStr isEqualToString: districtStr]) {
        districtStr = @"";
    }
    
    NSString *showMsg = [NSString stringWithFormat: @"%@ %@ %@", provinceStr, cityStr, districtStr];
    indexPath_ = [NSIndexPath indexPathForRow:0 inSection:4];
    cell_ = (UserFirstCell *)[userTableView_ cellForRowAtIndexPath:indexPath_];
    cell_.userDataField.text = showMsg;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    if ([pickerView isEqual:sexPicker]) {
        return 32;
    }
    else {
        return 32;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if ([pickerView isEqual:sexPicker]) {
        return 0;
    }
    if (component == PROVINCE_COMPONENT) {
        return 80;
        //        return 100;
    }
    else if (component == CITY_COMPONENT) {
        return 120;
    }
    else {
        return 120;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *myView = nil;
    
    if ([pickerView isEqual:sexPicker]) {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 30, 30)];
        myView.textAlignment = NSTextAlignmentCenter;
        myView.text = @"女";
        [myView setFont:[UIFont systemFontOfSize:21]];
        if (row == 0) {
            myView.text = @"男";
        }
        return myView;
    }

    if (component == PROVINCE_COMPONENT) {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 80, 30)];
        myView.textAlignment = NSTextAlignmentCenter;
        myView.text = [province objectAtIndex:row];
        myView.font = [UIFont systemFontOfSize:16];
        myView.backgroundColor = [UIColor clearColor];
    }
    else if (component == CITY_COMPONENT) {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 120, 30)];
        myView.textAlignment = NSTextAlignmentCenter;
        myView.text = [city objectAtIndex:row];
        myView.font = [UIFont systemFontOfSize:16];
        myView.backgroundColor = [UIColor clearColor];
    }
    else {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 120, 30)];
        myView.textAlignment = NSTextAlignmentCenter;
        myView.text = [district objectAtIndex:row];
        myView.font = [UIFont systemFontOfSize:16];
        myView.backgroundColor = [UIColor clearColor];
    }
    
    [myView setFont:[UIFont systemFontOfSize:21]];
    return myView;
}

#pragma mark TextFieldNotificationSelector (限制用户昵称长度)

- (void)textFieldEditChanged: (UITextField *)textField {
    indexPath_ = [NSIndexPath indexPathForRow:0 inSection:1];
    cell_ = (UserFirstCell *)[userTableView_ cellForRowAtIndexPath:indexPath_];
    NSString *toBeString = cell_.userDataField.text;
    NSString *lang = self.textInputMode.primaryLanguage;
    if ([lang isEqualToString:@"zh-Hans"]) {
        UITextRange *selectedRange = [cell_.userDataField markedTextRange];
        if (!selectedRange) {
            if (toBeString.length > 16) {
                cell_.userDataField.text = [toBeString substringToIndex:16];
            }
        }
        // 有高亮选择的字符串，则暂时不对文字进行统计和限制
        else {
        }
    }
    else {
        if (toBeString.length > 16) {
            cell_.userDataField.text = [toBeString substringToIndex:16];
        }
    }
}

#pragma mark UITextViewDelegate (用户简介长度)

- (void)textViewDidChange:(UITextView *)textView {
    
    indexPath_ = [NSIndexPath indexPathForRow:0 inSection:userLabelArr_.count - 1];
    cell_ = (UserFirstCell *)[userTableView_ cellForRowAtIndexPath:indexPath_];
    dispatch_async(dispatch_get_main_queue(), ^{
        cell_.textNumber.text = [NSString stringWithFormat:@"%d字", 130 - [textView.text length]];
    });
}

#pragma mark KeyBoard (键盘弹出收回)

//键盘弹出时不产生遮挡关系的设置
static BOOL isFirst = YES;
- (void)keyboardShow:(NSNotification *)notify{
    
    indexPath_ = [NSIndexPath indexPathForRow:0 inSection:userLabelArr_.count - 1];
    cell_ = (UserFirstCell *)[userTableView_ cellForRowAtIndexPath:indexPath_];
    if (!isFirst)
        return;
    isFirst = NO;
    if (cell_.userDetailDataField.isFirstResponder) {
        //获取高度差
        CGFloat deltaH = -userTableView_.frame.size.height / 7 * 2;
        
        [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            CGRect frame = userTableView_.frame;
            frame = CGRectMake(frame.origin.x, frame.origin.y + deltaH , frame.size.width, frame.size.height);
            userTableView_.frame = frame;
        } completion:nil];
    }
}

//键盘隐藏
- (void)keyboardHide:(NSNotification *)notify{
    
    isFirst = YES;
    CGRect frame = userTableView_.frame;
    frame = CGRectMake(frame.origin.x, 0, frame.size.width, frame.size.height);
    userTableView_.frame = frame;
}

#pragma mark ChoseUserImage (选择头像)

- (void)imagePicker {
    if (!imagePicker) {
        imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.view.backgroundColor = [UIColor whiteColor];
        imagePicker.delegate = self;
    }
    
    choiceAlert = [UIAlertController alertControllerWithTitle:@"选取头像方式" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
            
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([self isFrontCameraAvailable]) {
                imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            }
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            imagePicker.mediaTypes = mediaTypes;
            [self presentViewController:imagePicker
                               animated:YES
                             completion:^(void){
                             }];
        }
    }];
    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 从相册中选取
        if ([self isPhotoLibraryAvailable]) {
            
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            imagePicker.mediaTypes = mediaTypes;
            [self presentViewController:imagePicker
                               animated:YES
                             completion:^(void){
                             }];
        }
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [choiceAlert addAction:cancelAction];
    [choiceAlert addAction:takePhotoAction];
    [choiceAlert addAction:albumAction];
}

- (void)editPortrait {
    [self presentViewController:choiceAlert animated:YES completion:nil];
}

#pragma mark VPImageCropperDelegate (头像选择剪切完成)

- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {

    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        indexPath_ = [NSIndexPath indexPathForRow:0 inSection:0];
        cell_ = (UserFirstCell *)[userTableView_ cellForRowAtIndexPath:indexPath_];
        cell_.userImage.image = editedImage;
    }];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark - UIImagePickerControllerDelegate (相册中选择头像图片完成)

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        // 裁剪
        VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        imgEditorVC.view.backgroundColor = [UIColor whiteColor];
        imgEditorVC.delegate = self;
        [self presentViewController:imgEditorVC animated:YES completion:^{
            // TO DO
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}

//#pragma mark - UINavigationControllerDelegate
//
//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
//}
//
//- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    
//}

#pragma mark camera utility (头像选择权限判断)
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

#pragma mark image scale utility (修剪头像图片)
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < SCREEN_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = SCREEN_WIDTH;
        btWidth = sourceImage.size.width * (SCREEN_WIDTH / sourceImage.size.height);
    } else {
        btWidth = SCREEN_WIDTH;
        btHeight = sourceImage.size.height * (SCREEN_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
//    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

@end
