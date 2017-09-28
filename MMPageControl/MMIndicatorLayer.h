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
