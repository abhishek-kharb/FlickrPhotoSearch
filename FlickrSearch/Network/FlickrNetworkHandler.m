//
//  FlickrNetworkHandler.m
//  FlickrSearch
//
//  Created by Abhishek Kharb on 20/10/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

#import "FlickrNetworkHandler.h"
#import "FlickrPhotoDataModel.h"

@interface FlickrNetworkHandler()
@property (nonatomic)NSString *apiKey;
@end

static const NSString *kFlickrSearchBaseApi = @"https://api.flickr.com/services/rest/";

@implementation FlickrNetworkHandler

#pragma mark - Init Methods
- (instancetype)initWithNetworkAPIKey:(NSString *)apiKey {
    if (self = [super init]) {
        _apiKey = apiKey;
    }
    return self;
}

#pragma mark - FlickrNetworkHandlerProtocol Methods
- (void)makeSearchRequestWithInfo:(id<FlickrSearchRequestParameters>)requestInfo successBlock:(FlickrSearchResultSuccessBlock)successBlock failureBlock:(FlickrSearchResultFailureBlock)failure {
    NSString *keyword = requestInfo.keyword;
    NSString *method = requestInfo.method;
    NSInteger resultsPerPage = requestInfo.resultsPerPage;
    NSInteger pageToFetch = requestInfo.pageToFetch;
    
    NSString *constructedURL = [NSString stringWithFormat:@"%@?method=%@.search&api_key=%@&tags=%@&page=%ld&per_page=%ld&format=json&nojsoncallback=1",kFlickrSearchBaseApi, method ,self.apiKey, keyword,pageToFetch,resultsPerPage];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:constructedURL]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionDataTask * sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            @autoreleasepool {
                NSDictionary *responseInfo = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                if (responseInfo) {
                    successBlock(responseInfo);
                } else {
                    failure(error);
                }
            }
        } else {
            failure(error);
        }
    }];
    [sessionDataTask resume];
}

- (void)thumbnailForImageWithData:(FlickrPhotoDataModel *)data successBlock:(FlickrPhotoFetchSuccessBlock)successBlock failureBlock:(FlickrSearchResultFailureBlock)failure {
    NSInteger farm = [data.farm integerValue];
    NSString *server = data.server ?: @"";
    NSString *secret = data.secret ?: @"";
    NSString *photoID = data.identifier ?: @"";
    
    NSString *urlString = [NSString stringWithFormat:@"https://farm%ld.static.flickr.com/%@/%@_%@.jpg",farm,server,photoID,secret];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setTimeoutInterval:15];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask * sessionDataTask = [session dataTaskWithRequest: request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            successBlock(data);
        } else {
            failure(error);
        }
    }];
    [sessionDataTask resume];
}

@end
