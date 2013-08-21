//
//  RZSpriteCollectionViewItem.h
//  RZSceneEditor
//
//  Created by Rob Visentin on 8/7/13.
//  Copyright (c) 2013 Rob Visentin. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class RZSprite;

@interface RZSpriteCollectionViewItem : NSCollectionViewItem <NSTextFieldDelegate>

@property (nonatomic, strong) RZSprite *sprite;

+ (CGSize)defaultSize;

@end
