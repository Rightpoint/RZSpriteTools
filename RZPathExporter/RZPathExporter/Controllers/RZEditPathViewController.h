//
//  RZEditPathViewController.h
//  RZPathExporter
//
//  Created by Rob Visentin on 8/9/13.
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RZDrawPathView.h"
#import "RZZoomingScrollView.h"
#import "NSImage+BestFitGeometry.h"

typedef enum
{
    RZPathEditorFitTypeNone,
    RZPathEditorFitTypeCurrent,
    RZPathEditorFitTypeSquare,
    RZPathEditorFitTypeCircle,
    RZPathEditorFitTypeCapsule
} RZPathEditorFitType;

@interface RZEditPathViewController : NSViewController <RZZoomingScrollViewDelegate>

@property (nonatomic, weak) IBOutlet NSImageView *imageView;
@property (nonatomic, weak) IBOutlet RZDrawPathView *pathView;
@property (nonatomic, weak) IBOutlet RZZoomingScrollView *scrollView;
@property (nonatomic, assign) RZEstimationStyle estimationStyle;
@property (nonatomic, assign) RZPathEditorFitType fitType;
@property (nonatomic, assign) float alphaThreshold;

- (CGPoint)imageOrigin;

- (void)closePath;
- (void)resetPath;
- (void)fitCircle;
- (void)fitSquare;
- (void)fitCapsule;
- (void)fitCurrent;
- (void)flattenToVertexCount:(NSUInteger)vetices;

@end
