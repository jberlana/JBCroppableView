//
//  PointsView.h
//  TestCroping
//
//  Created by Javier Berlana on 20/12/12.
//  Copyright (c) 2012 Mobile one2one. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JBCroppableLayer : UIView

@property (nonatomic, strong) UIColor *pointColor;
@property (nonatomic, strong) UIColor *lineColor;

@property (nonatomic, strong) UIView *activePoint;

- (id)initWithImageView:(UIImageView *)imageView;

- (NSArray *)getPoints;
- (void)maskImageView:(UIImageView *)image;


- (void)addPointsAt:(NSArray *)points;
- (void)addPoints:(int)num;

-(void)findPointAtLocation:(CGPoint)location;
- (void)moveActivePointToLocation:(CGPoint)locationPoint;
-(UIImage *)getCroppedImageForView:(UIImageView *)view withTransparentBorders:(BOOL)transparent;
@end
