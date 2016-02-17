//
//  Data.h
//  Scrolling60fps
//
//  Created by Tamás Zahola on 09/02/16.
//  Copyright © 2016 Tamás Zahola. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Data : NSObject

@property (nonatomic, strong) NSString* firstName;
@property (nonatomic, strong) NSString* lastName;
@property (nonatomic, strong) NSString* phoneNumber;
@property (nonatomic, strong) NSURL* jpgImageURL;
@property (nonatomic, strong) NSURL* pngImageURL;
@property (nonatomic, assign) BOOL isOnline;

+ (NSArray<Data *>*)bunchOfData;

@end
