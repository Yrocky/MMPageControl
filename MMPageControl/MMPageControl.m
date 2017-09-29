//
//  MMPageControl.m
//  MMPageControl
//
//  Created by user1 on 2017/8/10.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import "MMPageControl.h"
#import "MMIndicatorLayer.h"

@interface MMPageControl (Update)

- (void) updateNumberOfPages:(NSInteger)numberOfPges;

- (void) updateForProgress:(CGFloat)progesss;

- (void) updateFrame;
@end

@interface MMPageControl ()

@property (nonatomic) CGFloat moveToProgress;

@property (nonatomic ,strong) CADisplayLink * displayLink;

@property (nonatomic ,strong) MMBgIndicatorLayer * indicatorBackgroundLayer;
@property (nonatomic ,strong) MMIndicatorContentLayer * bottomIndicatorContentLayer;
@property (nonatomic ,strong) MMIndicatorContentLayer * topIndicatorContentLayer;
@property (nonatomic ,strong) MMIndicatorLayer * indicatorActiveLayer;

@property (nonatomic ,assign) CGRect activeLayerFrame;
@end

@implementation MMPageControl

#pragma mark - System M

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupDisplayLink];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupDisplayLink];
    }
    return self;
}

- (void) setupDisplayLink{

    self.backgroundColor = [UIColor colorWithHexString:@"#273A58"];
    
    //
    self.indicatorDiameter = 20;
    self.indicatorMargin = 10;
    
    //
    self.activeTintColor = [UIColor colorWithHexString:@"#42C36D"];
    self.inactiveTintColor = [UIColor colorWithHexString:@"#D0EFDB"];
    
    //
    self.activeTextColor = [UIColor colorWithHexString:@"#D0EFDB"];
    self.inactiveTextColor = [UIColor colorWithHexString:@"#6E819B"];
    
    //
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateFrame)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
    // bg
    self.indicatorBackgroundLayer = [MMBgIndicatorLayer layer];
    self.indicatorBackgroundLayer.indicatorColor = self.inactiveTintColor;
    [self.layer addSublayer:self.indicatorBackgroundLayer];
    
    //
    self.bottomIndicatorContentLayer = [MMIndicatorContentLayer layer];
    self.bottomIndicatorContentLayer.indicatorColor = self.inactiveTextColor;
    [self.layer addSublayer:self.bottomIndicatorContentLayer];
    
    //
    self.topIndicatorContentLayer = [MMIndicatorContentLayer layer];
    self.topIndicatorContentLayer.indicatorColor = self.activeTextColor;
    self.topIndicatorContentLayer.backgroundColor = self.activeTintColor.CGColor;
    [self.layer addSublayer:self.topIndicatorContentLayer];
    
    // active
    self.indicatorActiveLayer = [MMIndicatorLayer layer];
}

#pragma mark - API M

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated{
    
    if (progress >= 0 || progress <= self.numberOfPages - 1) {
        if (!animated) {
            self.moveToProgress = progress;
        }else{
            self.progress = progress;
        }
    }
}

#pragma mark - Override M

- (void)layoutSubviews{

    [super layoutSubviews];
    
    __block CGRect frame = (CGRect){
        (self.frame.size.width - self.numberOfPages * self.indicatorDiameter - (self.numberOfPages - 1) * self.indicatorMargin) / 2,
        (self.frame.size.height - self.indicatorDiameter) / 2,
        self.indicatorDiameter,
        self.indicatorDiameter
    };
    
    self.activeLayerFrame = (CGRect){
        CGPointZero,
        frame.size
    };

    frame.size.width = self.intrinsicContentSize.width;
    
    UIBezierPath * path = [UIBezierPath bezierPathWithOvalInRect:self.activeLayerFrame];
    
    //
    self.indicatorActiveLayer.indicatorColor = self.activeTintColor;
    self.indicatorActiveLayer.path = path.CGPath;
    self.indicatorActiveLayer.hidden = NO;
    
    //
    self.indicatorBackgroundLayer.numberOfPages = self.numberOfPages;
    self.indicatorBackgroundLayer.margin = self.indicatorMargin;
    self.indicatorBackgroundLayer.frame = frame;
    
    //
    self.topIndicatorContentLayer.frame = frame;
    self.bottomIndicatorContentLayer.frame = frame;
    
    [self updateForProgress:self.progress];
}

- (void)setTintColor:(UIColor *)tintColor{
    
    [super setTintColor:tintColor];
    [self setNeedsLayout];
}

- (CGSize) intrinsicContentSize{

    return [self sizeThatFits:CGSizeZero];
}

- (CGSize) sizeThatFits:(CGSize)size{

    return (CGSize){
        self.numberOfPages * self.indicatorDiameter + (self.numberOfPages - 1) * self.indicatorMargin,
        self.indicatorDiameter
    };
}

#pragma mark - Setter M

