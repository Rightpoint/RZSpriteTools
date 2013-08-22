//
//  RZPathDocument.h
//  RZPathExporter
//
//  Created by Rob Visentin on 8/9/13.
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class RZEditPathViewController;

@interface RZPathDocument : NSDocument

@property (nonatomic, strong) IBOutlet RZEditPathViewController *editPathVC;

@property (nonatomic, strong) NSBezierPath *path;
@property (nonatomic, strong) NSImage *image;

@end
