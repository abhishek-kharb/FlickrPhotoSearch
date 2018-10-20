//
//  FlickrAppDelegate.m
//  FlickrSearch
//
//  Created by Abhishek Kharb on 20/10/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

#import "FlickrAppDelegate.h"
#import "FlickrDataSource.h"
#import "FlickrNetworkHandler.h"
#import "FlickrViewController.h"

static NSString *apiKey = @"3e7cc266ae2b0e0d78e279ce8e361736";

@interface FlickrAppDelegate ()
@property (nonatomic) FlickrViewController *appRootViewController;
@end

@implementation FlickrAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setupRootViewController];
    return YES;
}

- (void)setupRootViewController {
    FlickrNetworkHandler *networkHandler = [[FlickrNetworkHandler alloc] initWithNetworkAPIKey:apiKey];
    FlickrDataSource *dataSource = [[FlickrDataSource alloc] initWithNetworkHandler:networkHandler];
    self.appRootViewController = [[FlickrViewController alloc] initWithDataSource:dataSource];
    UINavigationController *rootNavigationController = [[UINavigationController alloc] initWithRootViewController:self.appRootViewController];
    UIWindow *rootWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [rootWindow setRootViewController:rootNavigationController];
    self.window = rootWindow;
    [self.window makeKeyAndVisible];
}

@end
