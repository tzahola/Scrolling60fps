//
//  CollectionViewController.m
//  Scrolling60fps
//
//  Created by Tamás Zahola on 09/02/16.
//  Copyright © 2016 Tamás Zahola. All rights reserved.
//

#import "CollectionViewController.h"

#import <ImageIO/ImageIO.h>

#import "Data.h"
#import "Settings.h"
#import "SettingsViewController.h"

@interface TextLayerView : UIView

@property (nonatomic, strong, readonly) CATextLayer* textLayer;

@end

@implementation TextLayerView
@dynamic textLayer;

- (CATextLayer *)textLayer {
    return (CATextLayer*)self.layer;
}

+ (Class)layerClass {
    return [CATextLayer class];
}

@end

@interface Cell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *cardBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *cardShadowView;

@property (weak, nonatomic) IBOutlet UIView *imageViewMaskView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *imageLayerView;
@property (weak, nonatomic) IBOutlet UIView *topLeftCornerLayerView;
@property (weak, nonatomic) IBOutlet UIView *topRightCornerLayerView;
@property (weak, nonatomic) IBOutlet TextLayerView *firstNameView;
@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (weak, nonatomic) IBOutlet TextLayerView *lastNameView;
@property (weak, nonatomic) IBOutlet UILabel *lastNameLabel;
@property (weak, nonatomic) IBOutlet TextLayerView *phoneNumberView;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (weak, nonatomic) IBOutlet UIView *backgroundImageLayerView;

@property (nonatomic, strong) Data* data;
@property (nonatomic, assign) NSInteger cellIdentity;

@end

@implementation Cell

- (void)setData:(Data *)data {
    if (_data == data) {
        return;
    }
    _data = data;
    self.cellIdentity++;
    
    if ([Settings settings].textRenderer == TextRendererCATextLayer) {
        self.firstNameView.textLayer.string = data.firstName;
        self.lastNameView.textLayer.string = data.lastName;
        self.phoneNumberView.textLayer.string = data.phoneNumber;
    } else {
        self.firstNameLabel.text = data.firstName;
        self.lastNameLabel.text = data.lastName;
        self.phoneNumberLabel.text = data.phoneNumber;
    }
    
    NSURL* imageURL = [Settings settings].imageType == ImageTypeJpeg ? data.jpgImageURL : data.pngImageURL;
    if (imageURL) {
        NSInteger cellIdentity = self.cellIdentity;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
            CGImageSourceRef source = CGImageSourceCreateWithURL((CFURLRef)imageURL, NULL);
            CGImageRef cgImage = CGImageSourceCreateImageAtIndex(source, 0,
                (CFDictionaryRef)@{
                (NSString*)kCGImageSourceShouldCache : @YES,
                (NSString*)kCGImageSourceShouldCacheImmediately : @([Settings settings].cacheImagesImmediately)
            });
            CFRelease(source);

            UIImage* image = nil;
            if ([Settings settings].imageRenderer == ImageRendererUIImageView) {
                image = [UIImage imageWithCGImage:cgImage];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.cellIdentity == cellIdentity) {
                    if ([Settings settings].imageRenderer == ImageRendererCALayer) {
                        self.imageLayerView.layer.contents = (__bridge id)cgImage;
                    } else {
                        self.imageView.image = image;
                    }
                }
                CGImageRelease(cgImage);
            });
        });
    } else {
        self.imageLayerView.layer.contents = nil;
    }
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.data = nil;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    Settings* settings = [Settings settings];
    
    self.firstNameLabel.hidden = settings.textRenderer != TextRendererUILabel;
    self.lastNameLabel.hidden = settings.textRenderer != TextRendererUILabel;
    self.phoneNumberLabel.hidden = settings.textRenderer != TextRendererUILabel;
    self.firstNameView.hidden = settings.textRenderer != TextRendererCATextLayer;
    self.lastNameView.hidden = settings.textRenderer != TextRendererCATextLayer;
    self.phoneNumberView.hidden = settings.textRenderer != TextRendererCATextLayer;
    
    self.firstNameView.textLayer.fontSize = 9;
    self.lastNameView.textLayer.fontSize = 9;
    self.phoneNumberView.textLayer.fontSize = 9;
    
    self.firstNameView.textLayer.foregroundColor = [UIColor blackColor].CGColor;
    self.lastNameView.textLayer.foregroundColor = [UIColor blackColor].CGColor;
    self.phoneNumberView.textLayer.foregroundColor = [UIColor blackColor].CGColor;
    
    self.firstNameView.textLayer.contentsScale = [UIScreen mainScreen].nativeScale;
    self.lastNameView.textLayer.contentsScale = [UIScreen mainScreen].nativeScale;
    self.phoneNumberView.textLayer.contentsScale = [UIScreen mainScreen].nativeScale;
    
    self.topLeftCornerLayerView.hidden = settings.useCALayerMasking;
    self.topRightCornerLayerView.hidden = settings.useCALayerMasking;
    self.imageViewMaskView.layer.masksToBounds = settings.useCALayerMasking;
    self.imageViewMaskView.layer.cornerRadius = settings.useCALayerMasking ? 5 : 0;
    
    self.imageView.hidden = settings.imageRenderer != ImageRendererUIImageView;
    self.imageLayerView.hidden = settings.imageRenderer != ImageRendererCALayer;
    
    self.imageLayerView.layer.contentsGravity = kCAGravityResizeAspectFill;
    self.imageLayerView.layer.masksToBounds = YES;
    self.imageLayerView.opaque = YES;
    
    self.backgroundImageLayerView.hidden = settings.useCALayerCornerAndShadow;
    self.cardBackgroundView.hidden = !settings.useCALayerCornerAndShadow;
    self.cardShadowView.hidden = !settings.useCALayerCornerAndShadow;
    
    self.cardBackgroundView.backgroundColor = [UIColor whiteColor];
    self.cardBackgroundView.layer.masksToBounds = YES;
    self.cardBackgroundView.layer.cornerRadius = 5;
    
    self.cardShadowView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.cardShadowView.layer.shadowOffset = CGSizeMake(0, 5);
    self.cardShadowView.layer.shadowRadius = 3;
    self.cardShadowView.layer.shadowOpacity = 0.7;
    self.cardShadowView.layer.shouldRasterize = settings.rasterizeBackgroundLayer;
    self.cardShadowView.layer.rasterizationScale = [UIScreen mainScreen].nativeScale;
    
    self.backgroundImageLayerView.layer.contents = (id)[UIImage imageNamed:@"card"].CGImage;
    self.backgroundImageLayerView.layer.contentsScale = 2;
    self.backgroundImageLayerView.layer.contentsCenter = CGRectMake(0.2, 0.2, 0.6, 0.6);
    
    self.topLeftCornerLayerView.layer.contents = (id)[UIImage imageNamed:@"card_topLeftCorner"].CGImage;
    self.topLeftCornerLayerView.layer.contentsScale = 2;
    self.topLeftCornerLayerView.layer.contentsGravity = kCAGravityBottomLeft;
    
    self.topRightCornerLayerView.layer.contents = (id)[UIImage imageNamed:@"card_topRightCorner"].CGImage;
    self.topRightCornerLayerView.layer.contentsScale = 2;
    self.topRightCornerLayerView.layer.contentsGravity = kCAGravityBottomRight;
}

