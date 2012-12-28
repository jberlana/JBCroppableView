//
//  PointsView.h
//  TestCroping
//
//  Created by Javier Berlana on 20/12/12.
//  Copyright (c) 2012 Mobile one2one. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JBCroppableView : UIView

@property (nonatomic, strong) UIColor *pointColor;
@property (nonatomic, strong) UIColor *lineColor;

- (id)initWithImageView:(UIImageView *)imageView;

- (NSArray *)getPoints;
- (UIImage *)deleteBackgroundOfImage:(UIImageView *)image;

- (void)addPointsAt:(NSArray *)points;
- (void)addPoints:(int)num;

+ (CGPoint)convertPoint:(CGPoint)point1 fromRect1:(CGSize)rect1 toRect2:(CGSize)rect2;
+ (CGRect)scaleRespectAspectFromRect1:(CGRect)rect1 toRect2:(CGRect)rect2;

@end
