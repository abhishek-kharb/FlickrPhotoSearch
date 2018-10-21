//
//  FlickrDataSourceMock.m
//  FlickrSearchTests
//
//  Created by Abhishek Kharb on 21/10/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

#import "FlickrDataSourceMock.h"
#import "FlickrPhotoDataModel.h"

@implementation FlickrDataSourceMock
@synthesize delegate;

- (void)fetchResultsWithSearchString:(NSString *)searchString {
    
}

- (void)fetchNextBatch {
    
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (FlickrPhotoDataModel *)photoDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    FlickrPhotoDataModel *tempModel = [[FlickrPhotoDataModel alloc] init];
    return tempModel;
}

@end
