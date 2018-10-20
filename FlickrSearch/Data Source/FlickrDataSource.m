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

static NSString *kDataProcessQueue = @"com.flickr.data.process.queue";
static NSString *kFlickrPhotosMethod = @"flickr.photos";
static NSInteger kFlickrPageFetchSize = 24;

@implementation FlickrDataSource
@synthesize delegate;

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
    [self resetCurrentFetchedDataIfNeededForSearchString:searchString];
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
                                              //Process received response only if the search string hasn't changed by the time we receive response.
                                              if ([searchString isEqualToString:weakSelf.searchString]) {
                                                  [weakSelf processFetchedDataWithInfo:responseInfo];
                                              }
                                          }
                                      }
                                      failureBlock:^(NSError * _Nonnull error) {
                                      }];
}

- (void)fetchNextBatch {
    self.nextPageToFetch ++;
    [self fetchResultsWithSearchString:self.searchString];
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    __block NSInteger totalItems;
    dispatch_sync([self dataProcessQueue], ^{
        totalItems = self.searchResults.count;
    });
    return totalItems;
}

- (FlickrPhotoDataModel *)photoDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    __block FlickrPhotoDataModel *modelObject;
    dispatch_sync([self dataProcessQueue], ^{
        if (self.searchResults.count > indexPath.item) {
            modelObject = [self.searchResults objectAtIndex:indexPath.item];
        }
    });
    return modelObject;
}

#pragma mark - Utility Methods
- (dispatch_queue_t)dataProcessQueue {
    static dispatch_queue_t dataProcessQueue;
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        dataProcessQueue = dispatch_queue_create([kDataProcessQueue UTF8String], DISPATCH_QUEUE_CONCURRENT);
    });
    
    return dataProcessQueue;
}

#pragma mark - Action Methods
- (void)resetCurrentFetchedDataIfNeededForSearchString:(NSString *)searchString {
    //If the search string has changed. Reset all current data.
    if (![self.searchString isEqualToString:searchString]) {
        self.nextPageToFetch = 0;
        dispatch_barrier_async([self dataProcessQueue], ^{
            self.searchResults = [[NSMutableArray alloc] init];
        });
    }
}

- (void)addDataToCurrentObjects:(NSArray <FlickrPhotoDataModel *> *)photoData {
    //As we're using NSMutableArray, it's always safe to perform all read/write from a single thread, to avoid multiple threads modifying
    //it at the same time, leading to EXC_BAD_ACCESS crashes.
    dispatch_barrier_async([self dataProcessQueue], ^{
        [self.searchResults addObjectsFromArray:photoData];
        [self.delegate fetchedDataAvailable];
    });
}

- (void)processFetchedDataWithInfo:(NSDictionary *)info {
    if (info) {
        NSDictionary *photos = [info valueForKey:kSearchResponsePhotos];
        NSArray *photosData = [photos valueForKey:kSearchResponsePhoto];
        if (photosData && photosData.count > 0) {
            NSMutableArray <FlickrPhotoDataModel *> *preprocessedData = [[NSMutableArray alloc] init];
            for (NSDictionary *currentPhoto in photosData) {
                //Check for all mandatory fields before appending data.
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
                [self addDataToCurrentObjects:preprocessedData];
            }
        }
    }
}

@end
