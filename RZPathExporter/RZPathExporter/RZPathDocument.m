//
//  RZPathDocument.m
//  RZPathExporter
//
//  Created by Rob Visentin on 8/9/13.
//  Copyright (c) 2013 Rob Visentin. All rights reserved.
//

#import "RZPathDocument.h"
#import "RZEditPathViewController.h"

@implementation RZPathDocument

- (NSString *)windowNibName
{
    return @"RZPathDocument";
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    self.path = self.editPathVC.pathView.path;
    
    CGRect boundingBox = [self.path bounds];
    NSAffineTransform *translate = [NSAffineTransform transform];
    [translate translateXBy:-boundingBox.origin.x yBy:-boundingBox.origin.y];
    
    [self.path transformUsingAffineTransform:translate];
    
    // TODO: proof of concept, REMOVE ASAP
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.path];
    self.editPathVC.pathView.path = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    return [NSKeyedArchiver archivedDataWithRootObject:self.path];
}

- (void)windowControllerDidLoadNib:(NSWindowController *)windowController
{
    [super windowControllerDidLoadNib:windowController];
    self.editPathVC.imageView.image = self.image;
    self.editPathVC.pathView.path = self.path;
}
- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    if ([typeName isEqualToString:@"png"])
    {
        self.image = [[NSImage alloc] initWithData:data];
        return YES;
    }
    else
    {
        *outError = [NSError errorWithDomain:NSCocoaErrorDomain code:NSFileReadUnsupportedSchemeError userInfo:nil];
        return NO;
    }
}

- (BOOL)prepareSavePanel:(NSSavePanel *)savePanel
{
    [savePanel setAllowedFileTypes:@[@"path"]];
    [savePanel setAllowsOtherFileTypes:YES];
    [savePanel setExtensionHidden:NO];
    return YES;
}

@end
