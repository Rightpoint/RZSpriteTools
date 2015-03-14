//
//  RZPathDocument.m
//  RZPathExporter
//
//  Created by Rob Visentin on 8/9/13.
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//

#import "RZPathDocument.h"
#import "RZEditPathViewController.h"
#import "NSBezierPath+Export.h"
#import "NSImage+BestFitGeometry.h"

// Hack: must match the titles of the Export As.. menu items in MainMenu.xib
#define kRZPathSaveTypeEncoding @"Encoded Path"
#define kRZPathSaveTypePlist    @"Property List"
#define kRZPathSaveTypeBody     @"SKPhysicsBody"

@interface RZPathDocument ()

@property (nonatomic, copy) NSString *saveType;

- (NSString *)extensionForSaveType:(NSString *)saveType;

@end

@implementation RZPathDocument

- (NSString *)windowNibName
{
    return @"RZPathDocument";
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    self.path = [self.editPathVC.pathView.path copy];
    
    CGPoint imageOrigin = [self.editPathVC imageOrigin];
    imageOrigin.y -= self.image.size.height;
    
    NSAffineTransform *translate = [NSAffineTransform transform];
    [translate translateXBy:-imageOrigin.x - 0.5*self.image.size.width yBy:-imageOrigin.y - 0.5*self.image.size.height];
    
    NSAffineTransform *scale = [NSAffineTransform transform];
    [scale scaleBy:0.5];
    [translate appendTransform:scale];
    
    [self.path transformUsingAffineTransform:translate];
    
    NSData *saveData = nil;
    
    if ([self.saveType isEqualToString:kRZPathSaveTypeEncoding])
    {
        saveData = [NSKeyedArchiver archivedDataWithRootObject:self.path];
    }
    else if ([self.saveType isEqualToString:kRZPathSaveTypePlist])
    {
        self.path = [self.path bezierPathByFlatteningPath];
        NSArray *points = [self.path allPoints];
        NSMutableArray *pointStrings = [NSMutableArray arrayWithCapacity:points.count];
        
        [points enumerateObjectsUsingBlock:^(NSValue *val, NSUInteger idx, BOOL *stop) {
            [pointStrings addObject:NSStringFromPoint([val pointValue])];
        }];
        
        saveData = [NSPropertyListSerialization dataWithPropertyList:pointStrings format:NSPropertyListXMLFormat_v1_0 options:0 error:nil];
    }
    else if ([self.saveType isEqualToString:kRZPathSaveTypeBody])
    {
        // TODO: not yet implemented (coming with mavericks)
    }
    
    return saveData;
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
        NSImage *image = [[NSImage alloc] initWithData:data];
    
        CGImageRef cgImage = [image CGImageForProposedRect:NULL context:nil hints:nil];
        size_t width = CGImageGetWidth(cgImage);
        size_t height = CGImageGetHeight(cgImage);
        
        // resize the image to pixel width and height
        [image setSize:NSSizeFromCGSize(CGSizeMake(width, height))];
        
        self.image = image;
        
        return YES;
    }
    else
    {
        if (outError)
        {
            *outError = [NSError errorWithDomain:NSCocoaErrorDomain code:NSFileReadUnsupportedSchemeError userInfo:nil];
        }
        return NO;
    }
}

- (void)saveDocumentAs:(id)sender
{
    if ([sender isKindOfClass:[NSMenuItem class]])
    {
        self.saveType = [sender title];
    }
    
    [super saveDocumentAs:sender];
}

- (BOOL)prepareSavePanel:(NSSavePanel *)savePanel
{
    [savePanel setAllowedFileTypes:@[[self extensionForSaveType:self.saveType]]];
    [savePanel setAllowsOtherFileTypes:YES];
    [savePanel setExtensionHidden:NO];
    return YES;
}

#pragma mark - private interface

- (NSString *)extensionForSaveType:(NSString *)saveType
{
    NSString *extension = @"";
    
    if ([self.saveType isEqualToString:kRZPathSaveTypeEncoding])
    {
        extension = @"path";
    }
    else if ([self.saveType isEqualToString:kRZPathSaveTypePlist])
    {
        extension = @"plist";
    }
    else if ([self.saveType isEqualToString:kRZPathSaveTypeBody])
    {
        extension = @"body";
    }
    
    return extension;
}

@end
