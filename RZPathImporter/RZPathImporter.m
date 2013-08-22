//
//  RZPathImporter.m
//
//  Created by Rob Visentin on 8/22/13.
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//

#import "RZPathImporter.h"

@interface RZPathImporter ()

+ (NSString *)pathForFileNamed:(NSString *)fileName fileType:(NSString *)fileType;
+ (id)createPathRefFromPropertyListNamed:(NSString *)plistName mutability:(BOOL)isMutable;

@end

@implementation RZPathImporter

+ (CGPathRef)createCGPathFromPropertyListNamed:(NSString *)plistName
{
    return (__bridge CGPathRef)([self createPathRefFromPropertyListNamed:plistName mutability:NO]);
}

+ (CGMutablePathRef)createMutableCGPathFromPropertyListNamed:(NSString *)plistName
{
    return (__bridge CGMutablePathRef)([self createPathRefFromPropertyListNamed:plistName mutability:YES]);
}

#if TARGET_OS_IPHONE
+ (UIBezierPath *)bezierPathFromFileNamed:(NSString *)fileName fileType:(NSString *)type
{
    UIBezierPath *bezierPath = nil;
    
    if ([type isEqualToString:kRZFileTypePlist])
    {
        CGPathRef pathRef = [self createCGPathFromPropertyListNamed:fileName];
        if (pathRef != NULL)
        {
            bezierPath = [UIBezierPath bezierPathWithCGPath:pathRef];
            CGPathRelease(pathRef);
        }
    }
    else
    {
        // try to unarchive the file (it might be an encoded path)
        NSString *filePath = [RZPathImporter pathForFileNamed:fileName fileType:type];
        id unarchive = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        
        if ([unarchive isKindOfClass:[UIBezierPath class]])
        {
            bezierPath = unarchive;
        }
    }
    
    return bezierPath;
}

#else

+ (NSBezierPath *)bezierPathFromFileNamed:(NSString *)fileName fileType:(NSString *)type
{
    NSBezierPath *bezierPath = nil;
    
    if ([type isEqualToString:kRZFileTypePlist])
    {
        CGPathRef pathRef = [self createCGPathFromPropertyListNamed:fileName];
        if (pathRef != NULL)
        {
            bezierPath = [NSBezierPath rz_bezierPathWithCGPath:pathRef];
            CGPathRelease(pathRef);
        }
    }
    else
    {
        // try to unarchive the file (it might be an encoded path)
        NSString *filePath = [RZPathImporter pathForFileNamed:fileName fileType:type];
        id unarchive = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        
        if ([unarchive isKindOfClass:[NSBezierPath class]])
        {
            bezierPath = unarchive;
        }
    }
    
    return bezierPath;
}
#endif

#pragma mark - private interface

+ (NSString *)pathForFileNamed:(NSString *)fileName fileType:(NSString *)fileType
{
    return [[NSBundle mainBundle] pathForResource:fileName ofType:fileType];
}

+ (id)createPathRefFromPropertyListNamed:(NSString *)plistName mutability:(BOOL)isMutable
{
    NSString *filePath = [RZPathImporter pathForFileNamed:plistName fileType:kRZFileTypePlist];
    
    NSArray *pointStrings = [NSArray arrayWithContentsOfFile:filePath];
    
    CGMutablePathRef path = NULL;
    
    if (pointStrings)
    {
        path = CGPathCreateMutable();
        
        [pointStrings enumerateObjectsUsingBlock:^(id pString, NSUInteger idx, BOOL *stop) {
            if ([pString isKindOfClass:[NSString class]])
            {
#if TARGET_OS_IPHONE
                CGPoint point = CGPointFromString(pString);
#else
                NSPoint point = NSPointFromString(pString);
#endif
                if (CGPathIsEmpty(path))
                {
                    CGPathMoveToPoint(path, NULL, point.x, point.y);
                }
                else
                {
                    CGPathAddLineToPoint(path, NULL, point.x, point.y);
                }
            }
        }];
        CGPathCloseSubpath(path);
    }
    
    if (isMutable)
    {
        return (__bridge id)(path);
    }
    else
    {
        CGPathRef immutablePath = CGPathCreateCopy(path);
        CGPathRelease(path);
        return (__bridge id)(immutablePath);
    }
}

