//
//  MMIndicatorLayer.h
//  MMPageControl
//
//  Created by user1 on 2017/8/11.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface MMIndicatorLayer : CAShapeLayer

@property (nonatomic ,strong) UIColor * indicatorColor;

// override by subclass
- (void) setupDefault;
@end

@interface MMBgIndicatorLayer : MMIndicatorLayer

@property (nonatomic) CGFloat margin;
@property (nonatomic) NSInteger numberOfPages;

@end

@interface MMTextIndicatorLayer : MMIndicatorLayer{
    CATextLayer * _textLayer;
}
@property (nonatomic ,strong) UIColor * textColor;
@property (nonatomic ,strong) NSString * text;

@end

@interface MMIndicatorContentLayer : MMIndicatorLayer{
    NSMutableArray * _indicatorLayers;
}
@property (nonatomic) CGFloat indicatorDiameter;// 指示layer的直径
@property (nonatomic) CGFloat indicatorMargin;// 指示layer之间的间距

- (void) clearAllIndicator;
- (void) addIndicator:(NSString *)text;
@end

@interface UIColor (HEX)
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;
@end
