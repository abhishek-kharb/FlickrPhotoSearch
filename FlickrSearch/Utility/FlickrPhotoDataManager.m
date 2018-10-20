//
//  FlickrPhotoDataManager.m
//  FlickrSearch
//
//  Created by Abhishek Kharb on 20/10/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

#import "FlickrPhotoDataManager.h"
#import "FlickrNetworkHandler.h"

@interface FlickrPhotoDataManager ()
@property (nonatomic) NSCache *photosCache;
@property (nonatomic) FlickrNetworkHandler *networkHandler;
@end


@implementation FlickrPhotoDataManager
+ (FlickrPhotoDataManager *)sharedManager {
    static FlickrPhotoDataManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[FlickrPhotoDataManager alloc] init];
        manager.photosCache = [[NSCache alloc] init];
        manager.networkHandler = [[FlickrNetworkHandler alloc] init];
    });
    return manager;
}

- (void)thumbnailForImageWithData:(FlickrPhotoDataModel *)data completion:(nonnull void (^)(NSString * _Nonnull, UIImage * _Nonnull))completion {
    NSString *photoID = data.identifier;
    if ([self.photosCache objectForKey:photoID] ) {
        UIImage *image = [self.photosCache objectForKey:photoID];
        if (completion) {
            completion(photoID, image);
        }
    } else {
        //Image not present in cache. Needs to be fetched from server.
        __weak typeof(self) weakSelf = self;
        [self.networkHandler thumbnailForImageWithData:data
                                          successBlock:^(NSData * _Nonnull data) {
                                              @autoreleasepool {
                                                  UIImage *fetchedImage = [UIImage imageWithData:data];
                                                  if (fetchedImage) {
                                                      [weakSelf.photosCache setObject:fetchedImage forKey:photoID];
                                                      if (completion) {
                                                          completion (photoID, fetchedImage);
                                                      }
                                                  }
                                              }
        }
                                          failureBlock:^(NSError *error) {
                                              //Log for error
        }];
    }
}

@end
