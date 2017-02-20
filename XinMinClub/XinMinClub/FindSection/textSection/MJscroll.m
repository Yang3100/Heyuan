//
//  MJscroll.m
//  course
//
//  Created by 杨科军 on 2016/11/23.
//  Copyright © 2016年 杨科军. All rights reserved.
//

#import "MJscroll.h"

@interface MJscroll () <UIScrollViewDelegate>

@property (nonatomic) CGRect currentRect;
@property (nonatomic, strong)  UIScrollView *mainSv;
@property (nonatomic) NSUInteger index;

@end


@implementation MJscroll

//便利构造器
+ (void)initWithSourceArray:(NSArray *)picArray addTarget:(id)controller delegate:(id)delegate withSize:(CGRect)frame{
    MJscroll *new = [[MJscroll alloc]initWithFrame:frame];
    new.currentRect = frame;
    new.sourceArray = picArray;
    new.delegate = delegate;
    if ([controller isKindOfClass:[UIView class]]) {
        [controller addSubview:new];
    }
    else if ([controller isKindOfClass:[UIViewController class]]){
        UIViewController *view = controller;
        [view.view addSubview:new];
    }
    [new setImage:picArray];
}
+ (void)initWithUrlArray:(NSArray *)urlArray addTarget:(UIViewController *)controller delegate:(id)delegate withSize:(CGRect)frame{
    MJscroll *new = [[MJscroll alloc]initWithFrame:frame];
    new.currentRect = frame;
    new.sourceArray = urlArray;
    new.delegate = delegate;
    [controller.view addSubview:new];
}

//重写初始化方法
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.currentRect = frame;
        [self initScrollView];
        [self initImageView];
    }
    return self;
}

//初始化主滑动视图
-(void)initScrollView{
    self.mainSv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.currentRect.size.width, self.currentRect.size.height)];
    self.mainSv.layer.masksToBounds = YES;
    self.mainSv.layer.cornerRadius = 2.0;
    self.mainSv.backgroundColor = [UIColor redColor];
    self.mainSv.bounces = NO;
    self.mainSv.showsHorizontalScrollIndicator = NO;
    self.mainSv.showsVerticalScrollIndicator = NO;
    self.mainSv.pagingEnabled = YES;
    self.mainSv.contentSize = CGSizeMake(self.currentRect.size.width * 3, self.currentRect.size.height);
    self.mainSv.delegate = self;
    [self.mainSv setContentOffset:CGPointMake(self.currentRect.size.width, 0)];
    [self addSubview:self.mainSv];
}

//初始化imageview
-(void)initImageView{
    CGFloat width = 0;
    for (int a = 0; a < 3; a++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(width, 0, self.currentRect.size.width, self.currentRect.size.height)];
        imageView.userInteractionEnabled = YES;
        imageView.backgroundColor = [UIColor whiteColor];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.tag = a + 1;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgActive:)];
        [imageView addGestureRecognizer:tap];
        [self.mainSv addSubview:imageView];
        width += self.currentRect.size.width;
    }
}
//点击图片的回调
-(void)imgActive:(id)sender{
    [self.delegate MJscrollImage:self didSelectedIndex:self.index];
}

//首次初始化图片
-(void)setImage:(NSArray *)sourceList{
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:sourceList];
    UIImageView *indexViewOne = (UIImageView *)[self.mainSv viewWithTag:1];
    UIImageView *indexViewTwo = (UIImageView *)[self.mainSv viewWithTag:2];
    UIImageView *indexViewThree = (UIImageView *)[self.mainSv viewWithTag:3];
    self.index = 0;
    for (id obj in tempArray) {
        if (![obj isKindOfClass:[UIImage class]]) {
            [tempArray removeObject:obj];
        }
    }
    
    if (tempArray.count > 0) {
        if (sourceList.count == 1){
            [tempArray addObject:[tempArray objectAtIndex:0]];
            [tempArray addObject:[tempArray objectAtIndex:0]];
            indexViewOne.image = [tempArray objectAtIndex:0];
            indexViewTwo.image = [tempArray objectAtIndex:0];
            indexViewThree.image = [tempArray objectAtIndex:0];
        }else if (sourceList.count == 2){
            [tempArray addObject:[tempArray objectAtIndex:0]];
            indexViewOne.image = [tempArray objectAtIndex:1];
            indexViewTwo.image = [tempArray objectAtIndex:0];
            indexViewThree.image = [tempArray objectAtIndex:1];
        }else{
            indexViewOne.image = [tempArray objectAtIndex:tempArray.count - 1];
            indexViewTwo.image = [tempArray objectAtIndex:0];
            indexViewThree.image = [tempArray objectAtIndex:1];
        }
        self.sourceArray = tempArray;
    }else{
        NSLog(@"数据源错误，设置图片失败");
    }
}

//设置图片
-(void)setPicWithIndex:(NSUInteger)index withImage:(UIImage *)img{
    UIImageView *indexView = (UIImageView *)[self.mainSv viewWithTag:index];
    indexView.image = img;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.mainSv) {
        //三个图uiimageview交替部分
        if (self.mainSv.contentOffset.x == 0) {
            if (self.index == 0) {
                self.index = self.sourceArray.count - 1;
                [self setPicWithIndex:2 withImage:[self.sourceArray objectAtIndex:self.index]];
                [self.mainSv setContentOffset:CGPointMake(self.currentRect.size.width, 0)];
                [self setPicWithIndex:1 withImage:[self.sourceArray objectAtIndex:self.index - 1]];
                [self setPicWithIndex:3 withImage:[self.sourceArray objectAtIndex:0]];
            }else{
                self.index --;
                [self setPicWithIndex:2 withImage:[self.sourceArray objectAtIndex:self.index]];
                [self.mainSv setContentOffset:CGPointMake(self.currentRect.size.width, 0)];
                if (self.index == 0) {
                    [self setPicWithIndex:1 withImage:[self.sourceArray objectAtIndex:self.sourceArray.count - 1]];
                }else{
                    [self setPicWithIndex:1 withImage:[self.sourceArray objectAtIndex:self.index - 1]];
                }
                [self setPicWithIndex:3 withImage:[self.sourceArray objectAtIndex:self.index + 1]];
            }
        }else if (self.mainSv.contentOffset.x == self.currentRect.size.width * 2){
            if (self.index == self.sourceArray.count - 1) {
                self.index = 0;
                [self setPicWithIndex:2 withImage:[self.sourceArray objectAtIndex:self.index]];
                [self.mainSv setContentOffset:CGPointMake(self.currentRect.size.width, 0)];
                [self setPicWithIndex:1 withImage:[self.sourceArray objectAtIndex:self.sourceArray.count - 1]];
                [self setPicWithIndex:3 withImage:[self.sourceArray objectAtIndex:self.index + 1]];
            }else{
                self.index ++;
                [self setPicWithIndex:2 withImage:[self.sourceArray objectAtIndex:self.index]];
                [self.mainSv setContentOffset:CGPointMake(self.currentRect.size.width, 0)];
                [self setPicWithIndex:1 withImage:[self.sourceArray objectAtIndex:self.index - 1]];
                if (self.index == self.sourceArray.count - 1) {
                    [self setPicWithIndex:3 withImage:[self.sourceArray objectAtIndex:0]];
                }else{
                    [self setPicWithIndex:3 withImage:[self.sourceArray objectAtIndex:self.index + 1]];
                }
            }
        }
    }
}


@end
