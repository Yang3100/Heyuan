//
//  ICETutorialController.m
//  ICETutorial
//
//  Created by Patrick Trillsam on 25/03/13.
//  Copyright (c) 2014 https://github.com/icepat/ICETutorial. All rights reserved.
//

#import "ICETutorialController.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface ICETutorialController ()

@property (nonatomic, strong, readonly) UIImageView *frontLayerView;
@property (nonatomic, strong, readonly) UIImageView *backLayerView;
//@property (nonatomic, strong, readonly) UIImageView *gradientView;
@property (nonatomic, strong, readonly) UIScrollView *scrollView;
//@property (nonatomic, strong, readonly) UILabel *overlayTitle;
@property (nonatomic, strong, readonly) UIPageControl *pageControl;
@property (nonatomic, strong, readonly) UIButton *leftButton;
@property (nonatomic, strong, readonly) UIButton *rightButton;

@property (nonatomic, assign) ScrollingState currentState;
@property (nonatomic, strong) NSArray *pages;
@property (nonatomic, assign) NSInteger currentPageIndex;
@property (nonatomic, assign) NSInteger nextPageIndex;

@end

@implementation ICETutorialController

- (instancetype)initWithPages:(NSArray *)pages {
    if (self = [self init]) {
        _autoScrollEnabled = YES;
        _pages = pages;
        
        _frontLayerView = [[UIImageView alloc] init];
        _backLayerView = [[UIImageView alloc] init];
//        _gradientView = [[UIImageView alloc] init];
        _scrollView = [[UIScrollView alloc] init];
        
//        _overlayTitle = [[UILabel alloc] init];
        _pageControl = [[UIPageControl alloc] init];
        _leftButton = [[UIButton alloc] init];
        _rightButton = [[UIButton alloc] init];
    }
    return self;
}

- (instancetype)initWithPages:(NSArray *)pages delegate:(id<ICETutorialControllerDelegate>)delegate {
    if (self = [self initWithPages:pages]) {
        _delegate = delegate;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.view setBackgroundColor:[UIColor blackColor]];
    
    [self setupView];
    
    // Overlays.
    [self setOverlayTexts];
    [self setOverlayTitle];
    
    // Preset the origin state.
    [self setOriginLayersState];
}

- (void)setupView {
    [self.frontLayerView setFrame:self.view.bounds];
    [self.backLayerView setFrame:self.view.bounds];
    
    // Decoration.
//    [self.gradientView setImage:[UIImage imageNamed:@"background-gradient.png"]];
    
    // ScrollView configuration.
    [self.scrollView setFrame:self.view.bounds];
    [self.scrollView setDelegate:self];
    [self.scrollView setPagingEnabled:YES];
    [self.scrollView setContentSize:CGSizeMake([self numberOfPages] * self.view.frame.size.width,self.scrollView.contentSize.height)];
//    // Title.
//    [self.overlayTitle setTextColor:[UIColor whiteColor]];
//    self.overlayTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:32.0];
//    self.overlayTitle.textAlignment = NSTextAlignmentCenter;

    // PageControl configuration.
    self.pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:212/255.0 green:175/255.0 blue:116/255.0 alpha:1];
    self.pageControl.pageIndicatorTintColor = [UIColor colorWithRed:255/255.0 green:252/255.0 blue:235/255.0 alpha:1];
    [self.pageControl setNumberOfPages:[self numberOfPages]];
    [self.pageControl setCurrentPage:0];
    [self.pageControl addTarget:self action:@selector(didClickOnPageControl:) forControlEvents:UIControlEventValueChanged];
    
    // UIButtons.
//    [self.leftButton setBackgroundColor:[UIColor colorWithWhite:0.959 alpha:1]];
//    [self.rightButton setBackgroundColor:[UIColor colorWithWhite:0.959 alpha:1]];
//    [self.leftButton setTitle:@"登录" forState:UIControlStateNormal];
//    [self.rightButton setTitle:@"注册" forState:UIControlStateNormal];
//    [self.leftButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//    [self.rightButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.leftButton setImage:[UIImage imageNamed:@"登录"] forState:UIControlStateNormal];
    [self.rightButton setImage:[UIImage imageNamed:@"注册"] forState:UIControlStateNormal];
