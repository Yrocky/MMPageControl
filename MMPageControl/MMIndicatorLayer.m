//
//  MMIndicatorLayer.m
//  MMPageControl
//
//  Created by user1 on 2017/8/11.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import "MMIndicatorLayer.h"

#define DEGREES_TO_RADIANS(degrees)  ((M_PI * degrees)/ 180)

@implementation MMIndicatorLayer

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupDefault];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupDefault];
    }
    return self;
}

- (void) setupDefault{

    self.indicatorColor = [UIColor colorWithRed:0.82 green:0.94 blue:0.86 alpha:1.00];
    self.fillMode = kCAFillModeForwards;
}

- (void)setIndicatorColor:(UIColor *)indicatorColor{

    _indicatorColor = indicatorColor;
    self.fillColor = indicatorColor.CGColor;
    [self setNeedsLayout];
}

@end

@implementation MMBgIndicatorLayer

- (void)layoutSublayers{

    [super layoutSublayers];
    
    CGFloat r = self.frame.size.height / 2;
    CGFloat m = self.margin;
    
    CGPoint center = (CGPoint){
        r, r
    };
    
    UIBezierPath * path = [UIBezierPath bezierPath];
    
    if (self.numberOfPages == 1) {
        [path addArcWithCenter:center
                        radius:r
                    startAngle:DEGREES_TO_RADIANS(0)
                      endAngle:DEGREES_TO_RADIANS(360)
                     clockwise:YES];
    }else{

        [path moveToPoint:(CGPoint){
            r * (1 - 1 / sqrt(2)),
            r * (1 - 1 / sqrt(2))
        }];
        
        // add head arc
        [self addEdgeCircelArcPath:path
                            center:center
                            isHead:YES];
        
        // add bottom middle arc
        for (NSUInteger index = 1; index < self.numberOfPages; index ++) {
            center = (CGPoint){
                (index - 1) * (2 * r + m) + 2 * r + m / 2,
                2 * r + m /2
            };
            [self addInteriorBigCircelArcPath:path
                                       center:center
                                        isTop:NO];
            
            center = (CGPoint){
                index * (2 * r + m) + r,
                r
            };
            [self addInteriorSmallCircelArcPath:path
                                         center:center
                                          isTop:NO];
        }
        
        // add tail arc
        center = (CGPoint){
            (self.numberOfPages - 1 ) * (2 * r + m) + r,
            r
        };
        [self addEdgeCircelArcPath:path
                            center:center
                            isHead:NO];
        
        // add top middle arc
        for (NSUInteger index = self.numberOfPages - 1; index > 0; index --) {
            center = (CGPoint){
                (index - 1) * (2 * r + m) + 2 * r + m / 2,
                - m /2
            };
            [self addInteriorBigCircelArcPath:path
                                       center:center
                                        isTop:YES];

            center = (CGPoint){
                (index - 1) * (2 * r + m) + r,
                r
            };
            [self addInteriorSmallCircelArcPath:path
                                         center:center
                                          isTop:YES];
        }
    }
    
    [path closePath];
    [path fill];
    
    self.path = path.CGPath;
}

#pragma mark - Private M

- (void) addEdgeCircelArcPath:(UIBezierPath *)path center:(CGPoint)center isHead:(BOOL)isHead{
    
    CGFloat r = self.frame.size.height / 2;
    
    CGFloat start = DEGREES_TO_RADIANS((isHead ? 180 + 45 : 45));
    CGFloat end = DEGREES_TO_RADIANS((isHead ? 45 : 180 + 45));

    [path addArcWithCenter:center
                    radius:r
                startAngle:start
                  endAngle:end
                 clockwise:NO];
}

- (void) addInteriorSmallCircelArcPath:(UIBezierPath *)path center:(CGPoint)center isTop:(BOOL)isTop{
    
    CGFloat r = self.frame.size.height / 2;
    
    CGFloat start = DEGREES_TO_RADIANS((isTop ? 360 - 45 : 135));
    CGFloat end = DEGREES_TO_RADIANS((isTop ? 180 + 45 : 45));
    
    [path addArcWithCenter:center
                    radius:r
                startAngle:start
                  endAngle:end
                 clockwise:NO];
}

