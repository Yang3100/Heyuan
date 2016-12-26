//
//  NSDictionary+Chinese.m
//  ObjCDemo
//
//  Created by Dragon Sun on 15/12/11.
//  Copyright © 2015年 Dragon Sun. All rights reserved.
//

#import "NSDictionary Chinese.h"

@implementation NSDictionary (Chinese)

- (NSString *)descriptionWithLocale:(nullable id)locale {
    NSMutableString *s = [NSMutableString string];
    
    // 遍历生成键值对字符串描述
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [s appendFormat:@"\n\t%@ = %@;", key, obj];
    }];
    
    // 去掉最后一个逗号
    if ([s hasSuffix:@","]) {
        [s deleteCharactersInRange:NSMakeRange(s.length - 1, 1)];
    }
    
    return [NSString stringWithFormat:@"{%@\n}", s];
}

@end
