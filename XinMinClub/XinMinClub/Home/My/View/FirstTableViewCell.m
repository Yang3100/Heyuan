//
//  FirstTableViewCell.m
//  XinMinClub
//
//  Created by Jason_zzzz on 16/3/21.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "FirstTableViewCell.h"

@implementation FirstTableViewCell

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
    }
    return self;
}

- (IBAction)action:(id)sender {
    [_delegate sign];
}

@end
