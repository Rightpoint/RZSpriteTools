//
//  RZEditPathViewController.m
//  RZPathExporter
//
//  Created by Rob Visentin on 8/9/13.
//  Copyright (c) 2013 Rob Visentin. All rights reserved.
//

#import "RZEditPathViewController.h"
#import "RZPathDocument.h"
#import "GraphicsUtils.h"

@interface RZEditPathViewController ()

@property (nonatomic, weak) IBOutlet NSSlider *alphaSlider;
@property (nonatomic, weak) IBOutlet NSButton *overButton;
@property (nonatomic, weak) IBOutlet NSButton *underButton;

- (IBAction)closePathPressed:(NSButton *)sender;
- (IBAction)resetPathPressed:(NSButton *)sender;
- (IBAction)fitCirclePressed:(NSButton *)sender;
- (IBAction)fitSquarePressed:(NSButton *)sender;
- (IBAction)fitCapsulePressed:(NSButton *)sender;
- (IBAction)fitCurrentPressed:(NSButton *)sender;
- (IBAction)radioButtonPressed:(NSButton *)sender;;

- (IBAction)alphaChanged:(NSSlider *)slider;

- (void)updatePathView;

- (CGRect)bestFitImageSquare;
- (CGRect)boundingImageRect;

@end

@implementation RZEditPathViewController

#pragma mark - public interface

- (void)setEstimationStyle:(RZEstimationStyle)estimationStyle
{
    _estimationStyle = estimationStyle;
    [self updatePathView];
}

- (void)setAlphaThreshold:(float)alphaThreshold
{
    alphaThreshold = fmaxf(self.alphaSlider.minValue, fminf(alphaThreshold, self.alphaSlider.maxValue));
    
    self.alphaSlider.floatValue = alphaThreshold;
    
    [self updatePathView];
}

- (float)alphaThreshold
{
    return self.alphaSlider.floatValue;
}

- (void)closePath
{
    [self.pathView closePath];
}

- (void)resetPath
{
    [self.pathView resetPath];
    self.fitType = RZPathEditorFitTypeCurrent;
}

- (void)fitSquare
{
    self.fitType = RZPathEditorFitTypeSquare;
}

- (void)fitCircle
{
    self.fitType = RZPathEditorFitTypeCircle;
}

- (void)fitCapsule
{
    self.fitType = RZPathEditorFitTypeCapsule;
}

- (void)fitCurrent
{
    self.fitType = RZPathEditorFitTypeCurrent;
}

#pragma mark - private interface

- (void)setFitType:(RZPathEditorFitType)fitType
{
    _fitType = fitType;
    [self updatePathView];
}

- (void)closePathPressed:(NSButton *)sender
{
    [self closePath];
}

- (void)resetPathPressed:(NSButton *)sender
{
    [self resetPath];
}

- (void)fitCirclePressed:(NSButton *)sender
{
    [self fitCircle];
}

- (void)fitSquarePressed:(NSButton *)sender
{
    [self fitSquare];
}

- (void)fitCapsulePressed:(NSButton *)sender
{
    [self fitCapsule];
}

- (void)fitCurrentPressed:(NSButton *)sender
{
    [self fitCurrent];
}

- (void)radioButtonPressed:(NSButton *)sender
{
    if (sender == self.overButton)
    {
        [self.underButton setState:NSOffState];
        self.estimationStyle = RZEstimationStyleOver;
    }
    else if (sender == self.underButton)
    {
        [self.overButton setState:NSOffState];
        self.estimationStyle = RZEstimationStyleUnder;
    }
}

- (void)alphaChanged:(NSSlider *)slider
{
    [self updatePathView];
}

- (void)updatePathView
{
    switch (self.fitType)
    {
        case RZPathEditorFitTypeCurrent:
            if (!self.pathView.path.isEmpty)
            {
                CGRect boundingRect = [self boundingImageRect];
                CGRect pathBox = [self.pathView.path bounds];
                
                CGFloat xRatio = boundingRect.size.width / pathBox.size.width;
                CGFloat yRatio = boundingRect.size.height / pathBox.size.height;
                
                NSAffineTransform *scale = [NSAffineTransform transform];
                [scale scaleXBy:xRatio yBy:yRatio];
                
                CGPoint newOrigin = [scale transformPoint:pathBox.origin];
                
                NSAffineTransform *translate = [NSAffineTransform transform];
                [translate translateXBy:(boundingRect.origin.x - newOrigin.x) yBy:(boundingRect.origin.y - newOrigin.y)];
                
                [scale appendTransform:translate];
                
                self.pathView.path = [scale transformBezierPath:self.pathView.path];
            }
            break;
            
        case RZPathEditorFitTypeSquare:
            self.pathView.path = [NSBezierPath bezierPathWithRect:[self bestFitImageSquare]];
            break;
            
        case RZPathEditorFitTypeCircle:
            self.pathView.path = [NSBezierPath bezierPathWithOvalInRect:[self bestFitImageSquare]];
            break;
            
        case RZPathEditorFitTypeCapsule:
        {
            CGRect boundingRect = [self boundingImageRect];
            
            if (self.estimationStyle == RZEstimationStyleOver)
            {
                CGPoint center = RZRectGetCenter(boundingRect);
                boundingRect.size.height += boundingRect.size.width; // for semi-circles on either end
                boundingRect = RZRectCenterOnPoint(boundingRect, center);
            }
            
            self.pathView.path = [NSBezierPath bezierPathWithRoundedRect:NSRectFromCGRect(boundingRect) xRadius:0.5*boundingRect.size.width yRadius:0.5*boundingRect.size.width];
            break;
        }
            
        default:
            break;
    }
}

- (CGRect)bestFitImageSquare
{
    CGPoint imageViewCenter = RZRectGetCenter(self.imageView.frame);
    CGPoint imageOrigin = CGPointMake(imageViewCenter.x - 0.5*self.imageView.image.size.width, imageViewCenter.y - 0.5*self.imageView.image.size.height);
    
    CGRect square = [self.imageView.image bestFitSquareWithTreshold:self.alphaThreshold estimationStyle:self.estimationStyle];
    square.origin = CGPointMake(imageOrigin.x + square.origin.x, imageOrigin.y + (self.imageView.image.size.height - square.size.height - square.origin.y));
    
    return CGRectIntegral(square);
}

- (CGRect)boundingImageRect
{
    CGPoint imageViewCenter = RZRectGetCenter(self.imageView.frame);
    CGPoint imageOrigin = CGPointMake(imageViewCenter.x - 0.5*self.imageView.image.size.width, imageViewCenter.y - 0.5*self.imageView.image.size.height);
    
    CGRect square = [self.imageView.image boundingRectWithThreshold:self.alphaThreshold];
    square.origin = CGPointMake(imageOrigin.x + square.origin.x, imageOrigin.y + (self.imageView.image.size.height - square.size.height - square.origin.y));
    
    return CGRectIntegral(square);
}

#pragma mark - RZZoomingScrollViewDelegate

- (void)scrollViewDidZoom:(RZZoomingScrollView *)scrollView
{
    
}

@end
