//
//  CollectionViewController.h
//  Scrolling60fps
//
//  Created by Tamás Zahola on 09/02/16.
//  Copyright © 2016 Tamás Zahola. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Data;

@interface CollectionViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong, readonly) UICollectionView* collectionView;
@property (nonatomic, strong, readonly) NSArray<Data*>* data;

@end
