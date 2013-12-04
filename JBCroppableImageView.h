//
//  CropImageView.h
//  Crop Demo
//
//  Created by Daniel Sanche on 12/4/2013.
//  Copyright (c) 2013 Mobile one2one. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JBCroppableImageView : UIImageView

-(void)crop;
-(void)reverseCrop;
-(UIImage *)getCroppedImageWithTransparentBorders:(BOOL)transparent;
-(UIImage *)getCroppedImage;
- (void)addPoint;
- (void)removePoint;
@end
