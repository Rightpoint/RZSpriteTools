//
//  NSBezierPath+Export.m
//  RZPathExporter
//
//  Created by Rob Visentin on 8/22/13.
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//

#import "NSBezierPath+Export.h"

@implementation NSBezierPath (Export)

- (NSArray *)allPoints
{
    NSInteger elementCount = [self elementCount];
    NSMutableArray *pointsArray = [NSMutableArray arrayWithCapacity:elementCount];
    
    NSPoint currentPoint;
    
    for (NSInteger i = 0; i < elementCount; i++)
    {
        NSBezierPathElement pathElement = [self elementAtIndex:i associatedPoints:&currentPoint];
        
        if (pathElement == NSMoveToBezierPathElement || pathElement == NSLineToBezierPathElement)
        {
            [pointsArray addObject:[NSValue valueWithPoint:currentPoint]];
        }
    }
    
    return [pointsArray copy];
}

@end
