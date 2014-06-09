//
//  QCColourArtPlugIn.h
//  QCColourArt
//
//  Created by Chris Birch on 09/04/2013.
//  Copyright (c) 2013 Chris Birch. All rights reserved.
//

#import <Quartz/Quartz.h>

//Port Defines

//Colour describing the Background colour found in the image
#define OUTPUT_BACKGROUNDCOLOUR @"outputBackgroundColour"
//Colour describing the primary colour found in the image
#define OUTPUT_PRIMARYCOLOR @"outputPrimaryColor"
//Colour describing the secondary colour found in the image
#define OUTPUT_SECONDARYCOLOR @"outputSecondaryColor"
//Colour describing the Detail colour found in the image
#define OUTPUT_DETAILCOLOUR @"outputDetailColour"
//The image to analyse
#define INPUT_IMAGESOURCE @"inputImageSource"

@interface QCColourArtPlugIn : QCPlugIn

//Port Properties
@property (assign) CGColorRef outputBackgroundColour;
@property (assign) CGColorRef outputPrimaryColor;
@property (assign) CGColorRef outputSecondaryColor;
@property (assign) CGColorRef outputDetailColor;
@property (assign) id<QCPlugInInputImageSource> inputImageSource;



// Declare here the properties to be used as input and output ports for the plug-in e.g.
//@property double inputFoo;
//@property (copy) NSString* outputBar;

@end