- (void)setNumberOfPages:(NSInteger)numberOfPages{
    if (numberOfPages) {
        _numberOfPages = numberOfPages;
        [self updateNumberOfPages:numberOfPages];
        self.hidden = self.hidesForSinglePage && (numberOfPages <= 1);
    }
}

- (void)setHidesForSinglePage:(BOOL)hidesForSinglePage{

    _hidesForSinglePage = hidesForSinglePage;
    [self setNeedsLayout];
}

- (void)setProgress:(CGFloat)progress{

    _progress = progress;
    [self updateForProgress:progress];
}

- (void)setInactiveTintColor:(UIColor *)inactiveTintColor{

    _inactiveTintColor = inactiveTintColor;
    self.indicatorBackgroundLayer.indicatorColor = inactiveTintColor;
    [self setNeedsLayout];
}

- (void)setActiveTintColor:(UIColor *)activeTintColor{

    _activeTintColor = activeTintColor;
    self.topIndicatorContentLayer.backgroundColor = activeTintColor.CGColor;
    [self setNeedsLayout];
}

- (void)setInactiveTextColor:(UIColor *)inactiveTextColor{
    
    _inactiveTextColor = inactiveTextColor;
    self.bottomIndicatorContentLayer.indicatorColor = inactiveTextColor;
}

- (void)setActiveTextColor:(UIColor *)activeTextColor{
    
    _activeTextColor = activeTextColor;
    self.topIndicatorContentLayer.indicatorColor = activeTextColor;
}

- (void)setIndicatorMargin:(CGFloat)indicatorMargin{

    _indicatorMargin = indicatorMargin;
    self.topIndicatorContentLayer.indicatorMargin = indicatorMargin;
    self.bottomIndicatorContentLayer.indicatorMargin = indicatorMargin;
    [self setNeedsLayout];
}

- (void)setIndicatorDiameter:(CGFloat)indicatorDiameter{

    _indicatorDiameter = indicatorDiameter;
    self.topIndicatorContentLayer.indicatorDiameter = indicatorDiameter;
    self.bottomIndicatorContentLayer.indicatorDiameter = indicatorDiameter;
    [self setNeedsLayout];
}

#pragma mark - Getter M

- (NSInteger)currentPageIndex{

    return (NSInteger)self.progress;
}

@end

@implementation MMPageControl (Update)

- (void)updateNumberOfPages:(NSInteger)numberOfPges{

    if (numberOfPges < 1) {
        return;
    }
    //
    [self.topIndicatorContentLayer clearAllIndicator];
    [self.bottomIndicatorContentLayer clearAllIndicator];
    
    for (NSUInteger index = 0; index < numberOfPges; index ++) {
        NSString * text = [NSString stringWithFormat:@"%ld",index + 1];
        [self.topIndicatorContentLayer addIndicator:text];
        [self.bottomIndicatorContentLayer addIndicator:text];
    }
    
    self.topIndicatorContentLayer.mask = self.indicatorActiveLayer;
    
    [self setNeedsLayout];
    [self invalidateIntrinsicContentSize];
}

- (void) updateForProgress:(CGFloat)progress{

    if (self.numberOfPages > 1 &&
        progress >= 0 &&
        progress <= self.numberOfPages - 1) {
        
        NSInteger total = self.numberOfPages - 1;
        CGFloat dist = (self.numberOfPages - 1) * (self.indicatorDiameter +  self.indicatorMargin);
        CGFloat percent = progress / total;
        CGFloat offset = dist * percent;
        CGRect frame = self.activeLayerFrame;
        frame.origin.x = offset;
//        NSLog(@"offset:%f\nprogress:%f",offset,progress);
        
        dist = self.indicatorDiameter * (self.currentPageIndex + 1) + self.currentPageIndex * self.indicatorMargin;
//        NSLog(@"dist:%f",dist);
        NSLog(@"frame:%@",NSStringFromCGRect(frame));
        
        __block UIBezierPath * path = [UIBezierPath bezierPathWithOvalInRect:(CGRect){frame.origin,frame.size}];
        self.indicatorActiveLayer.path = path.CGPath;
    }
}

- (void) updateFrame{
    [self animation];
}

- (void) animation{

    if (self.moveToProgress != NSNotFound) {
        
        CGFloat a = fabs(self.moveToProgress);
        CGFloat b = fabs(self.progress);
        
        if (a > b) {
            self.progress += 0.1;
        }
        if (a < b) {
            self.progress -= 0.1;
        }
        if (a== b) {
            self.progress = self.moveToProgress;
            self.moveToProgress = NSNotFound;
        }
        
        // 边际判断，负数
        if (self.progress < 0) {
            self.progress = 0;
            self.moveToProgress = NSNotFound;
        }
        
        // 边际判断，大于最大指示数
        if (self.progress > self.numberOfPages - 1) {
            self.progress = self.numberOfPages - 1;
            self.moveToProgress = NSNotFound;
        }
    }
}
@end
