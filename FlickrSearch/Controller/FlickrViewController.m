//
//  FlickrViewController.m
//  FlickrSearch
//
//  Created by Abhishek Kharb on 20/10/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

#import "FlickrViewController.h"

@interface FlickrViewController () <FlickrDataSourceDelegateProtocol, UISearchBarDelegate>
@property (nonatomic)id<FlickrDataSourceProtocol> dataSource;
@property (nonatomic) UISearchBar *searchBar;
@property (nonatomic) NSString *searchString;
@end

static CGFloat kSearchBarHeightConstant = 50.0f;

@implementation FlickrViewController

#pragma mark - Init Methods
- (instancetype)initWithDataSource:(id<FlickrDataSourceProtocol>)dataSource {
    if (self = [super init]) {
        _dataSource = dataSource;
        _dataSource.delegate = self;
    }
    return self;
}

#pragma mark - View Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"Photo Search"];
    [self setupSearchBar];
}

#pragma mark - Action Methods
- (void)setupSearchBar {
    //We calculate these programatically as statusbar height varies for iPhoneX and below models.
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat navBarHeight = self.navigationController.navigationBar.bounds.size.height;
    CGFloat topConstraintPadding =  statusBarHeight + navBarHeight;
    
    self.searchBar = [[UISearchBar alloc] init];
    [self.view addSubview:self.searchBar];
    [self.searchBar setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.searchBar.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:topConstraintPadding].active = YES;
    [self.searchBar.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.searchBar.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    [self.searchBar.heightAnchor constraintEqualToConstant:kSearchBarHeightConstant].active = YES;
    [self.searchBar setSearchBarStyle:UISearchBarStyleDefault];
    [self.searchBar setShowsCancelButton:YES];
    [self.searchBar setDelegate:self];
    [self.searchBar setPlaceholder:@"Enter text and press search..."];
}

#pragma mark - UISearchBarDelegate Methods
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    self.searchString = searchBar.text;
    [searchBar resignFirstResponder];
    [self.dataSource fetchResultsWithSearchString:self.searchString];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}


#pragma mark FlickrDataSourceDelegateProtocol Methods
- (void)fetchedDataAvailable {
    //Datasource has updated its data. Reload UI to reflect the changes.
}

@end
