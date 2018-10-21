//
//  FlickrViewController+Test.h
//  FlickrSearchTests
//
//  Created by Abhishek Kharb on 21/10/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

#import "FlickrViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FlickrViewController (Test)
@property (nonatomic, readonly) id<FlickrDataSourceProtocol> dataSource;
@property (nonatomic, readonly) UICollectionView *photosCollectionView;
@property (nonatomic, readonly) BOOL isFetchedDataAvailable;
@property (nonatomic, readonly) BOOL isFetchInProgress;

- (void)fetchedDataAvailable;

@end

NS_ASSUME_NONNULL_END
