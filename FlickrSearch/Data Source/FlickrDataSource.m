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
#import "FlickrSearchResponseValidator.h"

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
        _searchResults = [[NSMutableArray alloc] init];
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
    
    __weak typeof(self) weakSelf = self;
    [self.networkHandler makeSearchRequestWithInfo:requestInfo
                                      successBlock:^(NSDictionary * _Nonnull responseInfo) {
                                          if (responseInfo) {
                                              //Process received response only if the search string hasn't changed by the time we receive response
                                              if ([searchString isEqualToString:weakSelf.searchString]) {
                                                  [weakSelf processFetchedDataWithInfo:responseInfo];
                                              }
                                          }
                                      }
                                      failureBlock:^(NSError * _Nonnull error) {
                                      }];
}

#pragma mark - Action Methods
- (void)processFetchedDataWithInfo:(NSDictionary *)info {
    if (info) {
        NSDictionary *photos = [info valueForKey:kSearchResponsePhotos];
        NSArray *photosData = [photos valueForKey:kSearchResponsePhoto];
        if (photosData && photosData.count > 0) {
            NSMutableArray <FlickrPhotoDataModel *> *preprocessedData = [[NSMutableArray alloc] init];
            for (NSDictionary *currentPhoto in photosData) {
                //Check for all mandatory fields before appending data
                if ([FlickrSearchResponseValidator isDataValidWithInfo:currentPhoto]) {
                    FlickrPhotoDataModel *data = [[FlickrPhotoDataModel alloc] init];
                    data.farm = [currentPhoto valueForKey:kSearchResponseFarm];
                    data.identifier = [currentPhoto valueForKey:kSearchResponseId];
                    data.secret = [currentPhoto valueForKey:kSearchResponseSecret];
                    data.server = [currentPhoto valueForKey:kSearchResponseServer];
                    data.title = [currentPhoto valueForKey:kSearchResponseTitle];
                    data.owner = [currentPhoto valueForKey:kSearchResponseOwner];
                    [preprocessedData addObject:data];
                }
            }
            if (preprocessedData.count > 0) {
                //Append data to currently maintained array
            }
        }
    }
}


@end
