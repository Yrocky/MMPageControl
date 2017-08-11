//
//  MMIndicatorLayer.h
//  MMPageControl
//
//  Created by user1 on 2017/8/11.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface MMIndicatorLayer : CAShapeLayer

@end

@interface MMBackgroundLayer : MMIndicatorLayer

@property (nonatomic) NSInteger numberOfPages;

@end
