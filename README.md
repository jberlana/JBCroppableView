JBCroppableImageView
====================

JBCroppableImageView is a subclass of UIImageView built with UIKit and
CoreGraphics that adds n points on an image allowing to modify them by drag &
drop to trim the extra space of an image.

Features 
-------------------------------------------------

* Add an NSArray of specific CGPoints to a UIImageView. * Add a specific number of points. * Drag&Drop of the points. * Crops the UIImage in a UIImageView. * Respects aspect ratio. * ARC(Automatic Reference Counting) support.


Installation
-------------------------------------------------

 * Drag the *JBCroppableImageView*/*JBCroppableLayer* files into your project. * Add the CoreGraphics framework to your project.

Usage (see example Xcode project in /TestCroping)
-------------------------------------------------

to set up, initialize how you would a reular UIImageView:

<code>-JBCroppableImageView *cropView = [[JBCroppableImageView alloc]
initWithImage:[UIImage imageNamed:”demo”]];</code>

it will be initialized with four crop points. To add or subtract the number of
points:

<code>[cropView addPoint];</code>
<code>[cropView removePoint];</code>


to crop the imageView to the requested shape or to revert back to uncropped
state:

<code>[cropView crop];</code>
<code>[cropView reverseCrop];</code>


to retrieve the cropped image:

<code>[cropView getCroppedImage];</code>
<code>[cropView getCroppedImageWithTransparentBorder:YES];</code>


*the image property of JBCroppableImageView remains as the original image


Demo
----

![image](<https://github.com/jberlana/JBCroppableView/raw/master/demo.png>)

Credit Javier Berlana, [Mobile One2One](<http://www.mo2o.com/>)
---------------------------------------------------------------
