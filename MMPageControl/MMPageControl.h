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

@property (nonatomic ,readonly) NSInteger currentPageIndex;

- (void) setProgress:(CGFloat)progress animated:(BOOL)animated;
@end
