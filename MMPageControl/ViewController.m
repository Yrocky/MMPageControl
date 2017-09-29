//
//  ViewController.m
//  MMPageControl
//
//  Created by user1 on 2017/8/10.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import "ViewController.h"
#import "MMPageControl.h"

@interface ViewController ()<UIScrollViewDelegate>

@property (nonatomic ,strong) MMPageControl * pageControl;
@property (nonatomic ,strong) UIScrollView * scrollView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    self.pageControl = [[MMPageControl alloc] init];
    self.pageControl.numberOfPages = 5;
    self.pageControl.indicatorMargin = 20;
    self.pageControl.indicatorDiameter = 40;
    self.pageControl.frame = CGRectMake(0, 100, screenWidth, 80);
    [self.view addSubview:self.pageControl];
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.frame = CGRectMake(0, CGRectGetMaxY(self.pageControl.frame) + 100, screenWidth, 200);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    for (NSInteger index = 0; index < self.pageControl.numberOfPages; index ++) {
        
        UIView * view = [UIView new];
        view.frame = CGRectMake(index * screenWidth, 0, screenWidth, self.scrollView.frame.size.height);
        UIColor * bgColor = [UIColor colorWithRed:drand48() green:drand48() blue:drand48() alpha:1.0];
        view.backgroundColor = bgColor;
        [self.scrollView addSubview:view];
    }
    self.scrollView.contentSize = CGSizeMake(self.pageControl.numberOfPages * screenWidth, self.scrollView.frame.size.height);
    [self.view addSubview:self.scrollView];
    
    UIStepper * step = [[UIStepper alloc] initWithFrame:CGRectMake(40, CGRectGetMaxY(self.scrollView.frame) + 40, 100, 40)];
    step.center = (CGPoint){
        CGRectGetMidX(self.scrollView.frame),
        CGRectGetMaxY(self.scrollView.frame) + 40
    };
    step.maximumValue = self.pageControl.numberOfPages - 1;
    step.minimumValue = 0;
    [step addTarget:self action:@selector(stepAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:step];
}

- (void) stepAction:(UIStepper *)step{
    
    [self.pageControl setProgress:step.value animated:YES];
}
#pragma mark - UIScrollViewDelegate M

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    CGFloat total = scrollView.contentSize.width - scrollView.bounds.size.width;
    CGFloat offset = scrollView.contentOffset.x;
    CGFloat percent = offset / total;
    
    CGFloat progress = percent * (self.pageControl.numberOfPages - 1);
    
    self.pageControl.progress = progress;
}
@end
