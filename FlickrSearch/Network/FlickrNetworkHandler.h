//
//  FlickrNetworkHandler.h
//  FlickrSearch
//
//  Created by Abhishek Kharb on 20/10/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FlickrNetworkHandler : NSObject <FlickrNetworkHandlerProtocol>
- (instancetype)initWithNetworkAPIKey:(NSString *)apiKey;
@end

NS_ASSUME_NONNULL_END
