//
//  MMPageControl.h
//  MMPageControl
//
//  Created by user1 on 2017/8/10.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMPageControl : UIControl

@property (nonatomic) IBInspectable NSInteger numberOfPages;
@property (nonatomic) IBInspectable CGFloat progress;
@property (nonatomic) IBInspectable BOOL hidesForSinglePage;

@property (nonatomic ,strong) IBInspectable UIColor * inactiveTintColor;
@property (nonatomic ,strong) IBInspectable UIColor * activeTintColor;

@property (nonatomic ,strong) IBInspectable UIColor * inactiveTextColor;
@property (nonatomic ,strong) IBInspectable UIColor * activeTextColor;

@property (nonatomic) IBInspectable CGFloat indicatorDiameter;// 指示layer的直径
@property (nonatomic) IBInspectable CGFloat indicatorMargin;// 指示layer之间的间距

@property (nonatomic ,readonly) NSInteger currentPageIndex;

- (void) setProgress:(CGFloat)progress animated:(BOOL)animated;
@end
