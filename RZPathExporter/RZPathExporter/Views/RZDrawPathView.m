//
//  RZDrawPathView.m
//  RZPathExporter
//
//  Created by Rob Visentin on 8/9/13.
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//

#import "RZDrawPathView.h"

@implementation RZDrawPathView

@synthesize path = _path;

- (NSBezierPath *)path
{
    if (!_path)
    {
        _path = [NSBezierPath bezierPath];
    }
    return _path;
}

- (void)setPath:(NSBezierPath *)path
{
    _path = path;
    [self setNeedsDisplay:YES];
}

- (void)resetPath
{
    [self.path removeAllPoints];
    [self setNeedsDisplay:YES];
}

- (void)closePath
{
    [self.path closePath];
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect
{
    [[NSColor redColor] setStroke];
    
    [self.path stroke];
}

#pragma mark - event handling

- (void)mouseUp:(NSEvent *)theEvent
{
    NSPoint loc = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    
    if ([self.path isEmpty])
    {
        [self.path moveToPoint:loc];
    }
    else
    {
        [self.path lineToPoint:loc];
    }
    
    [self setNeedsDisplay:YES];
}

@end
