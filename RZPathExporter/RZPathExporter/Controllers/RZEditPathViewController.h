//
//  RZEditPathViewController.h
//  RZPathExporter
//
//  Created by Rob Visentin on 8/9/13.
//  Copyright (c) 2013 Rob Visentin. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RZDrawPathView.h"
#import "RZZoomingScrollView.h"
#import "NSImage+BestFitGeometry.h"

@interface RZEditPathViewController : NSViewController <RZZoomingScrollViewDelegate>

@property (nonatomic, weak) IBOutlet NSImageView *imageView;
@property (nonatomic, weak) IBOutlet RZDrawPathView *pathView;
@property (nonatomic, weak) IBOutlet RZZoomingScrollView *scrollView;
@property (nonatomic, assign) RZEstimationStyle estimationStyle;

- (IBAction)closePath:(NSButton *)sender;
- (IBAction)resetPath:(NSButton *)sender;
- (IBAction)fitCircle:(NSButton *)sender;
- (IBAction)fitSquare:(NSButton *)sender;
- (IBAction)fitCurrent:(NSButton *)sender;
- (IBAction)radioButtonPressed:(NSButton *)sender;;

@end
