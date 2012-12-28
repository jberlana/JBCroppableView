//
//  PointsView.m
//  TestCroping
//
//  Created by Javier Berlana on 20/12/12.
//  Copyright (c) 2012 Mobile one2one. All rights reserved.
//

#import "JBCroppableView.h"
#import <QuartzCore/QuartzCore.h>

#define k_POINT_WIDTH 30

@interface JBCroppableView () {
    
    CGPoint lastPoint;
}

@property (nonatomic, strong) NSArray *points;
@property (nonatomic, strong) UIView *activePoint;

+ (CGPoint)convertCGPoint:(CGPoint)point1 fromRect1:(CGSize)rect1 toRect2:(CGSize)rect2;

@end

@implementation JBCroppableView

- (id)initWithImageView:(UIImageView *)imageView
{
    self = [super initWithFrame:imageView.frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.pointColor      = [UIColor blueColor];
        self.lineColor       = [UIColor yellowColor];
        self.clipsToBounds   = YES;
        
        [self addPointsAt:nil];
    }
    return self;
}

- (void)addPointsAt:(NSArray *)points
{
    NSMutableArray *tmp = [NSMutableArray array];
    
    uint i = 0;
    for (NSValue *point in points)
    {
        UIView *pointToAdd = [self getPointView:i at:point.CGPointValue];
        [tmp addObject:pointToAdd];
        [self addSubview:pointToAdd];
        
        i++;
    }
    
    self.points = tmp;
}

- (void)addPoints:(int)num
{
    if (num <= 0) return;
    
    NSMutableArray *tmp = [NSMutableArray array];
    int pointsAdded     = 0;
    int pointsToAdd     = num -1;
    float pointsPerSide = 0.0;
    
    if (num > 4)
        pointsPerSide = (num-4) /4.0;
    
    // Corner 1
    UIView *point = [self getPointView:pointsAdded at:CGPointMake(20, 20)];
    [tmp addObject:point];
    [self addSubview:point];
    pointsAdded ++;
    pointsToAdd --;
    
    // Upper side
    if (pointsPerSide - (int)pointsPerSide >= 0.25)
        pointsPerSide ++;
    
    for (uint i=0; i<(int)pointsPerSide; i++)
    {
        float x = ((self.frame.size.width -40) / ((int)pointsPerSide +1)) * (i+1);
        
        point = [self getPointView:pointsAdded at:CGPointMake(x +20, 20)];
        [tmp addObject:point];
        [self addSubview:point];
        pointsAdded ++;
        pointsToAdd --;
    }
    
    if (pointsPerSide - (int)pointsPerSide >= 0.25)
        pointsPerSide --;
    
    // Corner 2
    point = [self getPointView:pointsAdded at:CGPointMake(self.frame.size.width -20, 20)];
    [tmp addObject:point];
    [self addSubview:point];
    pointsAdded ++;
    pointsToAdd --;
    
    // Right side
    if (pointsPerSide - (int)pointsPerSide >= 0.5)
        pointsPerSide ++;
    
    for (uint i=0; i<(int)pointsPerSide; i++)
    {
        float y = (self.frame.size.height -40) / ((int)pointsPerSide +1)  * (i+1);
        
        point = [self getPointView:pointsAdded at:CGPointMake(self.frame.size.width -20, 20+y)];
        [tmp addObject:point];
        [self addSubview:point];
        pointsAdded ++;
        pointsToAdd --;
    }
    
    if (pointsPerSide - (int)pointsPerSide >= 0.5)
        pointsPerSide --;
    
    // Corner 3
    point = [self getPointView:pointsAdded at:CGPointMake(self.frame.size.width -20, self.frame.size.height -20)];
    [tmp addObject:point];
    [self addSubview:point];
    pointsAdded ++;
    pointsToAdd --;
    
    // Bottom side
    if (pointsPerSide - (int)pointsPerSide >= 0.75)
        pointsPerSide ++;
    
    for (uint i=(int)pointsPerSide; i > 0; i--)
    {
        float x = (self.frame.size.width -40) / ((int)pointsPerSide +1) * i;
        
        point = [self getPointView:pointsAdded at:CGPointMake(x +20, self.frame.size.height -20)];
        [tmp addObject:point];
        [self addSubview:point];
        pointsAdded ++;
        pointsToAdd --;
    }
    
    if (pointsPerSide - (int)pointsPerSide >= 0.75)
        pointsPerSide --;
    
    // Corner 4
    point = [self getPointView:pointsAdded at:CGPointMake(20, self.frame.size.height -20)];
    [tmp addObject:point];
    [self addSubview:point];
    pointsAdded ++;
    pointsToAdd --;
    
    // Left side
    for (uint i=pointsPerSide; i>0; i--)
    {
        float y = (self.frame.size.height -40) / (pointsPerSide +1) * i;
        
        point = [self getPointView:pointsAdded at:CGPointMake(20, 20+y)];
        [tmp addObject:point];
        [self addSubview:point];
        pointsAdded ++;
        pointsToAdd --;
    }
    
    
    self.points = tmp;
}

