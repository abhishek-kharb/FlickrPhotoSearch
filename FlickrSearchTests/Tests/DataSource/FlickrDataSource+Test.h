//
//  FlickrDataSource+Test.h
//  FlickrSearchTests
//
//  Created by Abhishek Kharb on 21/10/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

#import "FlickrDataSource.h"

NS_ASSUME_NONNULL_BEGIN

@interface FlickrDataSource (Test)
@property (nonatomic, readonly) id<FlickrNetworkHandlerProtocol> networkHandler;
@property (nonatomic, readonly) NSMutableArray <FlickrPhotoDataModel *> *searchResults;
@property (nonatomic, readonly) NSString *searchString;


- (dispatch_queue_t)dataProcessQueue;
- (void)processFetchedDataWithInfo:(NSDictionary *)info;
@end

NS_ASSUME_NONNULL_END
