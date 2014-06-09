//
//  QCColourArtPlugIn.m
//  QCColourArt
//
//  Created by Chris Birch on 09/04/2013.
//  Copyright (c) 2013 Chris Birch. All rights reserved.
//

// It's highly recommended to use CGL macros instead of changing the current context for plug-ins that perform OpenGL rendering
#import <OpenGL/CGLMacro.h>
#import "QCColourArtPlugIn.h"
#import "ColourArt.h"


#define	kQCPlugIn_Name				@"Colour Art"
#define	kQCPlugIn_Description		@"ColourArt description"
#import <AppKit/AppKit.h>

@interface NSColor (CGColor)

//
// The Quartz color reference that corresponds to the receiver's color.
//
@property (nonatomic, readonly) CGColorRef CGColor;

//
// Converts a Quartz color reference to its NSColor equivalent.
//
+ (NSColor *)colorWithCGColor:(CGColorRef)color;

@end
@interface QCColourArtPlugIn ()
{
    ColourArt* colourArt;
    BOOL busy;
    BOOL ready;
    
    id<QCPlugInInputImageSource>image;
    
    CGColorRef background,primary,secondary,detail;
    CGColorSpaceRef colourSpace;
    NSString* pixelFormat;
    
}

@end
@implementation QCColourArtPlugIn

//Port Synthesizes

@dynamic outputBackgroundColour;
@dynamic outputPrimaryColor;
@dynamic outputSecondaryColor;
@dynamic outputDetailColor;
@dynamic inputImageSource;



// Here you need to declare the input / output properties as dynamic as Quartz Composer will handle their implementation
//@dynamic inputFoo, outputBar;

+ (NSDictionary *)attributes
{
	// Return a dictionary of attributes describing the plug-in (QCPlugInAttributeNameKey, QCPlugInAttributeDescriptionKey...).
    return @{QCPlugInAttributeNameKey:kQCPlugIn_Name, QCPlugInAttributeDescriptionKey:kQCPlugIn_Description};
}

+ (NSDictionary *)attributesForPropertyPortWithKey:(NSString *)key
{
    //Port Attributes
    
    //Colour describing the Background colour found in the image
    if([key isEqualToString:OUTPUT_BACKGROUNDCOLOUR])
        return [NSDictionary dictionaryWithObjectsAndKeys:
                @"Background Colour", QCPortAttributeNameKey,
                nil];
    //Colour describing the primary colour found in the image
    else if([key isEqualToString:OUTPUT_PRIMARYCOLOR])
        return [NSDictionary dictionaryWithObjectsAndKeys:
                @"Primary Color", QCPortAttributeNameKey,
                nil];
    //Colour describing the secondary colour found in the image
    else if([key isEqualToString:OUTPUT_SECONDARYCOLOR])
        return [NSDictionary dictionaryWithObjectsAndKeys:
                @"Secondary Color", QCPortAttributeNameKey,
                nil];
    //Colour describing the Detail colour found in the image
    else if([key isEqualToString:OUTPUT_DETAILCOLOUR])
        return [NSDictionary dictionaryWithObjectsAndKeys:
                @"Detail Colour", QCPortAttributeNameKey,
                nil];
    //The image to analyse
    else if([key isEqualToString:INPUT_IMAGESOURCE])
        return [NSDictionary dictionaryWithObjectsAndKeys:
                @"Image Source", QCPortAttributeNameKey,
                nil];
    

	// Specify the optional attributes for property based ports (QCPortAttributeNameKey, QCPortAttributeDefaultValueKey...).
	return nil;
}

+ (QCPlugInExecutionMode)executionMode
{
	// Return the execution mode of the plug-in: kQCPlugInExecutionModeProvider, kQCPlugInExecutionModeProcessor, or kQCPlugInExecutionModeConsumer.
	return kQCPlugInExecutionModeProcessor;
}

+ (QCPlugInTimeMode)timeMode
{
	// Return the time dependency mode of the plug-in: kQCPlugInTimeModeNone, kQCPlugInTimeModeIdle or kQCPlugInTimeModeTimeBase.
	return kQCPlugInTimeModeIdle;
}

- (id)init
{
	self = [super init];
	if (self)
    {
		// Allocate any permanent resource required by the plug-in.
        colourArt = [[ColourArt alloc] init];
	}
	
	return self;
}


