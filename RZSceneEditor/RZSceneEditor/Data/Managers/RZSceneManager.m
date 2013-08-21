//
//  RZSceneManager.m
//  RZSceneEditor
//
//  Created by Rob Visentin on 8/6/13.
//  Copyright (c) 2013 Rob Visentin. All rights reserved.
//

#import "RZSceneManager.h"
#import "RZCoreDataManager.h"

@interface RZSceneManager ()

@property (nonatomic, strong) RZCoreDataManager *dataManager;

@end

@implementation RZSceneManager

+ (RZSceneManager *)defaultManager
{
    static RZSceneManager *sDefaultManager = nil;
    static dispatch_once_t defaultOnce;
    dispatch_once(&defaultOnce, ^{
        sDefaultManager = [[RZSceneManager alloc] init];
    });
    
    return sDefaultManager;
}

- (id)init
{
    if ((self = [super init]))
    {
        self.dataManager = [RZCoreDataManager defaultManager];
        self.dataManager.persistentStoreType = NSSQLiteStoreType;
    }
    return self;
}

#pragma mark - public interface

- (NSArrayController *)fetchedSprites
{
    NSArrayController *controller = [[NSArrayController alloc] init];
    [controller setAutomaticallyRearrangesObjects:YES];;
    [controller setEntityName:@"RZSprite"];
    [controller setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"uid" ascending:YES]]];
    [controller setManagedObjectContext:self.dataManager.managedObjectContext];
    [controller fetch:self];    
    
    return controller;
}

- (RZSprite *)spriteWithID:(NSNumber *)uid create:(BOOL)create
{
    return [self.dataManager objectOfType:@"RZSprite" withValue:uid forKeyPath:@"uid" createNew:create];;
}

- (RZSprite *)addSpriteWithName:(NSString *)name imageName:(NSString *)imageName
{
    RZSprite *sprite = [self spriteWithID:@(CFAbsoluteTimeGetCurrent()) create:YES];
    sprite.name = name;
    sprite.imageName = imageName;
    
    [self.dataManager saveData:YES];
    
    return sprite;
}

- (void)removeSprite:(RZSprite *)sprite
{
    [self.dataManager.managedObjectContext deleteObject:sprite];
    [self.dataManager saveData:YES];
}

@end