- (NSArray *)getPoints
{
    NSMutableArray *p = [NSMutableArray array];
    
    for (uint i=0; i<self.points.count; i++)
    {
        UIView *v = [self.points objectAtIndex:i];
        CGPoint point = CGPointMake(v.frame.origin.x +k_POINT_WIDTH/2, v.frame.origin.y +k_POINT_WIDTH/2);
        [p addObject:[NSValue valueWithCGPoint:point]];
    }
    
    return p;
}

- (UIView *)getPointView:(int)num at:(CGPoint)point
{
    UIView *point1 = [[UIView alloc] initWithFrame:CGRectMake(point.x -k_POINT_WIDTH/2, point.y-k_POINT_WIDTH/2, k_POINT_WIDTH, k_POINT_WIDTH)];
    point1.alpha = 0.8;
    point1.backgroundColor    = self.pointColor;
    point1.layer.borderColor  = self.lineColor.CGColor;
    point1.layer.borderWidth  = 4;
    point1.layer.cornerRadius = k_POINT_WIDTH/2;
    
    UILabel *number = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, k_POINT_WIDTH, k_POINT_WIDTH)];
    number.text = [NSString stringWithFormat:@"%d",num];
    number.textColor = [UIColor whiteColor];
    number.backgroundColor = [UIColor clearColor];
    number.font = [UIFont systemFontOfSize:14];
    number.textAlignment = NSTextAlignmentCenter;
    
    [point1 addSubview:number];
    
    return point1;
}


#pragma mark - Support methods

+ (CGRect)scaleRespectAspectFromRect1:(CGRect)rect1 toRect2:(CGRect)rect2
{
    CGSize scaledSize = rect2.size;
    
    float scaleFactor = 1.0;
    
    CGFloat widthFactor  = rect2.size.width / rect1.size.width;
    CGFloat heightFactor = rect2.size.height / rect1.size.width;
    
    if (widthFactor < heightFactor)
        scaleFactor = widthFactor;
    else
        scaleFactor = heightFactor;
    
    scaledSize.height = rect1.size.height *scaleFactor;
    scaledSize.width  = rect1.size.width  *scaleFactor;
    
    float y = (rect2.size.height - scaledSize.height)/2;
    
    return CGRectMake(0, y, scaledSize.width, scaledSize.height);
}


+ (CGPoint)convertCGPoint:(CGPoint)point1 fromRect1:(CGSize)rect1 toRect2:(CGSize)rect2
{
    point1.y = rect1.height - point1.y;
    CGPoint result = CGPointMake((point1.x*rect2.width)/rect1.width, (point1.y*rect2.height)/rect1.height);
    return result;
}


+ (CGPoint)convertPoint:(CGPoint)point1 fromRect1:(CGSize)rect1 toRect2:(CGSize)rect2
{
    CGPoint result = CGPointMake((point1.x*rect2.width)/rect1.width, (point1.y*rect2.height)/rect1.height);
    return result;
}

