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

@protocol FlickrSearchRequestParameters <NSObject>
@property (nonatomic) NSString *keyword;
@property (nonatomic) NSString *method;
@property (nonatomic) NSInteger resultsPerPage;
@property (nonatomic) NSInteger pageToFetch;
@end

@protocol FlickrNetworkHandlerProtocol <NSObject>
- (void)makeSearchRequestWithInfo:(id<FlickrSearchRequestParameters>)requestInfo successBlock:(FlickrSearchResultSuccessBlock)successBlock failureBlock:(FlickrSearchResultFailureBlock)failure;
@end

@protocol FlickrDataSourceProtocol <NSObject>
- (void)fetchResultsWithSearchString:(NSString *)searchString;
@end
#endif /* FlickrHeader_h */
