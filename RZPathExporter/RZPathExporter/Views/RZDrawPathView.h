//
//  RZDrawPathView.h
//  RZPathExporter
//
//  Created by Rob Visentin on 8/9/13.
//  Copyright (c) 2013 Rob Visentin. All rights reserved.
//

@interface RZDrawPathView : NSView

@property (nonatomic, strong) NSBezierPath *path;

- (void)resetPath;
- (void)closePath;

@end
