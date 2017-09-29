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

@property (nonatomic ,strong) NSMutableArray <MMTextIndicatorLayer *>* indicatorInactiveLayers;

@property (nonatomic ,strong) MMTextIndicatorLayer * indicatorActiveLayer;
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

    self.backgroundColor = [UIColor colorWithRed:0.15 green:0.23 blue:0.35 alpha:1.00];
    
    //
    self.indicatorDiameter = 20;
    self.indicatorMargin = 10;
    
    //
    self.activeTintColor = [UIColor colorWithRed:0.26 green:0.76 blue:0.43 alpha:1.00];
    self.inactiveTintColor = [UIColor colorWithRed:0.82 green:0.94 blue:0.85 alpha:1.00];
    
    //
    self.activeTextColor = [UIColor colorWithRed:0.82 green:0.94 blue:0.85 alpha:1.00];
    self.inactiveTextColor = [UIColor colorWithRed:0.43 green:0.51 blue:0.61 alpha:1.00];
    
    //
    self.indicatorInactiveLayers = [NSMutableArray array];
    
    //
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateFrame)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
    //
    self.indicatorBackgroundLayer = [MMBgIndicatorLayer layer];
    [self.layer addSublayer:self.indicatorBackgroundLayer];
    
    //
    self.indicatorActiveLayer = [MMTextIndicatorLayer layer];
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
    
    __block UIBezierPath * path = [UIBezierPath bezierPathWithOvalInRect:(CGRect){CGPointZero,frame.size}];
    //
    self.indicatorActiveLayer.indicatorColor = self.activeTintColor;
    self.indicatorActiveLayer.textColor = self.activeTextColor;
    self.indicatorActiveLayer.path = path.CGPath;
    self.indicatorActiveLayer.frame = frame;
    self.indicatorActiveLayer.hidden = NO;
    
    //
    frame.size.width = self.intrinsicContentSize.width;
    self.indicatorBackgroundLayer.indicatorColor = self.inactiveTintColor;
    self.indicatorBackgroundLayer.numberOfPages = self.numberOfPages;
    self.indicatorBackgroundLayer.margin = self.indicatorMargin;
    self.indicatorBackgroundLayer.frame = frame;
    
    //
    frame.size.width = self.indicatorDiameter;
    [self.indicatorInactiveLayers enumerateObjectsUsingBlock:^(MMIndicatorLayer * indicatorLayer, NSUInteger index, BOOL * _Nonnull stop) {
        indicatorLayer.path = path.CGPath;
        indicatorLayer.frame = frame;
        indicatorLayer.hidden = NO;
        frame.origin.x += (self.indicatorDiameter + self.indicatorMargin);
    }];
    
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
    [self setNeedsLayout];
}

- (void)setActiveTintColor:(UIColor *)activeTintColor{

    _activeTintColor = activeTintColor;
    [self setNeedsLayout];
}

- (void)setIndicatorMargin:(CGFloat)indicatorMargin{

    _indicatorMargin = indicatorMargin;
    [self setNeedsLayout];
}

- (void)setIndicatorDiameter:(CGFloat)indicatorDiameter{

    _indicatorDiameter = indicatorDiameter;
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
    [self.indicatorInactiveLayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [self.indicatorInactiveLayers removeAllObjects];
    for (NSInteger index = 0; index < numberOfPges; index ++) {
        MMTextIndicatorLayer * indicatorLayer = [MMTextIndicatorLayer layer];
        indicatorLayer.indicatorColor = self.inactiveTintColor;
        indicatorLayer.textColor = self.inactiveTextColor;
        indicatorLayer.text = [NSString stringWithFormat:@"%ld",index + 1];
        [self.layer addSublayer:indicatorLayer];
        [self.indicatorInactiveLayers addObject:indicatorLayer];
    }
    
    //
    [self.layer addSublayer:self.indicatorActiveLayer];
    
    [self setNeedsLayout];
    [self invalidateIntrinsicContentSize];
}

- (void) updateForProgress:(CGFloat)progress{

    if (self.indicatorInactiveLayers.count &&
        self.numberOfPages > 1 &&
        progress >= 0 &&
        progress <= self.numberOfPages - 1) {
        
        CGRect min = self.indicatorInactiveLayers.firstObject.frame;
        CGRect max = self.indicatorInactiveLayers.lastObject.frame;
        
        NSInteger total = self.numberOfPages - 1;
        CGFloat dist = max.origin.x - min.origin.x;
        CGFloat percent = progress / total;
        CGFloat offset = dist * percent;
        CGRect frame = self.indicatorActiveLayer.frame;
        frame.origin.x = min.origin.x + offset;
//        NSLog(@"offset:%f\nprogress:%f",offset,progress);
        self.indicatorActiveLayer.text = [NSString stringWithFormat:@"%ld",self.currentPageIndex + 1];
        
        dist = self.indicatorDiameter * (self.currentPageIndex + 1) + self.currentPageIndex * self.indicatorMargin;
//        NSLog(@"dist:%f",dist);
        
        self.indicatorActiveLayer.frame = frame;
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
