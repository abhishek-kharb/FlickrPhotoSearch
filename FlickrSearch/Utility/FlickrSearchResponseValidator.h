//
//  FlickrSearchResponseValidator.h
//  FlickrSearch
//
//  Created by Abhishek Kharb on 20/10/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *kSearchResponseFarm = @"farm";
static NSString *kSearchResponseTitle = @"title";
static NSString *kSearchResponseId = @"id";
static NSString *kSearchResponseSecret = @"secret";
static NSString *kSearchResponseServer = @"server";
static NSString *kSearchResponseOwner = @"owner";
static NSString *kSearchResponsePhotos = @"photos";
static NSString *kSearchResponsePhoto = @"photo";

@interface FlickrSearchResponseValidator : NSObject
+ (BOOL)isDataValidWithInfo:(NSDictionary *)info;
@end

NS_ASSUME_NONNULL_END
