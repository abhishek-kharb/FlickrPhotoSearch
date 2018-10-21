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
    
}
- (void)thumbnailForImageWithData:(FlickrPhotoDataModel *)data successBlock:(FlickrPhotoFetchSuccessBlock)successBlock failureBlock:(FlickrSearchResultFailureBlock)failure {
    
}


@end
