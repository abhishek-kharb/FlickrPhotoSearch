//
//  FlickrDataSourceTests.m
//  FlickrSearchTests
//
//  Created by Abhishek Kharb on 21/10/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FlickrNetworkHandlerMock.h"
#import "FlickrDataSource+Test.h"

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

- (void)testForNonNilNetworkHandler {
    XCTAssertNotNil(self.dataSource.networkHandler);
}

- (void)testFetchResultsWithSearchStringMethod {
    [self.dataSource fetchResultsWithSearchString:@"TestString"];
    XCTAssertEqual(self.dataSource.searchString, @"TestString");
    
    dispatch_async([self.dataSource dataProcessQueue], ^{
        XCTAssertTrue(self.dataSource.searchResults.count == 1);
    });
}

- (void)testDataValidationOfDataSource {
    //Test for empty response handling
    NSDictionary *emptyResponse;
    [self.dataSource processFetchedDataWithInfo:emptyResponse];
    dispatch_async([self.dataSource dataProcessQueue], ^{
        XCTAssertTrue(self.dataSource.searchResults.count == 0);
    });
    
    //Test for correct response handling
    NSDictionary *correctMockResponse = @{@"photos" : @{
                                           @"photo" : @[
                                                   @{
                                                       @"farm" : @2,
                                                       @"owner" : @"8740272@N04",
                                                       @"server" : @1963,
                                                       @"secret" : @"92eb27e8c4",
                                                       @"id" : @44549423415,
                                                       }
                                                   ],
                                           }};

    [self.dataSource processFetchedDataWithInfo:correctMockResponse];
    dispatch_async([self.dataSource dataProcessQueue], ^{
        XCTAssertTrue(self.dataSource.searchResults.count == 1);
    });
    
    //Test for incorrect response where id is missing
    NSDictionary *missingIDResponse = @{@"photos" : @{
                                                  @"photo" : @[
                                                          @{
                                                              @"farm" : @2,
                                                              @"owner" : @"8740272@N04",
                                                              @"server" : @1963,
                                                              @"secret" : @"92eb27e8c4",
                                                              }
                                                          ],
                                                  }};

    [self.dataSource processFetchedDataWithInfo:missingIDResponse];
    dispatch_async([self.dataSource dataProcessQueue], ^{
        XCTAssertTrue(self.dataSource.searchResults.count == 1);
    });

    //Test for partially response where id is missing in one of the objects
    NSDictionary *partialCorrectResponse = @{@"photos" : @{
                                                @"photo" : @[
                                                        @{
                                                            @"farm" : @2,
                                                            @"owner" : @"8740272@N04",
                                                            @"server" : @1963,
                                                            @"secret" : @"92eb27e8c4",
                                                            @"id" : @44549423415,
                                                            },
                                                        @{
                                                            @"farm" : @2,
                                                            @"owner" : @"8740272@N04",
                                                            @"server" : @1963,
                                                            @"secret" : @"92eb27e8c4",
                                                            }

                                                        ],
                                                }};
    
    [self.dataSource processFetchedDataWithInfo:partialCorrectResponse];
    dispatch_async([self.dataSource dataProcessQueue], ^{
        XCTAssertTrue(self.dataSource.searchResults.count == 2);
    });
}

- (void)testFetchNextBatch {
    [self.dataSource fetchResultsWithSearchString:@"TestString"];
    [self.dataSource fetchNextBatch];
    
    dispatch_async([self.dataSource dataProcessQueue], ^{
        XCTAssertTrue(self.dataSource.searchResults.count == 2);
    });
}

- (void)testChangingStringWhileFetching {
    //If the search string changes while the results are being fetched,we should discard the results for previous search
    [self.dataSource fetchResultsWithSearchString:@"TestString"];
    [self.dataSource fetchResultsWithSearchString:@"TestDifferentString"];
    
    dispatch_async([self.dataSource dataProcessQueue], ^{
        XCTAssertTrue(self.dataSource.searchResults.count == 1);
    });
}

@end
