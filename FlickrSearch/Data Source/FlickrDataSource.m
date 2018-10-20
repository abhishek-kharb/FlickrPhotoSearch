//
//  FlickrDataSource.m
//  FlickrSearch
//
//  Created by Abhishek Kharb on 20/10/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

#import "FlickrDataSource.h"
#import "FlickrPhotoDataModel.h"
#import "FlickrNetworkSearchParameters.h"

@interface FlickrDataSource()
@property (nonatomic) id<FlickrNetworkHandlerProtocol> networkHandler;
@property (nonatomic) NSMutableArray <FlickrPhotoDataModel *> *searchResults;
@property (nonatomic) NSInteger nextPageToFetch;
@property (nonatomic) NSString *searchString;
@end

static NSString *kFlickrPhotosMethod = @"flickr.photos";
static NSInteger kFlickrPageFetchSize = 24;

@implementation FlickrDataSource

#pragma mark - Init Methods
- (instancetype)initWithNetworkHandler:(id <FlickrNetworkHandlerProtocol>)networkHandler {
    if (self = [super init]) {
        _networkHandler = networkHandler;
    }
    return self;
}

#pragma mark - FlickrDataSourceProtocol Methods
- (void)fetchResultsWithSearchString:(NSString *)searchString {
    self.searchString = searchString;
    
    FlickrNetworkSearchParameters *requestInfo = [[FlickrNetworkSearchParameters alloc] init];
    requestInfo.method = kFlickrPhotosMethod;
    requestInfo.resultsPerPage = kFlickrPageFetchSize;
    requestInfo.pageToFetch = self.nextPageToFetch;
    requestInfo.keyword = searchString;
    
    [self.networkHandler makeSearchRequestWithInfo:requestInfo
                                      successBlock:^(NSDictionary * _Nonnull responseInfo) {
                                          if (responseInfo) {
                                              //Process received response
                                          }
                                      }
                                      failureBlock:^(NSError * _Nonnull error) {
                                      }];
}

@end
