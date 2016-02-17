//
//  Settings.m
//  Scrolling60fps
//
//  Created by Tamás Zahola on 15/02/16.
//  Copyright © 2016 Tamás Zahola. All rights reserved.
//

#import "Settings.h"

@implementation Settings

+ (instancetype)settings {
    static Settings* settings;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        settings = [Settings new];
        
        settings.textRenderer = TextRendererUILabel;
        settings.imageRenderer = ImageRendererUIImageView;
        settings.imageType = ImageTypePNG;
        settings.cacheImagesImmediately = NO;
        settings.useCALayerCornerAndShadow = YES;
        settings.rasterizeBackgroundLayer = NO;
        settings.useCALayerMasking = YES;
    });
    return settings;
}

@end
