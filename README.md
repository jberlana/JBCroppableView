# JBCroppableView

JBCroppableView is a subclass of UIView built with UIKit and CoreGraphics that adds n points on an UIImageView allowing to modify them by drag & drop to trim the extra space of an image.

## Features
* Add an NSArray of specific CGPoints to a UIImageView.
* Add a specific number of points.
* Drag&Drop of the points.
* Crops the UIImage in a UIImageView.
* Respects aspect ratio.
* ARC(Automatic Reference Counting) support.

## Installation
* Drag the JBCroppableView/JBCroppableView folder into your project.
* Add the CoreGraphics framework to your project.

## Usage
(see example Xcode project in /TestCroping)

### With a undefined number of points:
	self.pointsView = [[JBCroppableView alloc] initWithImageView:self.image];
    [self.pointsView addPoints:9];
    [self.view addSubview:self.pointsView];

### With a defined array of points:
	self.pointsView = [[JBCroppableView alloc] initWithImageView:self.image];
	[self.pointsView addPointsAt:@[[NSValue valueWithCGPoint:CGPointMake(10, 10)],
                                [NSValue valueWithCGPoint:CGPointMake(50, 10)],
                                [NSValue valueWithCGPoint:CGPointMake(50, 50)],
                                [NSValue valueWithCGPoint:CGPointMake(10, 50)]]];
    [self.view addSubview:self.pointsView];

### Get the current position of points:
- (NSArray *)getPoints;

### Crop the image:
- (UIImage *)deleteBackgroundOfImage:(UIImageView *)image;

## Demo

![image](https://github.com/jberlana/JBCroppableView/raw/master/demo.png)

## Credit
Javier Berlana, [Mobile One2One](http://www.mo2o.com/)