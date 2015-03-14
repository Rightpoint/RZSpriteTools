//
//  RZZoomingScrollView.m
//  RZPathExporter
//
//  Created by Rob Visentin on 8/9/13.
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//

#import "RZZoomingScrollView.h"

@implementation RZZoomingScrollView

- (void)scrollWheel:(NSEvent *)theEvent
{
    CGFloat scale = [theEvent scrollingDeltaY] < 0 ? 0.95f : 1.05f;
    [self setMagnification:self.magnification*scale];
  
    [self.horizontalScroller setHidden:(self.contentView.bounds.size.width > self.bounds.size.width)];
    [self.verticalScroller setHidden:(self.contentView.bounds.size.height > self.bounds.size.height)];
    
    [self.delegate scrollViewDidZoom:self];
}

@end
