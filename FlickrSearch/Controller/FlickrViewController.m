//
//  FlickrViewController.m
//  FlickrSearch
//
//  Created by Abhishek Kharb on 20/10/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

#import "FlickrViewController.h"

@interface FlickrViewController ()
@property (nonatomic)id<FlickrDataSourceProtocol> dataSource;
@end

@implementation FlickrViewController

#pragma mark - Init Methods
- (instancetype)initWithDataSource:(id<FlickrDataSourceProtocol>)dataSource {
    if (self = [super init]) {
        _dataSource = dataSource;
    }
    return self;
}

#pragma mark - View Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

@end
