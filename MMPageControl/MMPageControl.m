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

@property (nonatomic) CGFloat indicatorDiameter;// 指示layer的直径
@property (nonatomic) CGFloat indicatorMargin;// 指示layer之间的间距

@property (nonatomic) CGFloat moveToProgress;

@property (nonatomic ,strong) CADisplayLink * displayLink;

@property (nonatomic ,strong) MMIndicatorLayer * indicatorBackgroundLayer;

@property (nonatomic ,strong) NSMutableArray <MMIndicatorLayer *>* indicatorInactiveLayers;

@property (nonatomic ,strong) MMIndicatorLayer * indicatorActiveLayer;
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

    //
    self.indicatorDiameter = 40;
    self.indicatorMargin = 30;
    
    //
    self.indicatorInactiveLayers = [NSMutableArray array];
    
    //
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateFrame)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
    //
    self.indicatorBackgroundLayer = [MMIndicatorLayer layer];
    self.indicatorBackgroundLayer.backgroundColor = [UIColor grayColor].CGColor;
    [self.layer addSublayer:self.indicatorBackgroundLayer];
    
    //
    self.indicatorActiveLayer = [MMIndicatorLayer layer];
    self.indicatorActiveLayer.backgroundColor = [UIColor orangeColor].CGColor;
}

#pragma mark - API M

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated{
    
    if (progress >= 0 || progress <= self.numberOfPages - 1) {
        if (animated) {
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
    
    //
    self.indicatorActiveLayer.frame = frame;
    
    //
    frame.size.width = self.intrinsicContentSize.width;
    self.indicatorBackgroundLayer.frame = frame;
    
    //
    frame.size.width = self.indicatorDiameter;
    [self.indicatorInactiveLayers enumerateObjectsUsingBlock:^(MMIndicatorLayer * indicatorLayer, NSUInteger index, BOOL * _Nonnull stop) {
        
        indicatorLayer.frame = frame;
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

    _numberOfPages = numberOfPages;
    [self updateNumberOfPages:numberOfPages];
    self.hidden = self.hidesForSinglePage && (numberOfPages <= 1);
}

- (void)setHidesForSinglePage:(BOOL)hidesForSinglePage{

    _hidesForSinglePage = hidesForSinglePage;
    [self setNeedsLayout];
}

- (void)setProgress:(CGFloat)progress{

    _progress = progress;
    [self updateForProgress:progress];
}

#pragma mark - Getter M

- (NSInteger)currentPageIndex{

    return (NSInteger)self.progress;
}

@end


@implementation MMPageControl (Update)

- (void)updateNumberOfPages:(NSInteger)numberOfPges{

    //
    [self.indicatorInactiveLayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [self.indicatorInactiveLayers removeAllObjects];
    for (NSInteger index = 0; index < numberOfPges; index ++) {
        MMIndicatorLayer * indicatorLayer = [MMIndicatorLayer layer];
        UIColor * bgColor = [UIColor redColor];
        indicatorLayer.backgroundColor = bgColor.CGColor;
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
