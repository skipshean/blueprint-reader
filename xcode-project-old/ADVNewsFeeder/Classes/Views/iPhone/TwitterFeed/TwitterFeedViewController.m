//
//  TwitterFeedViewController.m
//  ADVNewsFeeder
//
//  Created by Tope on 11/04/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "TwitterFeedViewController.h"
#import "AppDelegate.h"
#import "FeedCell.h"
#import "ProfileCell.h"
#import "TwitterProfile.h"
#import <QuartzCore/QuartzCore.h>
#import "ISRefreshControl.h"
#import "Utils.h"


@interface TwitterFeedViewController ()

@property (strong, atomic) NSArray *tweets;

@property (strong, atomic) TwitterProfile *profile;

@property (strong, atomic) NSMutableDictionary *imagesDictionary;

@property (nonatomic, strong) ISRefreshControl *refreshControl;
@property (nonatomic, strong) NSDate *startRefreshDate;

@end







@implementation TwitterFeedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Twitter";

    [[AppDelegate instance].theme customizeView:self.view];
    
    [self.tweetsTableView setDelegate:self];
    [self.tweetsTableView setDataSource:self];
    [self.tweetsTableView setAlpha:0];
	
    self.refreshControl = [[ISRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.tweetsTableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self
                            action:@selector(loadTwitterData)
                  forControlEvents:UIControlEventValueChanged];
    [self.refreshControl beginRefreshing];
    
    
    UIBarButtonItem* reloadButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-btn-menu"] style:UIBarButtonItemStylePlain target:self action:@selector(showMenu:)];
    
    self.navigationItem.leftBarButtonItem = reloadButton;
}

- (void)showMenu:(id)sender {
    [[AppDelegate instance] togglePaperFold:sender];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadTwitterData) name:AccountTwitterAccessGranted object:nil];
    
    TwitterAdapter* twitterAdapter = [AppDelegate instance].twitterAdapter;

    [twitterAdapter accessTwitterAccountWithAccountStore:[AppDelegate instance].accountStore];

}

- (void)loadTwitterData{
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


- (void)twitterFeedRefreshed:(NSArray*)jsonResponse{
    
    self.imagesDictionary = [NSMutableDictionary dictionary];
    
    self.tweets = jsonResponse;
    [self.tweetsTableView reloadData];
    
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
    
    [self.tweetsTableView setAlpha:1];
    [self.tweetsTableView reloadData];
}





- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        return 219;
    }
    else{
        return [self heightForCellAtIndex:indexPath.row];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        return 1;
    }
    else{
        return self.tweets.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.section == 0) { 
        ProfileCell* cell = (ProfileCell*)[tableView dequeueReusableCellWithIdentifier:@"TweetProfileCell"];
        
        [cell.usernameLabel setText:self.profile.name];
        [cell.followerCountLabel setText:[self.profile.followerCount stringValue]];
        [cell.followingCountLabel setText:[self.profile.followingCount stringValue]];
        [cell.screenNameLabel setText:[NSString stringWithFormat:@"@%@", self.profile.screenName]];
        
        if (self.imagesDictionary[kTwitterProfileImageKey]) {
            cell.profilePictureImageView.image = self.imagesDictionary[kTwitterProfileImageKey];
        } else {
            [self getImageFromUrl:self.profile.profileImageUrl asynchronouslyForImageView:cell.profilePictureImageView andKey:kTwitterProfileImageKey];
            
            [self getImageFromUrl:self.profile.profileBannerUrl asynchronouslyForImageView:cell.bannerImageView andKey:kTwitterBannerImageKey];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        FeedCell *cell = (FeedCell*)[tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
        
        NSDictionary *tweetDictionary = self.tweets[indexPath.row];

        NSDictionary *user = tweetDictionary[@"user"];
        

        cell.usernameLabel.text = user[@"name"];
        cell.tweetLabel.text = tweetDictionary[@"text"];
        
        cell.tweetLabel.frame =
        CGRectMake(cell.tweetLabel.frame.origin.x,
                   cell.tweetLabel.frame.origin.y,
                   self.tweetsTableView.bounds.size.width - 84,
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
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
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

- (CGFloat)heightForCellAtIndex:(NSUInteger)index {
    
    NSDictionary *tweet = self.tweets[index];
    CGFloat cellHeight = 50;
    NSString *tweetText = tweet[@"text"];
    
    CGSize labelHeight = [tweetText sizeWithFont:[UIFont systemFontOfSize:13.0f] constrainedToSize:CGSizeMake(self.tweetsTableView.bounds.size.width - 84, 4000)];
    
    cellHeight += labelHeight.height;
    return cellHeight;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    if ([self.view window] == nil) {
        self.view = nil;
        _imagesDictionary = nil;
        _tweets = nil; }
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewWillDisappear:animated];
}

@end
