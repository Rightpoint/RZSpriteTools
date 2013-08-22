//
//  NSBezierPath+Export.h
//  RZPathExporter
//
//  Created by Rob Visentin on 8/22/13.
//  Copyright (c) 2013 Rob Visentin. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSBezierPath (Export)

/** A list of all points in the path.
    Results are undefined on unflattened paths.
    @return an array of NSValues containing the NSPoints representing the path.
 **/
- (NSArray *)allPoints;

@end
