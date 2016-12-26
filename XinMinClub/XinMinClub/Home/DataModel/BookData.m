//
//  BookData.m
//  XinMinClub
//
//  Created by 赵劲松 on 16/4/25.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "BookData.h"

#define KEY_BOOKNAME (@"bookName")
#define KEY_BOOKID (@"bookID")
#define KEY_BOOKIMAGE (@"bookImage")
#define KEY_AUTHORNAME (@"authorName")

@interface BookData () <NSCoding>

@end

@implementation BookData

- (id)init {
    if (self = [super init]) {
        [self initData];
    }
    return self;
}

- (void)initData {
    _sections = [NSMutableArray array];
}

- (id)initWithDic:(NSDictionary *)dic {
    BookData *bookData = [[BookData alloc] init];
    bookData.bookName = dic[@"bookName"];
    bookData.bookID = dic[@"bookID"];
    bookData.bookImage = dic[@"bookImage"];
    bookData.authorName = dic[@"authorName"];
    bookData.imagePath = dic[@"imagePath"];
    bookData.type = dic[@"libraryType"];
    bookData.language = dic[@"libraryLanguage"];
    bookData.details = dic[@"libraryDetails"];
    bookData.firstLevelList = dic[@"firstLevelList"];
    bookData.firstLevelListWithSecondLevelList = dic[@"firstLevelListWithSecondLevelList"];
    return bookData;
}

#pragma mark NSCoding

// userDefault存储的编码解码
- (void)encodeWithCoder:(NSCoder*)coder
{
    [coder encodeObject:_bookName forKey:KEY_BOOKNAME];
    [coder encodeObject:_bookID forKey:KEY_BOOKID];
    [coder encodeObject:_bookImage forKey:KEY_BOOKIMAGE];
    [coder encodeObject:_authorName forKey:KEY_AUTHORNAME];
}

- (id)initWithCoder:(NSCoder*)decoder
{
    if (self = [super init])
    {
        if (decoder == nil)
        {
            return self;
        }
        _bookName = [decoder decodeObjectForKey:KEY_BOOKNAME];
        _bookID = [decoder decodeObjectForKey:KEY_BOOKID];
        _bookImage = [decoder decodeObjectForKey:KEY_BOOKIMAGE];
        _authorName = [decoder decodeObjectForKey:KEY_AUTHORNAME];
    }
    return self;
}

@end
