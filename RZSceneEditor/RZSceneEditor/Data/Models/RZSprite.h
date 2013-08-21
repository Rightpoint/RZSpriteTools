//
//  RZSprite.h
//  RZSceneEditor
//
//  Created by Rob Visentin on 8/5/13.
//  Copyright (c) 2013 Rob Visentin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface RZSprite : NSManagedObject

@property (nonatomic, retain) NSString * imageName;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * uid;

@end
