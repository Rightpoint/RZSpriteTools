//
//  RZSceneManager.h
//  RZSceneEditor
//
//  Created by Rob Visentin on 8/6/13.
//  Copyright (c) 2013 Rob Visentin. All rights reserved.
//

#import "RZSprite.h"

@interface RZSceneManager : NSObject

+ (RZSceneManager *)defaultManager;

- (NSArrayController *)fetchedSprites;
- (RZSprite *)spriteWithID:(NSNumber *)uid create:(BOOL)create;
- (RZSprite *)addSpriteWithName:(NSString *)name imageName:(NSString *)imageName;
- (void)removeSprite:(RZSprite *)sprite;

@end
