//
//  FlickrDataSourceTests.m
//  FlickrSearchTests
//
//  Created by Abhishek Kharb on 21/10/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FlickrNetworkHandlerMock.h"
#import "FlickrDataSource.h"

@interface FlickrDataSourceTests : XCTestCase
@property (nonatomic) FlickrDataSource *dataSource;
@end

@implementation FlickrDataSourceTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    FlickrNetworkHandlerMock *networkHandlerMock = [[FlickrNetworkHandlerMock alloc] init];
    self.dataSource = [[FlickrDataSource alloc] initWithNetworkHandler:networkHandlerMock];
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
