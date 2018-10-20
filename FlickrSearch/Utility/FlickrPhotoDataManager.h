//
//  FlickrPhotoDataManager.h
//  FlickrSearch
//
//  Created by Abhishek Kharb on 20/10/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlickrPhotoDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FlickrPhotoDataManager : NSObject
+ (FlickrPhotoDataManager *)sharedManager;
- (void)thumbnailForImageWithData:(FlickrPhotoDataModel *)data completion:(void (^)(NSString *,UIImage *))completion;
@end

NS_ASSUME_NONNULL_END
