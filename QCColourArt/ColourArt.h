//
//  ColourArt.h
//  QCColourArt
//
//  Created by Jonathan Hammond on 09/04/2013.
//  Copyright (c) 2013 Jonathan Hammond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import <tgmath.h>

@interface ColourArt : NSObject

@property (nonatomic,strong) NSImage* image;

@property(nonatomic,strong)NSColor* primaryColor;
@property(nonatomic,strong)NSColor* secondaryColor;
@property(nonatomic,strong)NSColor* detailColor;
@property(nonatomic,strong)NSColor* backgroundColor;


- (void)analizeImage:(NSImage*)anImage;

@end


@interface NSColor (DarkAddition)

- (BOOL)pc_isDarkColor;
- (BOOL)pc_isDistinct:(NSColor*)compareColor;
- (NSColor*)pc_colorWithMinimumSaturation:(CGFloat)saturation;
- (BOOL)pc_isBlackOrWhite;
- (BOOL)pc_isContrastingColor:(NSColor*)color;

@end


@interface PCCountedColor : NSObject

@property (assign) NSUInteger count;
@property (retain) NSColor *color;

- (id)initWithColor:(NSColor*)color count:(NSUInteger)count;

@end
