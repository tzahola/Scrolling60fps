//
//  SettingsViewController.h
//  Scrolling60fps
//
//  Created by Tamás Zahola on 15/02/16.
//  Copyright © 2016 Tamás Zahola. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SettingsViewController;

@protocol SettingsViewControllerDelegate <NSObject>

- (void)settingsViewControllerDidFinish:(SettingsViewController*)settingsViewController;

@end

@interface SettingsViewController : UIViewController

@property (nonatomic, weak) id<SettingsViewControllerDelegate> delegate;

@end
