//
//  FlickrViewController.m
//  FlickrSearch
//
//  Created by Abhishek Kharb on 20/10/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

#import "FlickrViewController.h"
#import "FlickrPhotoCollectionViewCell.h"
#import "FlickrLoaderView.h"

@interface FlickrViewController () <FlickrDataSourceDelegateProtocol, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UIScrollViewDelegate>
@property (nonatomic)id<FlickrDataSourceProtocol> dataSource;
@property (nonatomic) UISearchBar *searchBar;
@property (nonatomic) UICollectionView *photosCollectionView;
@property (nonatomic) NSString *searchString;
@property (nonatomic) BOOL isFetchedDataAvailable;
@property (nonatomic) BOOL isFetchInProgress;
@end

static CGFloat kSearchBarHeightConstant = 50.0f;
static CGFloat kCollectionViewTopPadding = 5.0f;
static CGFloat kCollectionViewCellPadding = 5.0f;
static CGFloat kCollectionViewFooterHeight = 100.0f;
static NSInteger kCollectionViewRowItems = 3;

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
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setupSearchBar];
    [self setupPhotosCollectionView];
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

- (void)setupPhotosCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.sectionHeadersPinToVisibleBounds = NO;
    
    self.photosCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.photosCollectionView.dataSource = self;
    self.photosCollectionView.delegate = self;
    self.photosCollectionView.bounces = YES;
    self.photosCollectionView.alwaysBounceVertical = YES;
    self.photosCollectionView.showsHorizontalScrollIndicator = NO;
    self.photosCollectionView.showsVerticalScrollIndicator = NO;
    [self.photosCollectionView setBackgroundColor:[UIColor whiteColor]];
    
    if (@available(iOS 10.0, *)) {
        self.photosCollectionView.prefetchingEnabled = NO;
    }
    [self.view addSubview:self.photosCollectionView];
    [self.photosCollectionView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.photosCollectionView.topAnchor constraintEqualToAnchor:self.searchBar.bottomAnchor constant:kCollectionViewTopPadding].active = YES;
    [self.photosCollectionView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.photosCollectionView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    [self.photosCollectionView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    
    [self.photosCollectionView registerClass:[FlickrPhotoCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([FlickrPhotoCollectionViewCell class])];
    [self.photosCollectionView registerClass:[FlickrLoaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([FlickrLoaderView class])];
}

#pragma mark - UICollectionViewDelegateFlowLayout Methods
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat paddingBetweenCells = (kCollectionViewRowItems - 1) * kCollectionViewCellPadding;
    CGFloat width = (self.photosCollectionView.bounds.size.width/kCollectionViewRowItems) - paddingBetweenCells;
    return CGSizeMake(width, width);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(kCollectionViewCellPadding, kCollectionViewCellPadding, kCollectionViewCellPadding, kCollectionViewCellPadding);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return kCollectionViewCellPadding;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return kCollectionViewCellPadding;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(collectionView.bounds.size.width, kCollectionViewFooterHeight);
}

#pragma mark - UICollectionViewDataSource Methods
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    FlickrPhotoCollectionViewCell *photoCell = (FlickrPhotoCollectionViewCell *)[self.photosCollectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FlickrPhotoCollectionViewCell class]) forIndexPath:indexPath];
    FlickrPhotoDataModel *photoData = [self.dataSource photoDataForItemAtIndexPath:indexPath];
    [photoCell configureCellWithPhotoData:photoData];
    return photoCell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataSource numberOfItemsInSection:section];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        FlickrLoaderView *loaderView = (FlickrLoaderView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([FlickrLoaderView class]) forIndexPath:indexPath];
        [loaderView setHidden:!self.isFetchedDataAvailable];
        return loaderView;
    }
    return nil;
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
    dispatch_async(dispatch_get_main_queue(), ^{
        self.isFetchedDataAvailable = YES;
        self.isFetchInProgress = NO;
        [self.photosCollectionView reloadData];
    });
}

#pragma mark - UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat contentHeight = scrollView.contentSize.height;
    /*As this method gets called multiple times while we scroll down, to avoid multiple calls to fetch next batch, we keep
    a flag isFetchInProgress to serve just the first callback and ignore the rest until data is fetched from server. */
    if (self.isFetchedDataAvailable && !self.isFetchInProgress && (offsetY > (contentHeight - scrollView.frame.size.height))) {
        self.isFetchInProgress = YES;
        [self.dataSource fetchNextBatch];
    }
}


@end
