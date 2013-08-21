//
//  NSImage+BestFitGeometry.h
//  RZPathExporter
//
//  Created by Rob Visentin on 8/9/13.
//  Copyright (c) 2013 Rob Visentin. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef enum
{
    RZEstimationStyleOver = 1, // default
    RZEstimationStyleUnder,
} RZEstimationStyle;

@interface NSImage (BestFitGeometry)

- (CGRect)bestFitSquareWithTreshold:(CGFloat)alphaThreshold estimationStyle:(RZEstimationStyle)estimationStyle;
- (CGRect)boundingRectWithThreshold:(CGFloat)alphaThreshold;

@end
