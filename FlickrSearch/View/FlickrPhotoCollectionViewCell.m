//
//  FlickrPhotoCollectionViewCell.m
//  FlickrSearch
//
//  Created by Abhishek Kharb on 20/10/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

#import "FlickrPhotoCollectionViewCell.h"
#import "FlickrPhotoDataManager.h"

@implementation FlickrPhotoCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor grayColor]];
        [self setupSubviews];
    }
    return self;
}


- (void)prepareForReuse {
    [self.thumbnailView setImage:nil];
    [super prepareForReuse];
}

- (void)setupSubviews {
    _thumbnailView = [[UIImageView alloc] init];
    _thumbnailView.translatesAutoresizingMaskIntoConstraints = NO;
    _thumbnailView.contentMode = UIViewContentModeScaleAspectFill;
    _thumbnailView.clipsToBounds = YES;
    [self.contentView addSubview:_thumbnailView];
    
    [_thumbnailView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor].active = YES;
    [_thumbnailView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor].active = YES;
    [_thumbnailView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor].active = YES;
    [_thumbnailView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor].active = YES;
    
}

- (void)configureCellWithPhotoData:(FlickrPhotoDataModel *)photoData {
    if (photoData) {
        NSString *initialID = photoData.identifier;
        [[FlickrPhotoDataManager sharedManager] thumbnailForImageWithData:photoData completion:^(NSString * _Nonnull photoID, UIImage * _Nonnull image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([photoID isEqualToString:initialID] && !self.thumbnailView.image) {
                    [self.thumbnailView setImage:image];
                }
            });
        }];
    }
}


@end
