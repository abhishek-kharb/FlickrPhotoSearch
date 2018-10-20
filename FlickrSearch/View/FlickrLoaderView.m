//
//  FlickrLoaderView.m
//  FlickrSearch
//
//  Created by Abhishek Kharb on 20/10/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

#import "FlickrLoaderView.h"

@implementation FlickrLoaderView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] init];
    [self addSubview:self.activityIndicatorView];
    [self.activityIndicatorView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.activityIndicatorView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
    [self.activityIndicatorView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = YES;
    [self.activityIndicatorView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [self.activityIndicatorView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
    [self.activityIndicatorView setColor:[UIColor blackColor]];
    [self.activityIndicatorView startAnimating];
}

@end
