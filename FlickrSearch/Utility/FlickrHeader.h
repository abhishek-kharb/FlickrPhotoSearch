//
//  FlickrHeader.h
//  FlickrSearch
//
//  Created by Abhishek Kharb on 20/10/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

#ifndef FlickrHeader_h
#define FlickrHeader_h

typedef void (^FlickrSearchResultSuccessBlock)(NSDictionary *responseInfo);
typedef void (^FlickrSearchResultFailureBlock)(NSError *error);
typedef void (^FlickrPhotoFetchSuccessBlock)(NSData *data);

@protocol FlickrSearchRequestParameters <NSObject>
@property (nonatomic) NSString *keyword;
@property (nonatomic) NSString *method;
@property (nonatomic) NSInteger resultsPerPage;
@property (nonatomic) NSInteger pageToFetch;
@end

@class FlickrPhotoDataModel;
@protocol FlickrNetworkHandlerProtocol <NSObject>
- (void)makeSearchRequestWithInfo:(id<FlickrSearchRequestParameters>)requestInfo successBlock:(FlickrSearchResultSuccessBlock)successBlock failureBlock:(FlickrSearchResultFailureBlock)failure;
- (void)thumbnailForImageWithData:(FlickrPhotoDataModel *)data successBlock:(FlickrPhotoFetchSuccessBlock)successBlock failureBlock:(FlickrSearchResultFailureBlock)failure;
@end

@protocol FlickrDataSourceDelegateProtocol <NSObject>
- (void)fetchedDataAvailable;
@end

@protocol FlickrDataSourceProtocol <NSObject>
@property (nonatomic, weak) id<FlickrDataSourceDelegateProtocol>delegate;

- (void)fetchResultsWithSearchString:(NSString *)searchString;
- (void)fetchNextBatch;
- (NSInteger)numberOfItemsInSection:(NSInteger)section;
- (FlickrPhotoDataModel *)photoDataForItemAtIndexPath:(NSIndexPath *)indexPath;

@end
#endif /* FlickrHeader_h */
