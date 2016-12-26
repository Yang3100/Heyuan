////
////  SectionCell.m
////  XinMinClub
////
////  Created by yangkejun on 16/3/22.
////  Copyright © 2016年 yangkejun. All rights reserved.
////
//
//#import "SectionCell.h"
//#import "TransferStationObject.h"
//#import "PalyerViewController.h"
//#import "ReaderTableViewController.h"
//
//@interface SectionCell(){
//    NSInteger saveTag;
//    NSMutableArray <NSMutableDictionary *> *saveDictArray;
//    NSMutableDictionary *saveDictionary;
//}
//
//@property (weak, nonatomic) IBOutlet UILabel *sectionTotalLabel;
//@property (weak, nonatomic) IBOutlet UILabel *sectionTextLabel;
//@property (weak, nonatomic) IBOutlet UIButton *sectionButton;
//
//@property(nonatomic, readonly) UIViewController *viewController;
//
//@end
//
//@implementation SectionCell
//
////  获取当前view所处的viewController重写读方法
//- (UIViewController *)viewController{
//    for (UIView *next = [self superview]; next; next = next.superview) {
//        UIResponder *nextResponder = [next nextResponder];
//        if ([nextResponder isKindOfClass:[UIViewController class]]) {
//            return (UIViewController*)nextResponder;
//        }
//    }
//    return nil;
//}
//
//- (void)awakeFromNib {
//    UIImage *im = [[UIImage imageNamed:@"Play"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    UIImageView *ima = [[UIImageView alloc]initWithFrame:_sectionButton.bounds];
//    ima.image = im;
//    [self.sectionButton addSubview:ima];
//    
//    saveDictArray =[NSMutableArray array];
//}
//
//- (void)setIndexNum:(NSInteger)indexNum{
//    self.sectionTotalLabel.text = [NSString stringWithFormat:@"%d",indexNum];
//    self.sectionButton.tag = indexNum;
//}
//
//- (void)setSectionName:(NSString *)sectionName{
//    self.sectionTextLabel.text = sectionName;
//}
//
//-(void)saveDataToDictionary{
//    //saveDictArray 存放编辑好键值对
//    for (NSInteger i=0; i<_sectionIDArray.count; i++) {
//        saveDictionary = [NSMutableDictionary dictionary];
//        [saveDictionary addEntriesFromDictionary:@{@"arrayTag":@(0),@"CN":@(0),@"AN":@(0),@"EN":@(0)}];
//        if(![_sectionCNArray[i] isEqualToString:@""])
//            [saveDictionary addEntriesFromDictionary:@{@"arrayTag":@(i),@"CN":@(1)}];
//        if(![_sectionANArray[i] isEqualToString:@""])
//            [saveDictionary addEntriesFromDictionary:@{@"arrayTag":@(i),@"AN":@(1)}];
//        if(![_sectionENArray[i] isEqualToString:@""])
//            [saveDictionary addEntriesFromDictionary:@{@"arrayTag":@(i),@"EN":@(1)}];
//        [saveDictArray addObject:saveDictionary];
//    }
//}
//
////- (UIButton *)sectionButton{
////    if (!_sectionButton) {
////        CGFloat x = 0;
////        CGFloat y = 0;
////        CGFloat w = [UIScreen mainScreen].bounds.size.width;
////        CGFloat h = [UIScreen mainScreen].bounds.size.height;
////        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
////        button.frame = CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>);
////        [button setTitle:@"<#title#>" forState:UIControlStateNormal];//正常
////        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal]; // 字体颜色
////        
////        //        [button setTitle:@"<#title#>" forState:UIControlStateHighlighted];//高亮
////        //        [button.titleLabel setFont:[UIFont boldSystemFontOfSize:14]]; //定义按钮标题字体格式
////        //        [button addTarget:self action:@selector(<#action#>) forControlEvents:UIControlEventTouchUpInside]; // 绑定点击事件
////        //        button.showsTouchWhenHighlighted = YES; // 设置按钮按下会发光
////        //  button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//文字左对齐
////        //        button.contentEdgeInsets=UIEdgeInsetsMake(0,10,0,0); // 偏移
////        //        // 设置圆角边框
////        //        button.layer.masksToBounds = YES;
////        //        button.layer.cornerRadius = 5.0f;
////        //        button.layer.borderColor = [[UIColor grayColor] CGColor];
////        //        button.layer.borderWidth = 1.0f;
////        
////        _sectionButton = button;
////    }
////    return _sectionButton;
////}
//
//
//-(void)setClickOnTheButton:(NSInteger )ClickOnTheButton{
//    UIButton *a=[[UIButton alloc]init];
//    a.tag=ClickOnTheButton*10+1;
//    [self sectionButtonAction:a];
//}
//
//- (IBAction)sectionButtonAction:(UIButton *)sender {
//    saveTag = sender.tag; 
//    [self saveDataToDictionary];
//    NSInteger a = [[saveDictArray[saveTag-1] valueForKey:@"CN"] integerValue]==1 ? 1:0; //a=1点击这个有中文
//    NSInteger b = [[saveDictArray[saveTag-1] valueForKey:@"AN"] integerValue]==1 ? 1:0;
//    NSInteger c = [[saveDictArray[saveTag-1] valueForKey:@"EN"] integerValue]==1 ? 1:0;
//    
//    // 默认简体中文
//    switch ([DataModel defaultDataModel].setDefaultLanguage) {
//        case 0: // 默认中文
//            if (a) {
//                [self popWithArray:_sectionCNArray];
//            }else{
//                [self alertView:@[@(a),@(b),@(c)]];
//            }
//            break;
//        case 1: // 默认繁体
//            if (b) {
//                [self popWithArray:_sectionANArray];
//            }else{
//                [self alertView:@[@(a),@(b),@(c)]];
//            }
//            break;
//        case 2: // 默认英文
//            if (c) {
//                [self popWithArray:_sectionENArray];
//            }else{
//                [self alertView:@[@(a),@(b),@(c)]];
//            }
//            break;            
//    }
//}
//
//- (void)popWithArray:(NSArray *)array1{
//    [[TransferStationObject shareObject] IncomingDataLibraryName:_libraryName ClickCellNum:saveTag SectionName:_sectionNameArray SectionMp3:_sectionMp3Array SectionID:_sectionIDArray SectionText:array1 block:^(BOOL successful) {
//        if (successful) {
//            if ([self getCurrentVC]!=[PalyerViewController shareObject]) {
//                    [self.viewController.navigationController pushViewController: [PalyerViewController shareObject] animated:NO];
//            }
//
//        }else if([self getCurrentVC]!= [ReaderTableViewController shareObject]){
//            [self.viewController.navigationController pushViewController: [ReaderTableViewController shareObject] animated:NO];
//        }
//    }];
//}
//
////获取当前屏幕显示的viewcontroller
//- (UIViewController *)getCurrentVC {
//    UIViewController *result = nil;
//    
//    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
//    if (window.windowLevel != UIWindowLevelNormal){
//        NSArray *windows = [[UIApplication sharedApplication] windows];
//        for(UIWindow * tmpWin in windows){
//            if (tmpWin.windowLevel == UIWindowLevelNormal){
//                window = tmpWin;
//                break;
//            }
//        }
//    }
//    
//    UIView *frontView = [[window subviews] objectAtIndex:0];
//    id nextResponder = [frontView nextResponder];
//    
//    if ([nextResponder isKindOfClass:[UIViewController class]])
//        result = nextResponder;
//    else
//        result = window.rootViewController;
//    return result;
//}
//- (void)alertView:(NSArray *)parameter{
//    NSString *selectLangue;    if ([DataModel defaultDataModel].setDefaultLanguage==0) {
//        selectLangue = @"简体中文";
//    }else if ([DataModel defaultDataModel].setDefaultLanguage==1){
//        selectLangue = @"繁体中文";
//    }else{
//        selectLangue = @"English";
//    }
//    
//    NSString *aa = [NSString stringWithFormat:@"该文集没有%@版本,请重新选择语言!",selectLangue];
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"警  告" message:aa preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"简体中文" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [[TransferStationObject shareObject] IncomingDataLibraryName:self.libraryName ClickCellNum:saveTag SectionName:self.sectionNameArray SectionMp3:self.sectionMp3Array SectionID:self.sectionIDArray SectionText:self.sectionCNArray block:^(BOOL successful) {
//            if (successful) {
//                if ([self getCurrentVC]!=[PalyerViewController shareObject]) {
//                    [self.viewController.navigationController pushViewController: [PalyerViewController shareObject] animated:NO];
//                }
//                
//            }else if([self getCurrentVC]!= [ReaderTableViewController shareObject]){
//                [self.viewController.navigationController pushViewController: [ReaderTableViewController shareObject] animated:NO];
//            }
//        }];
//    }];
//    
//    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"繁体中文" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [[TransferStationObject shareObject] IncomingDataLibraryName:self.libraryName ClickCellNum:saveTag SectionName:self.sectionNameArray SectionMp3:self.sectionMp3Array SectionID:self.sectionIDArray SectionText:self.sectionANArray block:^(BOOL successful) {
//            if (successful) {
//                if ([self getCurrentVC]!=[PalyerViewController shareObject]) {
//                    [self.viewController.navigationController pushViewController: [PalyerViewController shareObject] animated:NO];
//                }
//                
//            }else if([self getCurrentVC]!= [ReaderTableViewController shareObject]){
//                [self.viewController.navigationController pushViewController: [ReaderTableViewController shareObject] animated:NO];
//            }        }];
//    }];
//    
//    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"English" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [[TransferStationObject shareObject] IncomingDataLibraryName:self.libraryName ClickCellNum:saveTag SectionName:self.sectionNameArray SectionMp3:self.sectionMp3Array SectionID:self.sectionIDArray SectionText:self.sectionENArray block:^(BOOL successful) {
//            if (successful) {
//                if ([self getCurrentVC]!=[PalyerViewController shareObject]) {
//                    [self.viewController.navigationController pushViewController: [PalyerViewController shareObject] animated:NO];
//                }
//                
//            }else if([self getCurrentVC]!= [ReaderTableViewController shareObject]){
//                [self.viewController.navigationController pushViewController: [ReaderTableViewController shareObject] animated:NO];
//            }
//        }];
//    }];
//    
//    NSString *a1 = [NSString stringWithFormat:@"%@",parameter[0]];
//    NSString *a2 = [NSString stringWithFormat:@"%@",parameter[1]];
//    NSString *a3 = [NSString stringWithFormat:@"%@",parameter[2]];
//    if ([a1 isEqualToString:@"1"]) {
//        [alertController addAction:action1];
//    }
//    if ([a2 isEqualToString:@"1"]) {
//        [alertController addAction:action2];
//    }
//    if ([a3 isEqualToString:@"1"]) {
//        [alertController addAction:action3];
//    }
//    
//    [self.viewController presentViewController:alertController animated:YES completion:NULL];
//}
//
//@end