@end

@implementation QCColourArtPlugIn (Execution)

- (BOOL)startExecution:(id <QCPlugInContext>)context
{
	// Called by Quartz Composer when rendering of the composition starts: perform any required setup for the plug-in.
	// Return NO in case of fatal failure (this will prevent rendering of the composition to start).
	
    
    
	return YES;
}

- (void)enableExecution:(id <QCPlugInContext>)context
{
	// Called by Quartz Composer when the plug-in instance starts being used by Quartz Composer.
}


-(void)doWorkOnBackgroundThread
{
    CGDataProviderRef				dataProvider;
    CGImageRef						cgImage;
    
    
#if __BIG_ENDIAN__
    pixelFormat = QCPlugInPixelFormatARGB8;
#else
    pixelFormat = QCPlugInPixelFormatBGRA8;
#endif
    
    [image lockBufferRepresentationWithPixelFormat:pixelFormat  colorSpace:colourSpace forBounds:[image imageBounds]];
    
    dataProvider = CGDataProviderCreateWithData(NULL, [image bufferBaseAddress], [image bufferPixelsHigh] * [image bufferBytesPerRow], NULL);
    
    cgImage = CGImageCreate([image bufferPixelsWide], [image bufferPixelsHigh], 8, 32, [image bufferBytesPerRow], colourSpace,  kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Host, dataProvider, NULL, false, kCGRenderingIntentDefault);
    
    CGDataProviderRelease(dataProvider);
    
    if(cgImage == NULL)
    {
        [image unlockBufferRepresentation];
        return;
    }
    
    NSImage* nsImage = [[NSImage alloc] initWithCGImage:cgImage size:[image imageBounds].size];
    
    [image unlockBufferRepresentation];

    
    //now analyse the image
    colourArt.image = nsImage;
    
    if (colourArt.primaryColor)
        primary = [colourArt.primaryColor CGColor];
    
    
    if (colourArt.secondaryColor)
        secondary = [colourArt.secondaryColor CGColor];
    
    
    if (colourArt.detailColor)
        detail = [colourArt.detailColor CGColor];
    
    if (colourArt.backgroundColor)
        background = [colourArt.backgroundColor CGColor];
    
    busy = NO;
    ready = YES;

}


- (BOOL)execute:(id <QCPlugInContext>)context atTime:(NSTimeInterval)time withArguments:(NSDictionary *)arguments
{
	/*
	Called by Quartz Composer whenever the plug-in instance needs to execute.
	Only read from the plug-in inputs and produce a result (by writing to the plug-in outputs or rendering to the destination OpenGL context) within that method and nowhere else.
	Return NO in case of failure during the execution (this will prevent rendering of the current frame to complete).
	
	The OpenGL context for rendering can be accessed and defined for CGL macros using:
	CGLContextObj cgl_ctx = [context CGLContextObj];
	*/
    
    //Port Value Changed code
    
    //The image to analyse
    
        
    
    
    if ([self didValueForInputKeyChange:INPUT_IMAGESOURCE])
    {

       if (!busy)
       {
           
           if ((image=self.inputImageSource))
           {
               primary = nil;
               secondary = nil;
               detail = nil;
               background = nil;
               
               CGColorSpaceModel model = CGColorSpaceGetModel([image imageColorSpace]);
               colourSpace = [context colorSpace];
               colourSpace=  (model == kCGColorSpaceModelRGB) ? [image imageColorSpace] : [context colorSpace];
               
               busy = YES;
               
               //start a new thread
               [self performSelectorInBackground:@selector(doWorkOnBackgroundThread) withObject:nil];
           }
       }
        
    }
    
    if (ready)
    {
        
        if (primary)
            self.outputPrimaryColor = primary;
        
        if (secondary)
            self.outputSecondaryColor = secondary;
        
        if (detail)
            self.outputDetailColor = detail;
        
        if (background)
            self.outputBackgroundColour = background;
        
        ready = NO;
    }
	return YES;
}

- (void)disableExecution:(id <QCPlugInContext>)context
{
	// Called by Quartz Composer when the plug-in instance stops being used by Quartz Composer.
}

- (void)stopExecution:(id <QCPlugInContext>)context
{
	// Called by Quartz Composer when rendering of the composition stops: perform any required cleanup for the plug-in.
}

@end
