//
//  Settings.h
//  Scrolling60fps
//
//  Created by Tamás Zahola on 15/02/16.
//  Copyright © 2016 Tamás Zahola. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    TextRendererUILabel,
    TextRendererCATextLayer
} TextRenderer;

typedef enum : NSUInteger {
    ImageRendererUIImageView,
    ImageRendererCALayer
} ImageRenderer;

typedef enum : NSUInteger {
    ImageTypeJpeg,
    ImageTypePNG,
} ImageType;

@interface Settings : NSObject

+ (instancetype)settings;

@property (nonatomic, assign) TextRenderer textRenderer;
@property (nonatomic, assign) ImageRenderer imageRenderer;
@property (nonatomic, assign) ImageType imageType;
@property (nonatomic, assign) BOOL cacheImagesImmediately;
@property (nonatomic, assign) BOOL useCALayerCornerAndShadow;
@property (nonatomic, assign) BOOL useCALayerMasking;
@property (nonatomic, assign) BOOL rasterizeBackgroundLayer;

@end
