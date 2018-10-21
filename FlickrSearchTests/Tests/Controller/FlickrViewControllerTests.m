//
//  FlickrViewControllerTests.m
//  FlickrSearchTests
//
//  Created by Abhishek Kharb on 21/10/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FlickrViewController+Test.h"
#import "FlickrDataSourceMock.h"
#import "FlickrPhotoCollectionViewCell.h"

@interface FlickrViewControllerTests : XCTestCase
@property (nonatomic) FlickrViewController *viewController;
@end

@implementation FlickrViewControllerTests

- (void)setUp {
    FlickrDataSourceMock *dataSourceMock = [[FlickrDataSourceMock alloc] init];
    self.viewController = [[FlickrViewController alloc] initWithDataSource:dataSourceMock];
    [self.viewController view];     //Force viewDidLoad to get called
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testNonNilProperties {
    XCTAssertNotNil(self.viewController.dataSource);
    XCTAssertNotNil(self.viewController.photosCollectionView);
}

- (void)testnumberOfItemsInSectionMethod {
    [self.viewController.photosCollectionView reloadData];
    NSInteger totalItems = [self.viewController.photosCollectionView numberOfItemsInSection:0];
    XCTAssertTrue(totalItems == 1);
}

- (void)testInternalPropertiesOnFetchComplete {
    [self.viewController fetchedDataAvailable];
    dispatch_async(dispatch_get_main_queue(), ^{
        XCTAssertTrue(self.viewController.isFetchInProgress == NO);
        XCTAssertTrue(self.viewController.isFetchedDataAvailable == YES);
    });
}

@end
