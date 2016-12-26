//
//  NSSet+Chinese.m
//  ObjCDemo
//
//  Created by Dragon Sun on 15/12/11.
//  Copyright © 2015年 Dragon Sun. All rights reserved.
//

#import "NSSet Chinese.h"

@implementation NSSet (Chinese)

- (NSString *)descriptionWithLocale:(nullable id)locale {
    NSMutableString *s = [NSMutableString string];
    
    // 遍历生成键值对字符串描述
    [self enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        [s appendFormat:@"\n\t%@,", obj];
    }];
    
    // 去掉最后一个逗号
    if ([s hasSuffix:@","]) {
        [s deleteCharactersInRange:NSMakeRange(s.length - 1, 1)];
    }
    
    return [NSString stringWithFormat:@"{(%@\n)}", s];
}

@end
