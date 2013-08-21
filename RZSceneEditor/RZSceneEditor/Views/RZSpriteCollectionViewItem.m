//
//  RZSpriteCollectionViewItem.m
//  RZSceneEditor
//
//  Created by Rob Visentin on 8/7/13.
//  Copyright (c) 2013 Rob Visentin. All rights reserved.
//

#import "RZSpriteCollectionViewItem.h"
#import "RZSprite.h"
#import "RZCoreDataManager.h"

@interface RZSpriteCollectionViewItem ()

- (void)updateUI;

@end

@implementation RZSpriteCollectionViewItem

+ (CGSize)defaultSize
{
    return CGSizeMake(185.0f, 185.0f);
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self updateUI];
}

- (void)setRepresentedObject:(id)representedObject
{
    [super setRepresentedObject:representedObject];
    
    [self updateUI];
}

- (void)setSprite:(RZSprite *)sprite
{
    self.representedObject = sprite;
}

- (RZSprite *)sprite
{
    if ([self.representedObject isKindOfClass:[RZSprite class]])
    {
        return (RZSprite *)self.representedObject;
    }
    else
    {
        return nil;
    }
}

- (void)updateUI
{
    if ([self.representedObject isKindOfClass:[RZSprite class]])
    {
        [self.imageView setImage:[NSImage imageNamed:[self.representedObject imageName]]];
        [self.textField setStringValue:[self.representedObject name]];
    }
}

#pragma mark - NSTextFieldDelegate

- (void)controlTextDidChange:(NSNotification *)obj
{
    if (obj.object == self.textField)
    {
        self.sprite.name = self.textField.stringValue;
        [[RZCoreDataManager defaultManager] saveData:NO];
    }
}

@end
