//
//  RZPathExporterAppDelegate.m
//  RZPathExporter
//
//  Created by Rob Visentin on 8/9/13.
//  Copyright (c) 2013 Rob Visentin. All rights reserved.
//

#import "RZPathExporterAppDelegate.h"

@implementation RZPathExporterAppDelegate

- (void)awakeFromNib
{
    [super awakeFromNib];
    [NSApp setDelegate:self];
}

- (BOOL)applicationShouldOpenUntitledFile:(NSApplication *)sender
{
    return NO;
}

@end
