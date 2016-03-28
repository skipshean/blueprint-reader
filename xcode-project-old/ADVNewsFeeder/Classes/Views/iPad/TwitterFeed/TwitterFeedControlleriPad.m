//
//  TwitterFeedControlleriPad.m
//  ADVNewsFeeder
//
//  Created by Tope on 09/05/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "TwitterFeedControlleriPad.h"
#import "TwitterAdapter.h"
#import "TwitterProfile.h"
#import "AppDelegate.h"
#import "ISRefreshControl.h"
#import "Utils.h"

#import "FeediPadCell.h"
#import "ProfileiPadView.h"


@interface TwitterFeedControlleriPad ()

@property (strong, atomic) NSArray *tweets;

@property (strong, atomic) TwitterProfile *profile;

@property (strong, atomic) NSMutableDictionary *imagesDictionary;

@property (nonatomic, strong) ISRefreshControl *refreshControl;
@property (nonatomic, strong) NSDate *startRefreshDate;

@end







@implementation TwitterFeedControlleriPad

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[AppDelegate instance].theme customizeViewiPad:self.view];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:22];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    titleLabel.text = @"Twitter";
    self.navigationItem.titleView = titleLabel;
    
    self.imagesDictionary = [NSMutableDictionary dictionary];
    
    self.refreshControl = [[ISRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.collectionView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self
                            action:@selector(loadTwitterData)
                  forControlEvents:UIControlEventValueChanged];
    [self.refreshControl beginRefreshing];
    
    
    CGFloat width = kCollectionFeedWidthPortrait;
    NSInteger colCount = 2;
    UIEdgeInsets sectionInset = UIEdgeInsetsMake(20, 12, 20, 12);
    if(UIInterfaceOrientationIsLandscape(self.interfaceOrientation)){
        width = kCollectionFeedWidthLandscape;
        colCount = 3;
        sectionInset = UIEdgeInsetsMake(20, 10, 20, 10);
    }
    
    UICollectionViewWaterfallLayout *layout = [[UICollectionViewWaterfallLayout alloc] init];
    
    layout.sectionInset = sectionInset;
    layout.delegate = self;
    layout.itemWidth = width;
    layout.columnCount = colCount;
    self.collectionView.collectionViewLayout = layout;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadTwitterData) name:AccountTwitterAccessGranted object:nil];
    
    TwitterAdapter* twitterAdapter = [AppDelegate instance].twitterAdapter;
    [twitterAdapter accessTwitterAccountWithAccountStore:[AppDelegate instance].accountStore];
    
    [self setupCollectionView];
}

- (void)loadTwitterData {
    self.startRefreshDate = [NSDate date];
    [self getTwitterProfile];
    [self refreshTwitterFeed];
}

- (void)refreshTwitterFeed {    
    TwitterAdapter* twitterAdapter = [AppDelegate instance].twitterAdapter;
    
    [twitterAdapter refreshTwitterFeedWithCompletion:^(NSArray* jsonResponse) {        
        [self twitterFeedRefreshed:jsonResponse];
    }];
    
}


- (void)twitterFeedRefreshed:(NSArray*)jsonResponse {    
    self.tweets = jsonResponse;
    [self.collectionView reloadData];
    
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:_startRefreshDate];
    NSTimeInterval minimumInterval = 3;
    if (interval > minimumInterval) {
        [self.refreshControl endRefreshing];
    } else {
        [self.refreshControl performSelector:@selector(endRefreshing) withObject:nil afterDelay:(minimumInterval-interval)];
    }
}


- (void)getTwitterProfile {
    TwitterAdapter* twitterAdapter = [AppDelegate instance].twitterAdapter;
    
    [twitterAdapter getTwitterProfileWithCompletion:^(NSDictionary* jsonResponse) {
        [self twitterProfileReceived:jsonResponse];
    }];
    
}


-(void)twitterProfileReceived:(NSDictionary*)jsonResponse{
    
    self.profile = [[TwitterProfile alloc] initWithJSON:jsonResponse];
    
    [_profileView.usernameLabel setText:self.profile.name];
    [_profileView.followerCountLabel setText:[self.profile.followerCount stringValue]];
    [_profileView.followingCountLabel setText:[self.profile.followingCount stringValue]];
    [_profileView.screenNameLabel setText:[NSString stringWithFormat:@"@%@", self.profile.screenName]];
    
    if (self.imagesDictionary[kTwitterProfileImageKey]) {
        _profileView.profilePictureImageView.image = self.imagesDictionary[kTwitterProfileImageKey];
    } else {
        [self getImageFromUrl:self.profile.profileImageUrl asynchronouslyForImageView:_profileView.profilePictureImageView andKey:kTwitterProfileImageKey];
        
        [self getImageFromUrl:self.profile.profileBannerUrl asynchronouslyForImageView:_profileView.bannerImageView andKey:kTwitterBannerImageKey];
    }
}

