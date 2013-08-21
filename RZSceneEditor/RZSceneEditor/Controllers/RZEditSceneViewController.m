//
//  RZEditSceneViewController.m
//  RZSceneEditor
//
//  Created by Rob Visentin on 8/7/13.
//  Copyright (c) 2013 Rob Visentin. All rights reserved.
//

#import "RZEditSceneViewController.h"
#import "RZSpriteCollectionViewItem.h"
#import "RZSceneManager.h"

@interface RZEditSceneViewController ()

@property (nonatomic, weak) IBOutlet NSScrollView *scrollView;

@property (nonatomic, strong) RZSceneManager *sceneManager;

- (void)setup;

@end

@implementation RZEditSceneViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (void)setup
{
    self.sceneManager = [RZSceneManager defaultManager];
    self.fetchedSprites = [self.sceneManager fetchedSprites];
    
//    [self.sceneManager addSpriteWithName:@"Hammer" imageName:@"hammer"];
//    sleep(1);
//    [self.sceneManager addSpriteWithName:@"Raizlabs" imageName:@"raizlabs"];
    
    self.collectionView.minItemSize = [RZSpriteCollectionViewItem defaultSize];
    self.collectionView.maxItemSize = [RZSpriteCollectionViewItem defaultSize];
    [self.collectionView bind:NSContentBinding toObject:self.fetchedSprites withKeyPath:@"arrangedObjects" options:0];
}

#pragma mark - NSCollectionViewDelegate

- (NSImage *)collectionView:(NSCollectionView *)collectionView draggingImageForItemsAtIndexes:(NSIndexSet *)indexes withEvent:(NSEvent *)event offset:(NSPointPointer)dragImageOffset
{
    RZSprite *sprite = [collectionView.content objectAtIndex:[indexes firstIndex]];
    return [NSImage imageNamed:sprite.imageName];
}

- (BOOL)collectionView:(NSCollectionView *)collectionView writeItemsAtIndexes:(NSIndexSet *)indexes toPasteboard:(NSPasteboard *)pasteboard
{
    return YES;
}

@end
