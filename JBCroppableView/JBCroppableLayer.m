//
//  PointsView.m
//  TestCroping
//
//  Created by Javier Berlana on 20/12/12.
//  Copyright (c) 2012 Mobile one2one. All rights reserved.
//

#import "JBCroppableLayer.h"
#import <QuartzCore/QuartzCore.h>

#define k_POINT_WIDTH 30

@interface JBCroppableLayer () {
    
    CGPoint lastPoint;
    UIBezierPath *LastBezierPath;
    BOOL isContainView;
}

@property (nonatomic, strong) NSArray *points;

@end

@implementation JBCroppableLayer

- (id)initWithImageView:(UIImageView *)imageView
{
    
    CGRect newFrame = CGRectMake(0,0, imageView.frame.size.width, imageView.frame.size.height);
    self = [super initWithFrame:newFrame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.pointColor      = [UIColor blueColor];
        self.lineColor       = [UIColor yellowColor];
        self.clipsToBounds   = YES;
        
        [self addPointsAt:nil];
        self.userInteractionEnabled = YES;
        isContainView = YES;
        LastBezierPath = [UIBezierPath bezierPath];
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
        
        point = [self getPointView:pointsAdded at:CGPointMake(x +20, self.frame.size.height -50)];
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


-(CGFloat)distanceBetween:(CGPoint)first And:(CGPoint)last{
    CGFloat xDist = (last.x - first.x);
    if(xDist<0) xDist=xDist*-1;
    CGFloat yDist = (last.y - first.y);
    if(yDist<0) yDist=yDist*-1;
    return sqrt((xDist * xDist) + (yDist * yDist));
}

-(void)findPointAtLocation:(CGPoint)location{
    self.activePoint.backgroundColor = self.pointColor;
    self.activePoint = nil;
    CGFloat smallestDistance = INFINITY;
    
    for (UIView *point in self.points)
    {
        CGRect extentedFrame = CGRectInset(point.frame, -20, -20);
        if (CGRectContainsPoint(extentedFrame, location))
        {
            CGFloat distanceToThis = [self distanceBetween:point.frame.origin And:location];
            if(distanceToThis<smallestDistance){
                self.activePoint = point;
                smallestDistance = distanceToThis;
            }
        }
    }
    if(self.activePoint) self.activePoint.backgroundColor = [UIColor redColor];
}

- (void)moveActivePointToLocation:(CGPoint)locationPoint
{
    NSLog(@"location: %f,%f", locationPoint.x, locationPoint.y);
    CGFloat newX = locationPoint.x;
    CGFloat newY = locationPoint.y;
    //cap off possible values
    if(newX<0){
        newX=0;
    }else if(newX>self.frame.size.width){
        newX = self.frame.size.width;
    }
    if(newY<0){
        newY=0;
    }else if(newY>self.frame.size.height){
        newY = self.frame.size.height;
    }
    locationPoint = CGPointMake(newX, newY);
    
    if (self.activePoint){
        
        self.activePoint.frame = CGRectMake(locationPoint.x -k_POINT_WIDTH/2, locationPoint.y -k_POINT_WIDTH/2, k_POINT_WIDTH, k_POINT_WIDTH);
        [self setNeedsDisplay];
    }
}

-(UIBezierPath *)getPath{
    if (self.points.count <= 0) return nil;
    NSArray *points = [self getPoints];
    
    UIBezierPath *aPath = [UIBezierPath bezierPath];
    
    // Set the starting point of the shape.
    CGPoint p1 = [[points objectAtIndex:0] CGPointValue];
    [aPath moveToPoint:CGPointMake(p1.x, p1.y)];
    
    for (uint i=1; i<points.count; i++)
    {
        CGPoint p = [[points objectAtIndex:i] CGPointValue];
        [aPath addLineToPoint:CGPointMake(p.x, p.y)];
    }
    [aPath closePath];
    return aPath;
}

- (void)maskImageView:(UIImageView *)image
{
    UIBezierPath *path = [self getPath];
    
    CGRect rect = CGRectZero;
    rect.size = image.image.size;
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = CGRectMake(0, 0, image.frame.size.width, image.frame.size.height);
    shapeLayer.path = path.CGPath;
    shapeLayer.fillColor = [[UIColor whiteColor] CGColor];
    shapeLayer.backgroundColor = [[UIColor clearColor] CGColor];
    [image.layer setMask:shapeLayer];
}

-(UIImage *)getCroppedImageForView:(UIImageView *)view withTransparentBorders:(BOOL)transparent{
    BOOL hidden = self.hidden;
    self.hidden = YES;
    CGSize size =view.layer.bounds.size;
    
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.hidden = hidden;
    if(!transparent) return image;
    else return [self cropTransparencyFromImage:image];
}

#pragma mark - crop transparency

-(UIImage *)cropTransparencyFromImage:(UIImage *)oldImage{
    CGRect newRect = [self cropRectForImage:oldImage];
    CGImageRef imageRef = CGImageCreateWithImageInRect(oldImage.CGImage, newRect);
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return newImage;
}

- (CGRect)cropRectForImage:(UIImage *)image {
    
    CGImageRef cgImage = image.CGImage;
    CGContextRef context = [self createARGBBitmapContextFromImage:cgImage];
    if (context == NULL) return CGRectZero;
    
    size_t width = CGImageGetWidth(cgImage);
    size_t height = CGImageGetHeight(cgImage);
    CGRect rect = CGRectMake(0, 0, width, height);
    
    CGContextDrawImage(context, rect, cgImage);
    
    unsigned char *data = CGBitmapContextGetData(context);
    CGContextRelease(context);
    
    //Filter through data and look for non-transparent pixels.
    long lowX = width;
    long lowY = height;
    long highX = 0;
    long highY = 0;
    if (data != NULL) {
        for (int y=0; y<height; y++) {
            for (int x=0; x<width; x++) {
                long pixelIndex = (width * y + x) * 4 /* 4 for A, R, G, B */;
                if (data[pixelIndex] != 0) { //Alpha value is not zero; pixel is not transparent.
                    if (x < lowX) lowX = x;
                    if (x > highX) highX = x;
                    if (y < lowY) lowY = y;
                    if (y > highY) highY = y;
                }
            }
        }
        free(data);
    } else {
        return CGRectZero;
    }
    
    return CGRectMake(lowX, lowY, highX-lowX, highY-lowY);
}

- (CGContextRef)createARGBBitmapContextFromImage:(CGImageRef)inImage {
    
    CGContextRef context = NULL;
    CGColorSpaceRef colorSpace;
    void *bitmapData;
    int bitmapByteCount;
    int bitmapBytesPerRow;
    
    // Get image width, height. We'll use the entire image.
    size_t width = CGImageGetWidth(inImage);
    size_t height = CGImageGetHeight(inImage);
    
    // Declare the number of bytes per row. Each pixel in the bitmap in this
    // example is represented by 4 bytes; 8 bits each of red, green, blue, and
    // alpha.
    bitmapBytesPerRow = (width * 4);
    bitmapByteCount = (bitmapBytesPerRow * height);
    
    // Use the generic RGB color space.
    colorSpace = CGColorSpaceCreateDeviceRGB();
    if (colorSpace == NULL) return NULL;
    
    // Allocate memory for image data. This is the destination in memory
    // where any drawing to the bitmap context will be rendered.
    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL)
    {
        CGColorSpaceRelease(colorSpace);
        return NULL;
    }
    
    // Create the bitmap context. We want pre-multiplied ARGB, 8-bits
    // per component. Regardless of what the source image format is
    // (CMYK, Grayscale, and so on) it will be converted over to the format
    // specified here by CGBitmapContextCreate.
    context = CGBitmapContextCreate (bitmapData,
                                     width,
                                     height,
                                     8,      // bits per component
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     kCGImageAlphaPremultipliedFirst);
    if (context == NULL) free (bitmapData);
    
    // Make sure and release colorspace before returning
    CGColorSpaceRelease(colorSpace);
    
    return context;
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



@end
