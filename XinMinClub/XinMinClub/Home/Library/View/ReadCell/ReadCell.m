//
//  ReadCell.m
//  XinMinClub
//
//  Created by yangkejun on 16/3/30.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "ReadCell.h"

@interface ReadCell(){
    BOOL buttonStatus;
//    NSMutableArray *clickButtonTag;
//    NSMutableArray *deleteButtonTag;
//    int a;
}

@property (weak, nonatomic) IBOutlet UILabel *readTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *readTextLabel;
@property (weak, nonatomic) IBOutlet UIButton *readSpreadButton;

@end

@implementation ReadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
//    clickButtonTag = [NSMutableArray array];
//    deleteButtonTag = [NSMutableArray array];
//    a = 0;
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
    self.readTextLabel.textAlignment = NSTextAlignmentCenter;
    self.readTextLabel.text = [self getBook:readText];
}

- (void)setReadNum:(NSInteger)readNum{
    self.readSpreadButton.tag = readNum;
}

- (void)setJson:(NSDictionary *)json{

}

- (IBAction)spreadButton:(UIButton *)sender {
    buttonStatus = !buttonStatus;
}

-(NSString *)getBook:(NSString *)Book{
    // 分割歌词
    NSString *text=@"";
    NSArray *sepArray=[Book componentsSeparatedByString:@"["];
    NSArray *lineArray;
    for(int i=0;i<sepArray.count;i++){
        if([sepArray[i] length]>0){
            lineArray=[sepArray[i] componentsSeparatedByString:@"]"];
            if(![lineArray[0] isEqualToString:@"\n"]){
                text = [NSString stringWithFormat:@"%@%@",text,lineArray.count>1?lineArray[1]:@""];
            }
        }
    }
    return text;
}



@end

