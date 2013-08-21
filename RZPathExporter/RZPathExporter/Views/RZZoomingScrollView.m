//
//  RZZoomingScrollView.m
//  RZPathExporter
//
//  Created by Rob Visentin on 8/9/13.
//  Copyright (c) 2013 Rob Visentin. All rights reserved.
//

#import "RZZoomingScrollView.h"

@implementation RZZoomingScrollView

- (void)scrollWheel:(NSEvent *)theEvent
{
    CGFloat scale = [theEvent scrollingDeltaY] < 0 ? 1.05f : 0.95f;
    [self setMagnification:self.magnification*scale];
  
    [self.horizontalScroller setHidden:(self.contentView.bounds.size.width > self.bounds.size.width)];
    [self.verticalScroller setHidden:(self.contentView.bounds.size.height > self.bounds.size.height)];
    
    [self.delegate scrollViewDidZoom:self];
}

@end
