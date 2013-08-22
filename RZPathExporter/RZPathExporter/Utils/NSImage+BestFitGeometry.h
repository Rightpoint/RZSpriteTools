//
//  NSImage+BestFitGeometry.h
//  RZPathExporter
//
//  Created by Rob Visentin on 8/9/13.
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef enum
{
    RZEstimationStyleUnder = 0,
    RZEstimationStyleOver,
} RZEstimationStyle;

@interface NSImage (BestFitGeometry)

- (CGRect)bestFitSquareWithTreshold:(CGFloat)alphaThreshold estimationStyle:(RZEstimationStyle)estimationStyle;
- (CGRect)boundingRectWithThreshold:(CGFloat)alphaThreshold;

@end