@end

#if !TARGET_OS_IPHONE
@implementation NSBezierPath (CGPathHelper)

+ (NSBezierPath *)rz_bezierPathWithCGPath:(CGPathRef)CGPath
{
    NSBezierPath *bezierPath = [NSBezierPath bezierPath];
    
    CGPathApply(CGPath, (__bridge void *)(bezierPath), CGPathApplier);
    
    return bezierPath;
}

- (CGPathRef)rz_CGPath
{
    CGPathRef path = NULL;
    
    NSInteger elementCount = [self elementCount];
    
    if (elementCount > 0)
    {
        CGMutablePathRef mutablePath = CGPathCreateMutable();
        NSPoint points[3];
        BOOL didClosePath = YES;
        
        for (int i = 0; i < elementCount; i++)
        {
            switch ([self elementAtIndex:i associatedPoints:points])
            {
                case NSMoveToBezierPathElement:
                    CGPathMoveToPoint(mutablePath, NULL, points[0].x, points[0].y);
                    break;
                    
                case NSLineToBezierPathElement:
                    CGPathAddLineToPoint(mutablePath, NULL, points[0].x, points[0].y);
                    didClosePath = NO;
                    break;
                    
                case NSCurveToBezierPathElement:
                    CGPathAddCurveToPoint(mutablePath, NULL, points[0].x, points[0].y,
                                          points[1].x, points[1].y,
                                          points[2].x, points[2].y);
                    didClosePath = NO;
                    break;
                    
                case NSClosePathBezierPathElement:
                    CGPathCloseSubpath(mutablePath);
                    didClosePath = YES;
                    break;
            }
        }
        
        // Be sure the path is closed or Quartz may not do valid hit detection.
        if (!didClosePath)
        {
            CGPathCloseSubpath(mutablePath);
        }
        
        path = CGPathCreateCopy(mutablePath);
        CGPathRelease(mutablePath);
    }
    
    return path;
}

//! private helper to convert CGPath to NSBezierPath
void CGPathApplier(void *info, const CGPathElement *element)
{
    NSBezierPath *bezierPath = (__bridge NSBezierPath *)info;
    
    switch (element->type)
    {
        case kCGPathElementMoveToPoint:
            [bezierPath moveToPoint:NSMakePoint(element->points[0].x, element->points[0].y)];
            break;
            
        case kCGPathElementAddLineToPoint:
            [bezierPath lineToPoint:NSMakePoint(element->points[0].x, element->points[0].y)];
            break;
            
        case kCGPathElementAddQuadCurveToPoint:
        {
            NSPoint quadStart = [bezierPath currentPoint];
            NSPoint quadControl = NSMakePoint(element->points[0].x, element->points[0].y);
            NSPoint quadEnd = NSMakePoint(element->points[1].x, element->points[1].y);
            
            NSPoint cubicControl1 = NSMakePoint(quadStart.x + 2*(quadControl.x-quadStart.x)/3, quadStart.y + 2*(quadControl.y-quadStart.y)/3);
            NSPoint cubicControl2 = NSMakePoint(quadEnd.x + 2*(quadControl.x-quadEnd.x)/3, quadEnd.y + 2*(quadControl.y-quadEnd.y)/3);
            
            [bezierPath curveToPoint:quadEnd controlPoint1:cubicControl1 controlPoint2:cubicControl2];
            break;
        }
            
        case kCGPathElementAddCurveToPoint:
            [bezierPath curveToPoint:NSMakePoint(element->points[2].x, element->points[2].y)
                       controlPoint1:NSMakePoint(element->points[0].x, element->points[0].y)
                       controlPoint2:NSMakePoint(element->points[1].x, element->points[1].y)];
            break;
             
        case kCGPathElementCloseSubpath:
             [bezierPath closePath];
              break;
            
        default:
            break;
    }
}

@end
#endif