//    self.leftButton.layer.masksToBounds = YES;
//    self.rightButton.layer.masksToBounds = YES;
//    self.leftButton.layer.cornerRadius = 5.0;
//    self.rightButton.layer.cornerRadius = 5.0;
    [self.leftButton addTarget:self action:@selector(didClickOnLogon:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton addTarget:self action:@selector(didClickOnRegister:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:self.frontLayerView];
    [self.view addSubview:self.backLayerView];
//    [self.view addSubview:self.gradientView];
    [self.view addSubview:self.scrollView];
//    [self.view addSubview:self.overlayTitle];
    [self.view addSubview:self.pageControl];
    [self.view addSubview:self.leftButton];
    [self.view addSubview:self.rightButton];
    
    [self addAllConstraints];
}

#pragma mark - 界面布局(坐标和大小)
- (void)addAllConstraints {
    [self.frontLayerView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
	[self.backLayerView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    
//    self.overlayTitle.frame = CGRectMake(0, SCREEN_HEIGHT/3, SCREEN_WIDTH, 50);
    self.leftButton.frame = CGRectMake(20, SCREEN_HEIGHT - 56, SCREEN_WIDTH/2 - 30, 36);
    self.rightButton.frame = CGRectMake(SCREEN_WIDTH/2 + 10, SCREEN_HEIGHT - 56, SCREEN_WIDTH/2 - 30, 36);
    self.pageControl.frame = CGRectMake(0, SCREEN_HEIGHT-86, SCREEN_WIDTH, 20);
//    self.gradientView.frame = self.view.bounds;
//    self.gradientView.alpha = 0.8;
}
#pragma mark - Actions
- (IBAction)didClickOnLogon:(id)sender {
    if ([self.delegate respondsToSelector:@selector(tutorialController:didClickOnLeftButton:)]) {
        [self.delegate tutorialController:self didClickOnLeftButton:sender];
    }
}

- (IBAction)didClickOnRegister:(id)sender {
    if ([self.delegate respondsToSelector:@selector(tutorialController:didClickOnRightButton:)]) {
        [self.delegate tutorialController:self didClickOnRightButton:sender];
    }
}

- (IBAction)didClickOnPageControl:(UIPageControl *)sender {
    [self stopScrolling];

    // Make the scrollView animation.
    [self scrollToNextPageIndex:sender.currentPage];
}

#pragma mark - Pages
// Set the list of pages (ICETutorialPage).
- (void)setPages:(NSArray *)pages {
    _pages = pages;
}

- (NSUInteger)numberOfPages {
    if (self.pages) {
        return [self.pages count];
    }
    
    return 0;
}

#pragma mark - Animations
- (void)animateScrolling {
    if (self.currentState & ScrollingStateManual) {
        return;
    }
    
    // Jump to the next page...
    NSInteger nextPage = self.currentPageIndex + 1;
    if (nextPage == [self numberOfPages]) {
        // ...stop the auto-scrolling or...
        if (!self.autoScrollEnabled) {
            self.currentState = ScrollingStateManual;
            return;
        }
        
        // ...jump to the first page.
        nextPage = 0;
        self.currentState = ScrollingStateLooping;
        
        // Set alpha on layers.
        [self setOriginLayerAlpha];
        [self setBackLayerPictureWithPageIndex:-1];
    } else {
        self.currentState = ScrollingStateAuto;
    }
    
    // Make the scrollView animation.
    [self scrollToNextPageIndex:nextPage];
    
    // Call the next animation after X seconds.
    [self autoScrollToNextPage];
}

// Call the next animation after X seconds.
- (void)autoScrollToNextPage {
    ICETutorialPage *page = self.pages[self.currentPageIndex];

    if (self.autoScrollEnabled) {
        [self performSelector:@selector(animateScrolling) withObject:nil afterDelay:page.duration];
    }
}

- (void)scrollToNextPageIndex:(NSUInteger)nextPageIndex {
    // Make the scrollView animation.
    [self.scrollView setContentOffset:CGPointMake(nextPageIndex * self.view.frame.size.width,0)
                             animated:YES];

    // Set the PageControl on the right page.
    [self.pageControl setCurrentPage:nextPageIndex];
}

#pragma mark - Scrolling management
// Run it.
- (void)startScrolling {
    [self autoScrollToNextPage];
}

// Manually stop the scrolling
- (void)stopScrolling {
    self.currentState = ScrollingStateManual;
}

#pragma mark - State management
// State.
- (ScrollingState)getCurrentState {
    return self.currentState;
}

#pragma mark - Overlay management
// Setup the Title Label.
- (void)setOverlayTitle {
    // ...or change by an UIImageView if you need it.
//    [self.overlayTitle setText:@"和源"];
}

// Setup the Title/Subtitle style/text.
- (void)setOverlayTexts {
    int index = 0;    
    for (ICETutorialPage *page in self.pages) {
        // SubTitles.
        if ([[[page title] text] length]) {
            [self overlayLabelWithStyle:[page title] commonStyle:[[ICETutorialStyle sharedInstance] titleStyle] index:index];
        }
        // Description.
        if ([[[page subTitle] text] length]) {
            [self overlayLabelWithStyle:[page subTitle] commonStyle:[[ICETutorialStyle sharedInstance] subTitleStyle] index:index];
        }
        index++;
    }
}

- (void)overlayLabelWithStyle:(ICETutorialLabelStyle *)style commonStyle:(ICETutorialLabelStyle *)commonStyle  index:(NSUInteger)index {
    // SubTitles.
    UILabel *overlayLabel = [[UILabel alloc] initWithFrame:CGRectMake((index * self.view.frame.size.width), self.view.frame.size.height - [commonStyle offset], self.view.frame.size.width, TUTORIAL_LABEL_HEIGHT)];
    [overlayLabel setNumberOfLines:[commonStyle linesNumber]];
    [overlayLabel setBackgroundColor:[UIColor clearColor]];
    [overlayLabel setTextAlignment:NSTextAlignmentCenter];  

    // Datas and style.
    [overlayLabel setText:[style text]];
    [style font] ? [overlayLabel setFont:[style font]] : [overlayLabel setFont:[commonStyle font]];
    [style textColor] ? [overlayLabel setTextColor:[style textColor]] : [overlayLabel setTextColor:[commonStyle textColor]];
  
    [self.scrollView addSubview:overlayLabel];
}

#pragma mark - Layers management
// Handle the background layer image switch.
- (void)setBackLayerPictureWithPageIndex:(NSInteger)index {
    [self setBackgroundImage:self.backLayerView withIndex:index + 1];
}

// Handle the front layer image switch.
- (void)setFrontLayerPictureWithPageIndex:(NSInteger)index {
    [self setBackgroundImage:self.frontLayerView withIndex:index];
}

// Handle page image's loading
- (void)setBackgroundImage:(UIImageView *)imageView withIndex:(NSInteger)index {
    if (index >= [self.pages count]) {
        [imageView setImage:nil];
        return;
    } 
    
    [imageView setImage:[UIImage imageNamed:[self.pages[index] pictureName]]];
}

// Setup lapyer's alpha.
- (void)setOriginLayerAlpha {
    [self.frontLayerView setAlpha:1];
    [self.backLayerView setAlpha:0];
}

// Preset the origin state.
- (void)setOriginLayersState {
    self.currentState = ScrollingStateAuto;
    [self.backLayerView setBackgroundColor:[UIColor blackColor]];
    [self.frontLayerView setBackgroundColor:[UIColor blackColor]];
    [self setLayersPicturesWithIndex:0];
}

// Setup the layers with the page index.
- (void)setLayersPicturesWithIndex:(NSInteger)index {
    self.currentPageIndex = index;
    [self setOriginLayerAlpha];
    [self setFrontLayerPictureWithPageIndex:index];
    [self setBackLayerPictureWithPageIndex:index];
}

// Animate the fade-in/out (Cross-disolve) with the scrollView translation.
- (void)disolveBackgroundWithContentOffset:(float)offset {
    if (self.currentState & ScrollingStateLooping){
        // Jump from the last page to the first.
        [self scrollingToFirstPageWithOffset:offset];
    } else {
        // Or just scroll to the next/previous page.
        [self scrollingToNextPageWithOffset:offset];
    }
}

// Handle alpha on layers when the auto-scrolling is looping to the first page.
- (void)scrollingToFirstPageWithOffset:(float)offset {
    // Compute the scrolling percentage on all the page.
    offset = (offset * self.view.frame.size.width) / (self.view.frame.size.width * [self numberOfPages]);
    
    // Scrolling finished...
    if (!offset){
        // ...reset to the origin state.
        [self setOriginLayersState];
        return;
    }
    
    // Invert alpha for the back picture.
    float backLayerAlpha = (1 - offset);
    float frontLayerAlpha = offset;
    
    // Set alpha.
    [self.backLayerView setAlpha:backLayerAlpha];
    [self.frontLayerView setAlpha:frontLayerAlpha];
}

// Handle alpha on layers when we are scrolling to the next/previous page.
- (void)scrollingToNextPageWithOffset:(float)offset {
    // Current page index in scrolling.
    NSInteger nextPage = (int)offset;
    
    // Keep only the float value.
    float alphaValue = offset - nextPage;
    
    // This is only when you scroll to the right on the first page.
    // That will fade-in black the first picture.
    if (alphaValue < 0 && self.currentPageIndex == 0){
        [self.backLayerView setImage:nil];
        [self.frontLayerView setAlpha:(1 + alphaValue)];
        return;
    }
    
    // Switch pictures, and imageView alpha.
    if (nextPage != self.currentPageIndex ||
       ((nextPage == self.currentPageIndex) && (0.0 < offset) && (offset < 1.0)))
        [self setLayersPicturesWithIndex:nextPage];
    
    // Invert alpha for the front picture.
    float backLayerAlpha = alphaValue;
    float frontLayerAlpha = (1 - alphaValue);
    
    // Set alpha.
    [self.backLayerView setAlpha:backLayerAlpha];
    [self.frontLayerView setAlpha:frontLayerAlpha];
}

#pragma mark - ScrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Get scrolling position, and nextPageindex.
    float scrollingPosition = scrollView.contentOffset.x / self.view.frame.size.width;
    int nextPageIndex = (int)scrollingPosition;
    
    // If we are looping, we reset the indexPage.
    if (self.currentState & ScrollingStateLooping) {
        nextPageIndex = 0;
    }
    
    // If we are going to the next page, let's call the delegate.
    if (nextPageIndex != self.nextPageIndex) {
        if ([self.delegate respondsToSelector:@selector(tutorialController:scrollingFromPageIndex:toPageIndex:)]) {
            [self.delegate tutorialController:self scrollingFromPageIndex:self.currentPageIndex toPageIndex:nextPageIndex];
        }
        
        self.nextPageIndex = nextPageIndex;
    }
    
    // Delegate when we reach the end.
    if (self.nextPageIndex == [self numberOfPages] - 1) {
        if ([self.delegate respondsToSelector:@selector(tutorialControllerDidReachLastPage:)]) {
            [self.delegate tutorialControllerDidReachLastPage:self];
        }
    }

    // Animate.
    [self disolveBackgroundWithContentOffset:scrollingPosition];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    // At the first user interaction, we disable the auto scrolling.
    if (self.scrollView.isTracking) {
        [self stopScrolling];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // Update the page index.
    [self.pageControl setCurrentPage:self.currentPageIndex];
}

@end
