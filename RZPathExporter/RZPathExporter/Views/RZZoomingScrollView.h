//
//  RZZoomingScrollView.h
//  RZPathExporter
//
//  Created by Rob Visentin on 8/9/13.
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class RZZoomingScrollView;

@protocol RZZoomingScrollViewDelegate <NSObject>

- (void)scrollViewDidZoom:(RZZoomingScrollView *)scrollView;

@end

@interface RZZoomingScrollView : NSScrollView

@property (nonatomic, weak) IBOutlet id<RZZoomingScrollViewDelegate>delegate;

@end
