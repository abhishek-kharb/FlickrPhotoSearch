//
//  FlickrPhotoCollectionViewCell.h
//  FlickrSearch
//
//  Created by Abhishek Kharb on 20/10/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlickrPhotoDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FlickrPhotoCollectionViewCell : UICollectionViewCell
@property (nonatomic) UIImageView *thumbnailView;

- (void)configureCellWithPhotoData:(FlickrPhotoDataModel *)photoData;
@end

NS_ASSUME_NONNULL_END