- (UIImage *)deleteBackgroundOfImage:(UIImageView *)image
{
    if (self.points.count <= 0) return nil;
    
    NSArray *points = [self getPoints];
    
    CGRect rect = CGRectZero;
    rect.size = image.image.size;
    
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0.0);
    
    {
        [[UIColor blackColor] setFill];
        UIRectFill(rect);
        [[UIColor whiteColor] setFill];
        
        UIBezierPath *aPath = [UIBezierPath bezierPath];
        
        // Set the starting point of the shape.
        CGPoint p1 = [JBCroppableView convertCGPoint:[[points objectAtIndex:0] CGPointValue] fromRect1:image.frame.size toRect2:image.image.size];
        [aPath moveToPoint:CGPointMake(p1.x, p1.y)];
        
        for (uint i=1; i<points.count; i++)
        {
            CGPoint p = [JBCroppableView convertCGPoint:[[points objectAtIndex:i] CGPointValue] fromRect1:image.frame.size toRect2:image.image.size];
            [aPath addLineToPoint:CGPointMake(p.x, p.y)];
        }
        [aPath closePath];
        [aPath fill];
    }
    
    UIImage *mask = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    
    {
        CGContextClipToMask(UIGraphicsGetCurrentContext(), rect, mask.CGImage);
        [image.image drawAtPoint:CGPointZero];
    }
    
    UIImage *maskedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return maskedImage;
}

#pragma mark - Draw & touch

- (void)drawRect:(CGRect)rect
{
    if (self.points.count <= 0) return;
    
    // get the current context
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextClearRect(context, self.frame);
    
    const CGFloat *components = CGColorGetComponents(self.lineColor.CGColor);
    
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat alpha;
    
    if(CGColorGetNumberOfComponents(self.lineColor.CGColor) == 2)
    {
        red   = 1;
        green = 1;
        blue  = 1;
        alpha = 1;
    }
    else
    {
        red   = components[0];
        green = components[1];
        blue  = components[2];
        alpha = components[3];
        if (alpha <= 0) alpha = 1;
    }
    
    
    // set the stroke color and width
    CGContextSetRGBStrokeColor(context, red, green, blue, alpha);
    CGContextSetLineWidth(context, 2.0);
    
    UIView *point1 = [self.points objectAtIndex:0];
    CGContextMoveToPoint(context, point1.frame.origin.x +k_POINT_WIDTH/2, point1.frame.origin.y +k_POINT_WIDTH/2);
    
    for (uint i=1; i<self.points.count; i++)
    {
        UIView *point = [self.points objectAtIndex:i];
        CGContextAddLineToPoint(context, point.frame.origin.x +k_POINT_WIDTH/2, point.frame.origin.y +k_POINT_WIDTH/2);
    }
    
    CGContextAddLineToPoint(context, point1.frame.origin.x +k_POINT_WIDTH/2, point1.frame.origin.y +k_POINT_WIDTH/2);
    
    // tell the context to draw the stroked line
    CGContextStrokePath(context);
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint locationPoint = [[touches anyObject] locationInView:self];
    
    for (UIView *point in self.points)
    {
        CGPoint viewPoint = [point convertPoint:locationPoint fromView:self];
        
        if ([point pointInside:viewPoint withEvent:event])
        {
            self.activePoint = point;
            self.activePoint.backgroundColor = [UIColor redColor];
            
            break;
        }
    }
    
    lastPoint = locationPoint;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint locationPoint = [[touches anyObject] locationInView:self];
    
    if (!self.activePoint)
    {
        for (UIView *point in self.points)
        {
            point.frame = CGRectOffset(point.frame, locationPoint.x - lastPoint.x, +locationPoint.y -lastPoint.y);
        }
        [self setNeedsDisplay];
    }
    else
    {
        self.activePoint.frame = CGRectMake(locationPoint.x -k_POINT_WIDTH/2, locationPoint.y -k_POINT_WIDTH/2, k_POINT_WIDTH, k_POINT_WIDTH);
        [self setNeedsDisplay];
    }
    lastPoint = locationPoint;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.activePoint.backgroundColor = self.pointColor;
    self.activePoint = nil;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.activePoint.backgroundColor = self.pointColor;
    self.activePoint = nil;
}

@end
