//
//  FlickrNetworkHandlerMock.m
//  FlickrSearchTests
//
//  Created by Abhishek Kharb on 21/10/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

#import "FlickrNetworkHandlerMock.h"

@implementation FlickrNetworkHandlerMock

- (void)makeSearchRequestWithInfo:(id<FlickrSearchRequestParameters>)requestInfo successBlock:(FlickrSearchResultSuccessBlock)successBlock failureBlock:(FlickrSearchResultFailureBlock)failure {
    NSDictionary *mockResponse = @{@"photos" : @{
                                           @"photo" : @[
                                               @{
                                                 @"farm" : @2,
                                                 @"owner" : @"8740272@N04",
                                                 @"server" : @1963,
                                                 @"secret" : @"92eb27e8c4",
                                                 @"id" : @44549423415,
                                                 }
                                            ],
                                           }};
    if (successBlock) {
        successBlock(mockResponse);
    }
}

- (void)thumbnailForImageWithData:(FlickrPhotoDataModel *)data successBlock:(FlickrPhotoFetchSuccessBlock)successBlock failureBlock:(FlickrSearchResultFailureBlock)failure {
    
}


@end
