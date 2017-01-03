//
//  NineNine.m
//
//
//  Created by 杨科军 on 2016/10/31.
//
//

#import "NineNine.h"
#import "BookViewController.h"

@interface NineNine(){
    float kj_width;
    float kj_height;
    float kj_x;
    float kj_y;
    NSDictionary *kj_dict;
    NSArray *rushidaoArr;
    NSArray *ruName;
    NSArray *shiName;
    NSArray *daoName;
    NSArray *ruArr;
    NSArray *shiArr;
    NSArray *daoArr;
    
    NSMutableDictionary *but_dict;
    NSMutableDictionary *but_dict2;
}

@property(nonatomic) int touchTag;
@property(nonatomic, readonly) UIViewController *viewController;

@end

@implementation NineNine

//  获取当前view所处的viewController重写读方法
- (UIViewController *)viewController{
    for (UIView *next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            // 上面if判断是否为UIViewController的子类
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

- (id)initWithSize:(CGRect)frame Interior:(NSDictionary*)dict{
    if(self == [super initWithFrame:frame]){
        self.backgroundColor = [UIColor whiteColor];
        self.touchTag = 2;
        
        kj_x = self.bounds.origin.x;
        kj_y = self.bounds.origin.y;
        kj_width = self.bounds.size.width;
        kj_height = self.bounds.size.height;
        kj_dict = dict;
        
        but_dict = [NSMutableDictionary dictionary];
        but_dict2 = [NSMutableDictionary dictionary];
        
        [self falseData];
        
        [self fenlan];
        [self buildView];
    }
    return self;
}

- (void)falseData{
    rushidaoArr = @[@"儒",@"释",@"道"];
    ruName  = @[@"雅赏",@"逸经",@"宿儒",@"弘毅",@"至诚",@"青囊",@"慎独",@"乐水",@"诗礼"];
    shiName = @[@"禅悦",@"菩提",@"般若",@"自在",@"缘觉",@"悬壶",@"定慧",@"梵行",@"止观"];
    daoName = @[@"心斋",@"轩箓",@"无为",@"抱朴",@"静笃",@"岐黄",@"玉虚",@"一炁",@"玄霄"];
    
    ruArr = @[[UIImage imageNamed:@"雅赏.jpg"],
              [UIImage imageNamed:@"逸經.jpg"],
              [UIImage imageNamed:@"宿儒.jpg"],
              [UIImage imageNamed:@"弘毅.jpg"],
              [UIImage imageNamed:@"至诚.jpg"],
              [UIImage imageNamed:@"青囊.JPG"],
              [UIImage imageNamed:@"慎独.jpg"],
              [UIImage imageNamed:@"乐水.jpg"],
              [UIImage imageNamed:@"詩禮.jpg"]
              ];
    
    shiArr = @[[UIImage imageNamed:@"禪悅.jpg"],
               [UIImage imageNamed:@"菩提.jpg"],
               [UIImage imageNamed:@"般若.jpg"],
               [UIImage imageNamed:@"自在.jpg"],
               [UIImage imageNamed:@"緣覺.jpg"],
               [UIImage imageNamed:@"悬壶.jpg"],
               [UIImage imageNamed:@"定慧.jpg"],
               [UIImage imageNamed:@"梵行.jpg"],
               [UIImage imageNamed:@"止觀.jpg"]
               ];
    
    daoArr = @[[UIImage imageNamed:@"心斋.jpg"],
               [UIImage imageNamed:@"轩箓.JPG"],
               [UIImage imageNamed:@"无为.jpg"],
               [UIImage imageNamed:@"抱朴.jpg"],
               [UIImage imageNamed:@"静笃.jpg"],
               [UIImage imageNamed:@"岐黃.jpg"],
               [UIImage imageNamed:@"玉虛.jpg"],
               [UIImage imageNamed:@"一炁.jpg"],
               [UIImage imageNamed:@"玄霄.jpg"]
               ];
}

- (void)fenlan{
    UIButton *button;
    CGFloat Nwidth = (int)kj_width / 3;
    //    NSArray *dataArr = @[@"儒",@"释",@"道"];
    for (int i = 0; i<3; i++) {
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat bx = Nwidth*i;
        button.frame = CGRectMake(bx, kj_y, Nwidth, Nwidth/3.5);
        [button setTitleColor:RGB255_COLOR(1, 0, 0, 1) forState:UIControlStateNormal];
        if (i==1) {
            [button setTitleColor:RGB255_COLOR(219, 145, 39, 1) forState:UIControlStateNormal];
        }
        [button setTitle:rushidaoArr[i] forState:UIControlStateNormal];
        button.tag=i;
        [self aaa:button butTag:button.tag];
        button.backgroundColor = RGB255_COLOR(238, 238, 238, 1);
        button.showsTouchWhenHighlighted=NO;
        [button addTarget:self action:@selector(butClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
}

- (void)aaa:(UIButton*)but butTag:(NSInteger)butag{
    NSString *s = [NSString stringWithFormat:@"%ld",(long)butag];
    [but_dict2 addEntriesFromDictionary:@{s:but}];
}

- (IBAction)butClick:(UIButton*)sender{
    if (sender.tag==0) {
        self.touchTag=1;
        [[but_dict2 valueForKey:[NSString stringWithFormat:@"%d",0]] setTitleColor:RGB255_COLOR(219, 145, 39, 1) forState:UIControlStateNormal];
        [[but_dict2 valueForKey:[NSString stringWithFormat:@"%d",1]] setTitleColor:RGB255_COLOR(1, 0, 0, 1) forState:UIControlStateNormal];
        [[but_dict2 valueForKey:[NSString stringWithFormat:@"%d",2]] setTitleColor:RGB255_COLOR(1, 0, 0, 1) forState:UIControlStateNormal];
        [self kkkaa:1];
    }
    else if (sender.tag == 1){
        self.touchTag=2;
        [[but_dict2 valueForKey:[NSString stringWithFormat:@"%d",0]] setTitleColor:RGB255_COLOR(1, 0, 0, 1) forState:UIControlStateNormal];
        [[but_dict2 valueForKey:[NSString stringWithFormat:@"%d",1]] setTitleColor:RGB255_COLOR(219, 145, 39, 1) forState:UIControlStateNormal];
        [[but_dict2 valueForKey:[NSString stringWithFormat:@"%d",2]] setTitleColor:RGB255_COLOR(1, 0, 0, 1) forState:UIControlStateNormal];
        [self kkkaa:2];
    }
    else{
        self.touchTag=3;
        [[but_dict2 valueForKey:[NSString stringWithFormat:@"%d",0]] setTitleColor:RGB255_COLOR(1, 0, 0, 1) forState:UIControlStateNormal];
        [[but_dict2 valueForKey:[NSString stringWithFormat:@"%d",1]] setTitleColor:RGB255_COLOR(1, 0, 0, 1) forState:UIControlStateNormal];
        [[but_dict2 valueForKey:[NSString stringWithFormat:@"%d",2]] setTitleColor:RGB255_COLOR(219, 145, 39, 1) forState:UIControlStateNormal];
        [self kkkaa:3];
    }
}

- (void)buildView{
    UIButton *button;
    CGFloat space = 20;
    CGFloat Nwidth = ((int)kj_width-4*space)/3;
    CGFloat space_height = (kj_height - (int)kj_width/12 - 3*Nwidth)/4;
    int k=0;
    for (int x = 0; x < 3; x++) {
        for (int y = 0; y < 3; y++) {
            k++;
            button = [UIButton buttonWithType:UIButtonTypeCustom];
            CGFloat bx = (space+Nwidth)*y+space;
            CGFloat by = (space_height+Nwidth)*x+space_height+kj_y+(int)kj_width/12;
            button.frame = CGRectMake(bx, by, Nwidth, Nwidth);
            button.backgroundColor = [UIColor greenColor];
            [button setImage:shiArr[k-1] forState:UIControlStateNormal];
            button.tag = k-1;
            
            [self xxx:button butTag:button.tag];
            
            [button addTarget:self action:@selector(butNineClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
        }
    }
}

- (void)xxx:(UIButton*)but butTag:(NSInteger)butag{
    NSString *s = [NSString stringWithFormat:@"%ld",(long)butag];
    [but_dict addEntriesFromDictionary:@{s:but}];
}

- (void)kkkaa:(int)a{
    NSArray *arr;
    if (a==1) {
        arr = ruArr;
    }
    else if (a==2){
        arr = shiArr;
    }
    else
        arr = daoArr;
    
    for (int i = 0; i<9; i++) {
        [[but_dict valueForKey:[NSString stringWithFormat:@"%d",i]] setImage:arr[i] forState:UIControlStateNormal];
    }
}


- (IBAction)butNineClick:(UIButton*)sender{
    NSString *title22;
    NSArray *typeArrayaa;
    if (self.touchTag==1) {
        title22 = ruName[sender.tag];
        typeArrayaa = ruName;
    }else if (self.touchTag==2){
        title22 = shiName[sender.tag];
        typeArrayaa = shiName;
    }else{
        title22 = daoName[sender.tag];
        typeArrayaa = daoName;
    }
    
    [BookViewController shareObject].rushidaoName = rushidaoArr[_touchTag-1];
    [BookViewController shareObject].typeName = title22;
    [BookViewController shareObject].typeArray = typeArrayaa;
    [BookViewController shareObject].isRemoveArray = YES;
    [[BookViewController shareObject] startGetDataWithType:title22 touchNum:sender.tag];
    [BookViewController shareObject].title = [NSString stringWithFormat:@"%@--%@",rushidaoArr[_touchTag-1],title22];
    [self.viewController.navigationController pushViewController:[BookViewController shareObject] animated:NO];
}

@end
