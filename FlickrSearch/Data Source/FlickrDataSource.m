//
//  FlickrDataSource.m
//  FlickrSearch
//
//  Created by Abhishek Kharb on 20/10/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

#import "FlickrDataSource.h"

@interface FlickrDataSource()
@property (nonatomic) id<FlickrNetworkHandlerProtocol> networkHandler;
@end

@implementation FlickrDataSource

#pragma mark - Init Methods
- (instancetype)initWithNetworkHandler:(id <FlickrNetworkHandlerProtocol>)networkHandler {
    if (self = [super init]) {
        _networkHandler = networkHandler;
    }
    return self;
}

@end