- (void) addInteriorBigCircelArcPath:(UIBezierPath *)path center:(CGPoint)center isTop:(BOOL)isTop{

    CGFloat r = self.frame.size.height / 2;
    CGFloat m = self.margin;
    CGFloat R = (sqrt(2) - 1) * r + m / sqrt(2);
    
    CGFloat start = DEGREES_TO_RADIANS((isTop ? 45 : -135));
    CGFloat end = DEGREES_TO_RADIANS((isTop ? 180 - 45 : -45));
    
    [path addArcWithCenter:center
                    radius:R
                startAngle:start
                  endAngle:end
                 clockwise:YES];
}
#pragma mark - Setter M

- (void)setNumberOfPages:(NSInteger)numberOfPages{

    _numberOfPages = numberOfPages;
    [self setNeedsLayout];
}

- (void)setMargin:(CGFloat)margin{

    _margin = margin;
    [self needsLayout];
}

@end


@implementation MMTextIndicatorLayer

- (void) setupDefault{

    [super setupDefault];
    
    self.textColor = [UIColor colorWithHexString:@"#6E819B"];
    
    //
    _textLayer = [CATextLayer layer];
    _textLayer.truncationMode = kCATruncationEnd;
    _textLayer.alignmentMode = kCAAlignmentCenter;
    _textLayer.wrapped = YES;
    _textLayer.contentsScale = [UIScreen mainScreen].scale;
    [self addSublayer:_textLayer];
}

- (void)layoutSublayers{

    [super layoutSublayers];
    
    _textLayer.string = self.text;
    _textLayer.foregroundColor = self.textColor.CGColor;
    
    CGRect frame = (CGRect){CGPointZero,self.frame.size};
    _textLayer.frame = CGRectInset(frame, 0, 10);
    
    UIFont *font = [UIFont systemFontOfSize:frame.size.width - 22];
    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
    _textLayer.font = fontRef;
    _textLayer.fontSize = font.pointSize;
}
#pragma mark - Setter M

- (void)setText:(NSString *)text{

    _text = text;
    [self setNeedsLayout];
}

- (void)setTextColor:(UIColor *)textColor{

    _textColor = textColor;
    [self setNeedsLayout];
}

@end

@interface MMIndicatorContentLayer ()
@end

@implementation MMIndicatorContentLayer

- (instancetype)init
{
    self = [super init];
    if (self) {
        _indicatorLayers = [NSMutableArray array];
    }
    return self;
}

-(void)layoutSublayers{
    
    [super layoutSublayers];

    __block CGRect frame = (CGRect){
        CGPointZero,
        self.indicatorDiameter,
        self.frame.size.height
    };
    [_indicatorLayers enumerateObjectsUsingBlock:^(MMIndicatorLayer * indicatorLayer, NSUInteger index, BOOL * _Nonnull stop) {
        indicatorLayer.frame = frame;
        indicatorLayer.hidden = NO;
        frame.origin.x += (self.indicatorDiameter + self.indicatorMargin);
    }];
}

- (void)clearAllIndicator{
    
    [_indicatorLayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [_indicatorLayers removeAllObjects];
}

- (void)addIndicator:(NSString *)text{
    
    MMTextIndicatorLayer * indicatorLayer = [MMTextIndicatorLayer layer];
    indicatorLayer.textColor = self.indicatorColor;
    indicatorLayer.text = text;
    [self addSublayer:indicatorLayer];
    [_indicatorLayers addObject:indicatorLayer];
}

- (void)setIndicatorColor:(UIColor *)indicatorColor{
    
    [super setIndicatorColor:indicatorColor];
    for (MMTextIndicatorLayer * layer in _indicatorLayers) {
        layer.textColor = indicatorColor;
    }
}

@end

@implementation UIColor (HEX)

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert{
    
    if ([stringToConvert hasPrefix:@"#"]) {
        stringToConvert = [stringToConvert substringFromIndex:1];
    }
    NSScanner *scanner = [NSScanner scannerWithString:stringToConvert];
    unsigned hexNum;
    if (![scanner scanHexInt:&hexNum]) return nil;
    return [UIColor colorWithRGBHex:hexNum];
}

+ (UIColor *)colorWithRGBHex:(UInt32)hex{
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}


@end
