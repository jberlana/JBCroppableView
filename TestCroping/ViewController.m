//
//  ViewController.m
//  TestCroping
//
//  Created by Javier Berlana on 20/12/12.
//  Copyright (c) 2012 Mobile one2one. All rights reserved.
//

#import "ViewController.h"
#import "JBCroppableView.h"

@interface ViewController () {
    
    UIImageView *b;
}

@property (nonatomic, strong) JBCroppableView *pointsView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.image.frame = [JBCroppableView scaleRespectAspectFromRect1:CGRectMake(0, 0, self.image.image.size.width, self.image.image.size.height) toRect2:self.image.frame];
    self.pointsView = [[JBCroppableView alloc] initWithImageView:self.image];
    
//    [self.pointsView addPointsAt:@[[NSValue valueWithCGPoint:CGPointMake(10, 10)],
//                                    [NSValue valueWithCGPoint:CGPointMake(50, 10)],
//                                    [NSValue valueWithCGPoint:CGPointMake(50, 50)],
//                                    [NSValue valueWithCGPoint:CGPointMake(10, 50)]]];
    
    [self.pointsView addPoints:9];
    
    [self.view addSubview:self.pointsView];
    [self.view bringSubviewToFront:self.cropButton];
    [self.view bringSubviewToFront:self.undoButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)cropTapped:(id)sender
{
    self.image.image = [self.pointsView deleteBackgroundOfImage:self.image];
    
}

- (IBAction)undoTapped:(id)sender
{
    self.image.image = [UIImage imageNamed:@"IMG_0152.JPG"];
}

@end
