//
//  NSImage+bitmapRep.m
//  QCColourArt
//
//  Created by Jonathan Hammond on 09/04/2013.
//  Copyright (c) 2013 Jonathan Hammond. All rights reserved.
//

#import "NSImage+bitmapRep.h"

@implementation NSImage (bitmapRep)


- (NSBitmapImageRep *)bitmapImageRepresentation {
    int width = [self size].width;
    int height = [self size].height;
    
    if(width < 1 || height < 1)
        return nil;
    
    NSBitmapImageRep *rep = [[NSBitmapImageRep alloc]
                             initWithBitmapDataPlanes: NULL
                             pixelsWide: width
                             pixelsHigh: height
                             bitsPerSample: 8
                             samplesPerPixel: 4
                             hasAlpha: YES
                             isPlanar: NO
                             colorSpaceName: NSDeviceRGBColorSpace
                             bytesPerRow: width * 4
                             bitsPerPixel: 32];
    
    NSGraphicsContext *ctx = [NSGraphicsContext graphicsContextWithBitmapImageRep: rep];
    [NSGraphicsContext saveGraphicsState];
    [NSGraphicsContext setCurrentContext: ctx];
    [self drawAtPoint: NSZeroPoint fromRect: NSZeroRect operation: NSCompositeCopy fraction: 1.0];
    [ctx flushGraphics];
    [NSGraphicsContext restoreGraphicsState];
    
    return rep;
}
@end
