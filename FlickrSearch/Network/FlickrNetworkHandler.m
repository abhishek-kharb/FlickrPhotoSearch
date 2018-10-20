//
//  FlickrNetworkHandler.m
//  FlickrSearch
//
//  Created by Abhishek Kharb on 20/10/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

#import "FlickrNetworkHandler.h"

@interface FlickrNetworkHandler()
@property (nonatomic)NSString *apiKey;
@end

@implementation FlickrNetworkHandler

#pragma mark - Init Methods
- (instancetype)initWithNetworkAPIKey:(NSString *)apiKey {
    if (self = [super init]) {
        _apiKey = apiKey;
    }
    return self;
}

@end
