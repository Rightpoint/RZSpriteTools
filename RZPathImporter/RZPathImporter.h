//
//  RZPathImporter.h
//
//  Created by Rob Visentin on 8/22/13.
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//

#import <Foundation/Foundation.h>

// convenience constants
#define kRZFileTypePath     @"path"
#define kRZFileTypePlist    @"plist"
#define kRZFileTypeBody     @"body"

@interface RZPathImporter : NSObject

/** Creates a CGPathRef from a property list of points. 
    Assumes each point is a vertex with lines between each point.
    @param plistName name of file in the main bundle
    @return a newly created CGPathRef. Caller is responsible for releasing it.
 **/
+ (CGPathRef)createCGPathFromPropertyListNamed:(NSString *)plistName;

/** Creates a CGMutablePathRef from a property list of points.
 Assumes each point is a vertex with lines between each point.
 @param plistName name of file in the main bundle
 @return a newly created CGMutablePathRef. Caller is responsible for releasing it.
 **/
+ (CGMutablePathRef)createMutableCGPathFromPropertyListNamed:(NSString *)plistName;

#if TARGET_OS_IPHONE
/** Creates a UIBezierPath from a file.
 @param fileName name of file in the main bundle
 @param type the file's extension
 @return a newly created UIBezierPath.
 **/
+ (UIBezierPath *)bezierPathFromFileNamed:(NSString *)fileName fileType:(NSString *)type;

#else

/** Creates an NSBezierPath from a file.
 @param fileName name of file in the main bundle
 @param type the file's extension
 @return a newly created NSBezierPath.
 **/
+ (NSBezierPath *)bezierPathFromFileNamed:(NSString *)fileName fileType:(NSString *)type;
#endif

@end


// helpers for NSBezierPath on mac, which unlike UIBezierPath doesn't have these built in
#if !TARGET_OS_IPHONE
@interface NSBezierPath (CGPathHelper)
+ (NSBezierPath *)rz_bezierPathWithCGPath:(CGPathRef)CGPath;
- (CGPathRef)rz_CGPath;
@end
#endif
