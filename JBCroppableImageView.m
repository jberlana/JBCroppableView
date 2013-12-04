//
//  CropImageView.m
//  Crop Demo
//
//  Created by Daniel Sanche on 12/4/2013.
//  Copyright (c) 2013 Mobile one2one. All rights reserved.
//

#import "JBCroppableImageView.h"
#import "JBCroppableLayer.h"


@implementation JBCroppableImageView{
    JBCroppableLayer *_pointsView;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.userInteractionEnabled = YES;
        _pointsView = [[JBCroppableLayer alloc] initWithImageView:self];
        [_pointsView addPoints:4];
        
        [self addSubview:_pointsView];
        
        UIPanGestureRecognizer *singlePan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(singlePan:)];
        singlePan.maximumNumberOfTouches = 1;
        [self addGestureRecognizer:singlePan];
        
        UIPanGestureRecognizer *doublePan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(doublePan:)];
        doublePan.minimumNumberOfTouches = 2;
        [self addGestureRecognizer:doublePan];
        

    }
    return self;
}

-(void)singlePan:(UIPanGestureRecognizer *)gesture{
    CGPoint posInStretch = [gesture locationInView:_pointsView];
    if(gesture.state==UIGestureRecognizerStateBegan){
        [_pointsView findPointAtLocation:posInStretch];
    }
    if(gesture.state==UIGestureRecognizerStateEnded){
        _pointsView.activePoint.backgroundColor = _pointsView.pointColor;
        _pointsView.activePoint = nil;
    }
    [_pointsView moveActivePointToLocation:posInStretch];
    //  CGPoint translation = [gesture translationInView:self.imageView];
    //  [gesture setTranslation:CGPointZero inView:self.imageView];
}

-(void)doublePan:(UIPanGestureRecognizer *)gesture{
    NSLog(@"double pan");
    CGPoint translation = [gesture translationInView:self];
    CGPoint newCenter = CGPointMake(self.center.x+translation.x, self.center.y+translation.y);
    [self setCenter:newCenter];
    [gesture setTranslation:CGPointZero inView:self];
    
}

-(void)crop{
    [_pointsView maskImageView:self];
    [_pointsView removeFromSuperview];
}

-(void)reverseCrop{
    self.layer.mask = nil;
    [self addSubview:_pointsView];
}

-(UIImage *)getCroppedImage{
   return [_pointsView getCroppedImageForView:self withTransparentBorders:NO];
}

-(UIImage *)getCroppedImageWithTransparentBorders:(BOOL)transparent{
    return [_pointsView getCroppedImageForView:self withTransparentBorders:transparent];
}

- (void)addPoint{
    self.layer.mask = nil;
    NSMutableArray *oldPoints = [_pointsView.getPoints mutableCopy];
    // CGPoint new = CGPointMake((first.x+last.x)/2.0f, (first.y+last.y)/2.0f);
    
    NSInteger indexOfLargestGap;
    CGFloat largestGap = 0;
    for(int i=0; i< oldPoints.count-1; i++){
        CGPoint first = [[oldPoints objectAtIndex:i] CGPointValue];
        CGPoint last = [[oldPoints objectAtIndex:i+1] CGPointValue];
        CGFloat distance = [self distanceBetween:first And:last];
        if(distance>largestGap){
            indexOfLargestGap = i+1;
            largestGap = distance;
        }
    }
    CGPoint veryFirst = [[oldPoints firstObject] CGPointValue];
    CGPoint veryLast = [[oldPoints lastObject] CGPointValue];
    CGPoint new;
    
    if([self distanceBetween:veryFirst And:veryLast]>largestGap){
        indexOfLargestGap = oldPoints.count;
        new = CGPointMake((veryFirst.x+veryLast.x)/2.0f, (veryFirst.y+veryLast.y)/2.0f);
    } else {
        CGPoint first = [[oldPoints objectAtIndex:indexOfLargestGap-1] CGPointValue];
        CGPoint last = [[oldPoints objectAtIndex:indexOfLargestGap] CGPointValue];
        new = CGPointMake((first.x+last.x)/2.0f, (first.y+last.y)/2.0f);
    }
    
    
    [oldPoints insertObject:[NSValue valueWithCGPoint:new] atIndex:indexOfLargestGap];
    [_pointsView removeFromSuperview];
    _pointsView = [[JBCroppableLayer alloc] initWithImageView:self];
    [_pointsView addPointsAt:oldPoints];
    [self addSubview:_pointsView];
}

- (void)removePoint{
    self.layer.mask = nil;
    NSMutableArray *oldPoints = [_pointsView.getPoints mutableCopy];
    if(oldPoints.count==3) return;
    
    NSInteger indexOfSmallestGap;
    CGFloat smallestGap = INFINITY;
    for(int i=0; i< oldPoints.count; i++){
        int firstIndex = i-1;
        int lastIndex = i +1;
        
        if(firstIndex<0){
            firstIndex = (int)oldPoints.count-1+firstIndex;
        } else if(firstIndex>=oldPoints.count){
            firstIndex = firstIndex-(int)oldPoints.count;
        }
        if(lastIndex<0){
            lastIndex = (int)oldPoints.count-1+lastIndex;
        } else if(lastIndex>=oldPoints.count){
            lastIndex = lastIndex-(int)oldPoints.count;
        }
        
        CGPoint first = [[oldPoints objectAtIndex:firstIndex] CGPointValue];
        CGPoint mid = [[oldPoints objectAtIndex:i] CGPointValue];
        CGPoint last = [[oldPoints objectAtIndex:lastIndex] CGPointValue];
        CGFloat distance = [self distanceFrom:first to:last throuh:mid];
        if(distance<smallestGap){
            indexOfSmallestGap = i;
            smallestGap = distance;
        }
    }
    
    [oldPoints removeObjectAtIndex:indexOfSmallestGap];
    [_pointsView removeFromSuperview];
    _pointsView = [[JBCroppableLayer alloc] initWithImageView:self];
    [_pointsView addPointsAt:[NSArray arrayWithArray:oldPoints]];
    [self addSubview:_pointsView];
}

-(CGFloat)distanceBetween:(CGPoint)first And:(CGPoint)last{
    CGFloat xDist = (last.x - first.x);
    if(xDist<0) xDist=xDist*-1;
    CGFloat yDist = (last.y - first.y);
    if(yDist<0) yDist=yDist*-1;
    return sqrt((xDist * xDist) + (yDist * yDist));
}
-(CGFloat)distanceFrom:(CGPoint)first to:(CGPoint)last throuh:(CGPoint)middle{
    CGFloat firstToMid = [self distanceBetween:first And:middle];
    CGFloat lastToMid = [self distanceBetween:middle And:last];
    return   firstToMid + lastToMid;
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [_pointsView setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [_pointsView setNeedsDisplay];
}

@end
