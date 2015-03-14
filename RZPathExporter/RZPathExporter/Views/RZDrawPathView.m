//
//  RZDrawPathView.m
//  RZPathExporter
//
//  Created by Rob Visentin on 8/9/13.
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//

#import "RZDrawPathView.h"

@interface RZDrawPathView ()

@property (nonatomic, assign, getter = isDragging) BOOL dragging;

@end

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
    if (self.isDragging)
    {
        self.dragging = NO;
        return;
    }
    
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

- (void)scrollWheel:(NSEvent *)theEvent
{
    [super scrollWheel:theEvent];
    
    CGFloat scale = [theEvent scrollingDeltaY] < 0 ? 0.95f : 1.05f;
    
    NSAffineTransform *transform = [NSAffineTransform transform];
    [transform scaleBy:scale];
    
    [self.path transformUsingAffineTransform:transform];
    [self setNeedsDisplay:YES];
}

- (void)mouseDragged:(NSEvent *)theEvent
{
    self.dragging = YES;
    
    NSAffineTransform *transform = [NSAffineTransform transform];
    [transform translateXBy:[theEvent deltaX] yBy:-[theEvent deltaY]];
    
    [self.path transformUsingAffineTransform:transform];
    [self setNeedsDisplay:YES];
}

@end
