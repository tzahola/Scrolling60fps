//
//  SettingsViewController.m
//  Scrolling60fps
//
//  Created by Tamás Zahola on 15/02/16.
//  Copyright © 2016 Tamás Zahola. All rights reserved.
//

#import "SettingsViewController.h"

#import "Settings.h"

@interface SettingsViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *imageTypeSegmentedControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *imageRendererSegmentedControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *textRendererSegmentedControl;
@property (weak, nonatomic) IBOutlet UISwitch *immediateImageCacheingSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *caLayerMaskingSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *caLayerCornerAndShadowSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *backgroundLayerRasterizationSwitch;

@end

@implementation SettingsViewController

- (instancetype)init {
    return [self initWithNibName:NSStringFromClass([self class]) bundle:[NSBundle bundleForClass:[self class]]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    Settings* settings = [Settings settings];
    self.imageTypeSegmentedControl.selectedSegmentIndex = settings.imageType == ImageTypeJpeg ? 0 : 1;
    self.imageRendererSegmentedControl.selectedSegmentIndex = settings.imageRenderer == ImageRendererUIImageView ? 0 : 1;
    self.textRendererSegmentedControl.selectedSegmentIndex = settings.textRenderer == TextRendererUILabel ? 0 : 1;
    self.immediateImageCacheingSwitch.on = settings.cacheImagesImmediately;
    self.caLayerMaskingSwitch.on = settings.useCALayerMasking;
    self.caLayerCornerAndShadowSwitch.on = settings.useCALayerCornerAndShadow;
    self.backgroundLayerRasterizationSwitch.on = settings.rasterizeBackgroundLayer;
}

- (IBAction)didPressDoneButton:(id)sender {
    Settings* settings = [Settings settings];
    settings.imageType = self.imageTypeSegmentedControl.selectedSegmentIndex == 0 ? ImageTypeJpeg : ImageTypePNG;
    settings.imageRenderer = self.imageRendererSegmentedControl.selectedSegmentIndex == 0 ? ImageRendererUIImageView : ImageRendererCALayer;
    settings.textRenderer = self.textRendererSegmentedControl.selectedSegmentIndex == 0 ? TextRendererUILabel : TextRendererCATextLayer;
    settings.cacheImagesImmediately = self.immediateImageCacheingSwitch.on;
    settings.useCALayerMasking = self.caLayerMaskingSwitch.on;
    settings.useCALayerCornerAndShadow = self.caLayerCornerAndShadowSwitch.on;
    settings.rasterizeBackgroundLayer = self.backgroundLayerRasterizationSwitch.on;
    
    [self.delegate settingsViewControllerDidFinish:self];
}

@end
