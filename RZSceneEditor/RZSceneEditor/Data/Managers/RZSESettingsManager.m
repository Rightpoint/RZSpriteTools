//
//  RZSESettingsManager.m
//  RZSceneEditor
//
//  Created by Rob Visentin on 8/6/13.
//  Copyright (c) 2013 Rob Visentin. All rights reserved.
//

#import "RZSESettingsManager.h"
#import <objc/runtime.h>

#define kRZSceneEditorImportPathKey     @"import_path"
#define kRZSceneEditorExportPathKey     @"export_path"
#define kRZSceneEditorExternalBundleKey @"external_bundle"

@implementation RZSESettingsManager

static NSBundle *sExternalBundle;
+ (NSBundle *)externalBundle
{
    return sExternalBundle;
}

+ (void)loadExternalBundle
{
    [sExternalBundle unload];
    
    if ([self externalBundlePath])
    {
        sExternalBundle = [NSBundle bundleWithPath:[self externalBundlePath]];
        [sExternalBundle load];
    }
}

+ (NSString *)importPath
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kRZSceneEditorImportPathKey];
}

+ (NSString *)exportPath
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kRZSceneEditorExportPathKey];
}

+ (NSString *)externalBundlePath
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kRZSceneEditorExternalBundleKey];
}

+ (void)setImportPath:(NSString *)importPath
{
    if (importPath)
    {
        [[NSUserDefaults standardUserDefaults] setObject:importPath forKey:kRZSceneEditorImportPathKey];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kRZSceneEditorImportPathKey];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)setExportPath:(NSString *)exportPath
{
    if (exportPath)
    {
        [[NSUserDefaults standardUserDefaults] setObject:exportPath forKey:kRZSceneEditorExportPathKey];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kRZSceneEditorExportPathKey];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)setExternalBundlePath:(NSString *)externalBundlePath
{
    if (externalBundlePath)
    {
        [[NSUserDefaults standardUserDefaults] setObject:externalBundlePath forKey:kRZSceneEditorExternalBundleKey];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kRZSceneEditorExternalBundleKey];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self loadExternalBundle];
}

@end