#pragma mark - UICollectionView datasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.tweets.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FeediPadCell *cell = (FeediPadCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"TweetCell" forIndexPath:indexPath];
    
    NSDictionary *tweetDictionary = self.tweets[indexPath.row];
    
    NSDictionary *user = tweetDictionary[@"user"];
    
    
    cell.usernameLabel.text = user[@"name"];
    cell.tweetLabel.text = tweetDictionary[@"text"];
    
    cell.tweetLabel.frame =
    CGRectMake(cell.tweetLabel.frame.origin.x,
               cell.tweetLabel.frame.origin.y,
               cell.bounds.size.width - 84,
               [self heightForCellAtIndex:indexPath.row]-50);
    cell.tweetLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    cell.tweetLabel.font = [UIFont systemFontOfSize:13.0f];
    
    NSString *userName = user[@"name"];
    cell.profileImageView.image = nil;
    
    if (self.imagesDictionary[userName]) {
        cell.profileImageView.image = self.imagesDictionary[userName];
    } else {
        NSString* imageUrl = [user objectForKey:@"profile_image_url"];
        
        [self getImageFromUrl:imageUrl asynchronouslyForImageView:cell.profileImageView andKey:userName];
    }
    
    NSArray *days = [NSArray arrayWithObjects:@"Mon ", @"Tue ", @"Wed ", @"Thu ", @"Fri ", @"Sat ", @"Sun ", nil];
    NSArray *calendarMonths = [NSArray arrayWithObjects:@"Jan", @"Feb", @"Mar",@"Apr", @"May", @"Jun", @"Jul", @"Aug", @"Sep", @"Oct", @"Nov", @"Dec", nil];
    NSString *dateStr = [tweetDictionary objectForKey:@"created_at"];
    
    for (NSString *day in days) {
        if ([dateStr rangeOfString:day].location == 0) {
            dateStr = [dateStr stringByReplacingOccurrencesOfString:day withString:@""];
            break;
        }
    }
    
    NSArray *dateArray = [dateStr componentsSeparatedByString:@" "];
    NSArray *hourArray = [[dateArray objectAtIndex:2] componentsSeparatedByString:@":"];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    
    NSString *aux = [dateArray objectAtIndex:0];
    int month = 0;
    for (NSString *m in calendarMonths) {
        month++;
        if ([m isEqualToString:aux]) {
            break;
        }
    }
    components.month = month;
    components.day = [[dateArray objectAtIndex:1] intValue];
    components.hour = [[hourArray objectAtIndex:0] intValue];
    components.minute = [[hourArray objectAtIndex:1] intValue];
    components.second = [[hourArray objectAtIndex:2] intValue];
    components.year = [[dateArray objectAtIndex:4] intValue];
    
    NSTimeZone *gmt = [NSTimeZone timeZoneForSecondsFromGMT:2];
    [components setTimeZone:gmt];
    
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [calendar setTimeZone:[NSTimeZone systemTimeZone]];
    NSDate *date = [calendar dateFromComponents:components];
    
    cell.dateLabel.text = [Utils getTimeAsString:date];
    
    return cell;   
}


#pragma mark - UICollectionView delegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = kCollectionFeedWidthPortrait;
    if(UIInterfaceOrientationIsLandscape(self.interfaceOrientation)){
        width = kCollectionFeedWidthLandscape;
    }
    return CGSizeMake(width, [self heightForCellAtIndex:indexPath.row]);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewWaterfallLayout *)collectionViewLayout
 heightForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self heightForCellAtIndex:indexPath.row];
}



- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    if(UIInterfaceOrientationIsLandscape(self.interfaceOrientation)){
        return UIEdgeInsetsMake(20, 10, 20, 10);
    }
    else{
        return UIEdgeInsetsMake(20, 12, 20, 12);
    }
    
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self setupCollectionView];
}

- (void)setupCollectionView {
    CGFloat width = kCollectionFeedWidthPortrait;
    NSInteger colCount = 2;
    UIEdgeInsets sectionInset = UIEdgeInsetsMake(20, 12, 20, 12);
    if(UIInterfaceOrientationIsLandscape(self.interfaceOrientation)){
        width = kCollectionFeedWidthLandscape;
        colCount = 3;
        sectionInset = UIEdgeInsetsMake(20, 10, 20, 10);
    }
    UICollectionViewWaterfallLayout *layout = (UICollectionViewWaterfallLayout *)self.collectionView.collectionViewLayout;
    layout.itemWidth = width;
    layout.columnCount = colCount;
    layout.sectionInset = sectionInset;
    [self.collectionView reloadData];
}

- (CGFloat)heightForCellAtIndex:(NSUInteger)index {
    
    NSDictionary *tweet = self.tweets[index];
    CGFloat cellHeight = 55;
    NSString *tweetText = tweet[@"text"];
    
    CGFloat width = kCollectionFeedWidthPortrait;
    if(UIInterfaceOrientationIsLandscape(self.interfaceOrientation)){
        width = kCollectionFeedWidthLandscape;
    }
    CGSize labelHeight = [tweetText sizeWithFont:[UIFont systemFontOfSize:13.0f] constrainedToSize:CGSizeMake(width - 84, 4000)];
    
    cellHeight += labelHeight.height;
    return cellHeight;
}

-(void)getImageFromUrl:(NSString*)imageUrl asynchronouslyForImageView:(UIImageView*)imageView andKey:(NSString*)key{
    
    dispatch_async(dispatch_get_global_queue(
                                             DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSURL *url = [NSURL URLWithString:imageUrl];
        
        __block NSData *imageData;
        
        dispatch_sync(dispatch_get_global_queue(
                                                DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            imageData =[NSData dataWithContentsOfURL:url];
            
            if(imageData){
                
                [self.imagesDictionary setObject:[UIImage imageWithData:imageData] forKey:key];
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    imageView.image = self.imagesDictionary[key];
                });
            }
        });
    });
}

@end
