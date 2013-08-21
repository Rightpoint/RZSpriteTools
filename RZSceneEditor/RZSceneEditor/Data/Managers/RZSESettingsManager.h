//
//  RZSESettingsManager.h
//  RZSceneEditor
//
//  Created by Rob Visentin on 8/6/13.
//  Copyright (c) 2013 Rob Visentin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RZSESettingsManager : NSObject

+ (NSBundle *)externalBundle;
+ (void)loadExternalBundle;

+ (NSString *)importPath;
+ (NSString *)exportPath;
+ (NSString *)externalBundlePath;

+ (void)setImportPath:(NSString *)importPath;
+ (void)setExportPath:(NSString *)exportPath;
+ (void)setExternalBundlePath:(NSString *)externalBundlePath; //! also calls loadExternalBundle

@end
