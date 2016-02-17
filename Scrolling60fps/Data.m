//
//  Data.m
//  Scrolling60fps
//
//  Created by Tamás Zahola on 09/02/16.
//  Copyright © 2016 Tamás Zahola. All rights reserved.
//

#import "Data.h"

@implementation Data

+ (NSArray<Data*>*)bunchOfData {
    static NSMutableArray<Data*>* bunchOfData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bunchOfData = [NSMutableArray new];
        for (int i = 0; i < 1000; ++i) {
            Data* data = [Data new];
            data.firstName = [self randomFirstName];
            data.lastName = [self randomLastName];
            data.phoneNumber = [self randomPhoneNumber];
            NSString* imageName = [self randomImageName];
            data.jpgImageURL = [[NSBundle mainBundle] URLForResource:imageName withExtension:@"jpg"];
            data.pngImageURL = [[NSBundle mainBundle] URLForResource:imageName withExtension:@"png"];
            [bunchOfData addObject:data];
        }
    });
    return bunchOfData;
}

+ (NSString*)randomImageName {
    NSInteger firstImage = 1;
    NSInteger lastImage = 100;
    NSInteger image = round((rand() / (float)RAND_MAX) * (lastImage - firstImage)) + firstImage;
    return [NSString stringWithFormat:@"%d", (int)image];
}

+ (NSString*)randomFirstName {
    static NSArray<NSString*>* firstNames = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        firstNames = @[@"John", @"Martha", @"Peter", @"Tom", @"Gabriel", @"Juan", @"Jesus", @"Timothy", @"Bill", @"Robert", @"Bob", @"Martin", @"Pepe"];
    });
    return firstNames[(int)floor((rand() / (float)RAND_MAX) * firstNames.count)];
}

+ (NSString*)randomLastName {
    static NSArray<NSString*>* lastNames = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lastNames = @[@"Ross", @"Carpenter", @"McCain", @"Doe", @"Klein", @"Skinner", @"Pointer", @"Thompson"];
    });
    return lastNames[(int)floor((rand() / (float)RAND_MAX) * lastNames.count)];
}


+ (NSString*)randomPhoneNumber {
    static NSArray<NSString*>* phoneNumbers = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        phoneNumbers = @[@"06-20-112-3325", @"+1-234-222-6666", @"+36/30-112-3322", @"+36/20-224-3322", @"+55-3-224-222", @"+43/233-333-66-33", @"06-20-222-3325", @"+12-234-242-6776", @"+38/35-172-33227", @"+36/260-264-3322", @"+57-55-224-222", @"+1/23-3343-646"];
    });
    return phoneNumbers[(int)floor((rand() / (float)RAND_MAX) * phoneNumbers.count)];
}

@end
