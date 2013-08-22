//
//  NSImage+BestFitGeometry.m
//  RZPathExporter
//
//  Created by Rob Visentin on 8/9/13.
//  Copyright (c) 2013 Rob Visentin. All rights reserved.
//

#import "NSImage+BestFitGeometry.h"

@implementation NSImage (BestFitGeometry)

- (CGRect)bestFitSquareWithTreshold:(CGFloat)alphaThreshold estimationStyle:(RZEstimationStyle)estimationStyle
{
    CGRect boundingRect = [self boundingRectWithThreshold:alphaThreshold];
    CGPoint center = CGPointMake(boundingRect.origin.x + 0.5*boundingRect.size.width, boundingRect.origin.y + 0.5*boundingRect.size.height);
    
    CGFloat sideLength = (estimationStyle == RZEstimationStyleOver) ? fmaxf(boundingRect.size.width, boundingRect.size.height) : fminf(boundingRect.size.width, boundingRect.size.height);
    
    return CGRectMake(center.x - 0.5*sideLength, center.y - 0.5*sideLength, sideLength, sideLength);
}

- (CGRect)boundingRectWithThreshold:(CGFloat)alphaThreshold
{
    UInt8 thresh = (UInt8)(255*alphaThreshold);
    CGImageRef image = [self CGImageForProposedRect:NULL context:nil hints:nil];
    
    size_t width = CGImageGetWidth(image);
    size_t height = CGImageGetHeight(image);
    
    size_t bytesPerPixel = 4;
    size_t bytesPerRow = bytesPerPixel * width;
    size_t bitsPerComponent = 8;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    uint8 *data = (uint8*)calloc(width * height * bytesPerPixel, sizeof(uint8));

    CGContextRef context = CGBitmapContextCreate(data, width, height, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), image);
    CGContextRelease(context);
    
    int startX = (int)width;
    int endX = 0;
    int startY = (int)height;
    int endY = 0;
    
    for (int y = 0; y < height; y++)
    {
        for (int x = 0; x < width; x++)
        {
            size_t index = ((width * y) + x) * bytesPerPixel;
            UInt8 alpha = (UInt8)data[index+3];
            BOOL pastThreshold = (alpha >= thresh);
                                    
            if (pastThreshold)
            {
                startX = MIN(startX, x);
                endX = MAX(endX, x+1);
            }
        }
    }
    
    for (int x = 0; x < width; x++)
    {
        for (size_t y = 0; y < height; y++)
        {
            size_t index = ((height * x) + y) * bytesPerPixel;
            UInt8 alpha = (UInt8)data[index+(bytesPerPixel-1)];
            BOOL pastThreshold = (alpha >= thresh);
                        
            if (pastThreshold)
            {
                startY = MIN(startY, x);
                endY = MAX(endY, x+1);
            }
        }
    }
    
    CGRect boundingRect = CGRectMake(startX, startY, endX - startX, endY - startY);
        
    free(data);
    
    return boundingRect;
}

@end