@end

@implementation NSLayoutConstraint (EqualConstraint)

+ (instancetype)equalConstraintWithItem:(id)item1 attribute:(NSLayoutAttribute)attribute toItem:(id)item2 {
    return [NSLayoutConstraint constraintWithItem:item1 attribute:attribute relatedBy:NSLayoutRelationEqual toItem:item2 attribute:attribute multiplier:1 constant:0];
}

@end

static inline CGSize SizeWithWidthAndAspectRatio(CGFloat width, CGFloat aspectRatio) {
    return CGSizeMake(width, width / aspectRatio);
}

@interface CollectionViewController () <SettingsViewControllerDelegate>

@property (nonatomic, strong, readwrite) NSArray<Data*>* data;

@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.data = [Data bunchOfData];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
        initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
        target:self
        action:@selector(didPressEditButton:)];
    
    [self reloadCollectionViewCompletely];
}

- (void)reloadCollectionViewCompletely {
    [self.collectionView removeFromSuperview];
    
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
    int columns = 3;
    CGFloat margin = 15;
    layout.itemSize = SizeWithWidthAndAspectRatio(([UIScreen mainScreen].bounds.size.width - (columns + 1)*margin) / columns, 4.0 / 3.0);
    layout.minimumLineSpacing = margin;
    layout.minimumInteritemSpacing = margin;
    layout.sectionInset = UIEdgeInsetsMake(margin, margin, margin, margin);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    self.collectionView.backgroundColor = [UIColor grayColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.view addSubview:self.collectionView];
    [self.view addConstraints:@[
        [NSLayoutConstraint equalConstraintWithItem:self.view attribute:NSLayoutAttributeTop toItem:self.collectionView],
        [NSLayoutConstraint equalConstraintWithItem:self.view attribute:NSLayoutAttributeRight toItem:self.collectionView],
        [NSLayoutConstraint equalConstraintWithItem:self.view attribute:NSLayoutAttributeBottom toItem:self.collectionView],
        [NSLayoutConstraint equalConstraintWithItem:self.view attribute:NSLayoutAttributeLeft toItem:self.collectionView]
    ]];
    
    UINib* cellNib = [UINib nibWithNibName:NSStringFromClass([Cell class])
                                    bundle:[NSBundle bundleForClass:[Cell class]]];
    [self.collectionView registerNib:cellNib
          forCellWithReuseIdentifier:NSStringFromClass([Cell class])];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.data.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    Cell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([Cell class])
                                                                 forIndexPath:indexPath];
    cell.data = self.data[indexPath.row];
    return cell;
}

- (void)didPressEditButton:(id)sender {
    SettingsViewController* settingsViewController = [SettingsViewController new];
    settingsViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    settingsViewController.delegate = self;
    [self presentViewController:settingsViewController animated:YES completion:nil];
}

- (void)settingsViewControllerDidFinish:(SettingsViewController *)settingsViewController {
    [self dismissViewControllerAnimated:YES completion:^{
        [self reloadCollectionViewCompletely];
    }];
}

@end
