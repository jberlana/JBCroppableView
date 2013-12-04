//
//  ViewController.h
//  TestCroping
//
//  Created by Javier Berlana on 20/12/12.
//  Copyright (c) 2012 Mobile one2one. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JBCroppableImageView;
@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *cropButton;
@property (weak, nonatomic) IBOutlet UIButton *undoButton;
@property (weak, nonatomic) IBOutlet JBCroppableImageView  *image;

- (IBAction)cropTapped:(id)sender;
- (IBAction)undoTapped:(id)sender;
- (IBAction)subtractTapped:(id)sender;
- (IBAction)addTapped:(id)sender;

@end
