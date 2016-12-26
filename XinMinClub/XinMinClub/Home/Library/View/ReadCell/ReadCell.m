//
//  ReadCell.m
//  XinMinClub
//
//  Created by yangkejun on 16/3/30.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "ReadCell.h"
#import "ReadTableView.h"

@interface ReadCell(){
    BOOL buttonStatus;
    NSMutableArray *clickButtonTag;
    NSMutableArray *deleteButtonTag;
    int a;
}

@property (weak, nonatomic) IBOutlet UILabel *readTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *readPlayButton;
@property (weak, nonatomic) IBOutlet UIButton *readSpreadButton;
@property (weak, nonatomic) IBOutlet UILabel *readTextLabel;

@end

@implementation ReadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    clickButtonTag = [NSMutableArray array];
    deleteButtonTag = [NSMutableArray array];
    a = 0;
    buttonStatus=NO;
}

-(void)setState:(BOOL)state{
    if (state)
        [self.readSpreadButton setTitle:@"收起>" forState:UIControlStateNormal];
    else
        [self.readSpreadButton setTitle:@"展开<" forState:UIControlStateNormal];
}
- (void)setReadTitle:(NSString *)readTitle{
    self.readTitleLabel.text = readTitle;
}

- (void)setReadText:(NSString *)readText{
    self.readTextLabel.text = readText;
}

- (void)setReadNum:(NSInteger)readNum{
    self.readSpreadButton.tag = readNum;
}

- (IBAction)playButtonAction:(UIButton *)sender {
    NSLog(@"点击了播放");
//    self.readMp3

}

- (IBAction)spreadButton:(UIButton *)sender {
    if (buttonStatus == NO) {
        buttonStatus=YES;
        self.infoDic = @{@"buttonTag":@(sender.tag)};
        //创建一个消息对象
        NSNotification * notice = [NSNotification notificationWithName:@"spread" object:nil userInfo:_infoDic];
        //发送消息
        [[NSNotificationCenter defaultCenter]postNotification:notice];
    }
    else if(buttonStatus == YES){
        buttonStatus=NO;
        self.infoDic = @{@"buttonTag":@(sender.tag)};
        //创建一个消息对象
        NSNotification * notice = [NSNotification notificationWithName:@"spreadNo" object:nil userInfo:_infoDic];
        // 发送消息
        [[NSNotificationCenter defaultCenter] postNotification:notice];
    }
}

@end

