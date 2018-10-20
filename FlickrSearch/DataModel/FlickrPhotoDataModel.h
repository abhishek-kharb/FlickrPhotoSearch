//
//  FlickrPhotoDataModel.h
//  FlickrSearch
//
//  Created by Abhishek Kharb on 20/10/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FlickrPhotoDataModel : NSObject
@property (nonatomic) NSNumber *farm;
@property (nonatomic) NSString *identifier;
@property (nonatomic) NSString *owner;
@property (nonatomic) NSString *secret;
@property (nonatomic) NSString *server;
@property (nonatomic) NSString *title;
@end

NS_ASSUME_NONNULL_END
