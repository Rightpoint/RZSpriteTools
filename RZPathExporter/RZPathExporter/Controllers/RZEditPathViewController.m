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

#define kRZImageAlphaThreshold 0.1f

@interface RZEditPathViewController ()

@property (nonatomic, weak) IBOutlet NSButton *overButton;
@property (nonatomic, weak) IBOutlet NSButton *underButton;

- (CGRect)bestFitImageSquare;
- (CGRect)boundingImageRect;

@end

@implementation RZEditPathViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.estimationStyle = RZEstimationStyleOver;
}

#pragma mark - public interface

- (void)closePath:(NSButton *)sender
{
    [self.pathView closePath];
}

- (void)resetPath:(NSButton *)sender
{
    [self.pathView resetPath];
}

- (void)fitCircle:(NSButton *)sender
{
    self.pathView.path = [NSBezierPath bezierPathWithOvalInRect:[self bestFitImageSquare]];
}

- (void)fitSquare:(NSButton *)sender
{
    self.pathView.path = [NSBezierPath bezierPathWithRect:[self bestFitImageSquare]];
}

- (void)fitCurrent:(NSButton *)sender
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

#pragma mark - private interface

- (CGRect)bestFitImageSquare
{
    CGPoint imageViewCenter = CGRectGetCenter(self.imageView.frame);
    CGPoint imageOrigin = CGPointMake(imageViewCenter.x - 0.5*self.imageView.image.size.width, imageViewCenter.y - 0.5*self.imageView.image.size.height);
    
    CGRect square = [self.imageView.image bestFitSquareWithTreshold:kRZImageAlphaThreshold estimationStyle:self.estimationStyle];
    square.origin = CGPointMake(imageOrigin.x + square.origin.x, imageOrigin.y + (self.imageView.image.size.height - square.size.height - square.origin.y));
    
    return square;
}

- (CGRect)boundingImageRect
{
    CGPoint imageViewCenter = CGRectGetCenter(self.imageView.frame);
    CGPoint imageOrigin = CGPointMake(imageViewCenter.x - 0.5*self.imageView.image.size.width, imageViewCenter.y - 0.5*self.imageView.image.size.height);
    
    CGRect square = [self.imageView.image boundingRectWithThreshold:kRZImageAlphaThreshold];
    square.origin = CGPointMake(imageOrigin.x + square.origin.x, imageOrigin.y + (self.imageView.image.size.height - square.size.height - square.origin.y));
    
    return square;
}

#pragma mark - RZZoomingScrollViewDelegate

- (void)scrollViewDidZoom:(RZZoomingScrollView *)scrollView
{
    
}

@end
