//
//  RZEditSceneViewController.h
//  RZSceneEditor
//
//  Created by Rob Visentin on 8/7/13.
//  Copyright (c) 2013 Rob Visentin. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface RZEditSceneViewController : NSViewController <NSCollectionViewDelegate>

@property (nonatomic, weak) IBOutlet NSCollectionView *collectionView;
@property (nonatomic, strong) NSArrayController *fetchedSprites;

@end
