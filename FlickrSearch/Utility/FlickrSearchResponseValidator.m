//
//  FlickrSearchResponseValidator.m
//  FlickrSearch
//
//  Created by Abhishek Kharb on 20/10/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

#import "FlickrSearchResponseValidator.h"

@implementation FlickrSearchResponseValidator
//Add check for all mandatory values inside response object in this class. As of now, we're only using these values in the current scope
+ (BOOL)isDataValidWithInfo:(NSDictionary *)info {
    if ([info valueForKey:kSearchResponseServer] &&
        [info valueForKey:kSearchResponseSecret] &&
        [info valueForKey:kSearchResponseId] &&
        [info valueForKey:kSearchResponseFarm]) {
        return YES;
    } else {
        return NO;
    }
}
@end
