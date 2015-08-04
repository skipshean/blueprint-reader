//
//  TwitterFeedViewController.m
//  ADVNewsFeeder
//
//  Created by Tope on 11/04/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "FacebookFeedViewController.h"
#import "AppDelegate.h"
#import "FeedCell.h"
#import "ProfileCell.h"
#import "FacebookProfile.h"
#import "FacebookPageProfile.h"
#import "FacebookPersonalProfile.h"
#import <QuartzCore/QuartzCore.h>
#import "ISRefreshControl.h"
#import "Utils.h"
#import "Configuration.h"



@interface FacebookFeedViewController ()

@property (strong, atomic)      NSArray                 *feed;
@property (strong, atomic)      NSMutableDictionary     *imagesDictionary;
@property (nonatomic, strong)   NSDate                  *startRefreshDate;
@property (strong, atomic)      FacebookProfile         *profile;
@property (nonatomic, strong)   ISRefreshControl        *refreshControl;
@property (nonatomic, strong)   NSString                *profileType;

@end

@implementation FacebookFeedViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Facebook";

    [[AppDelegate instance].theme customizeView:self.view];
    
    Configuration *config = [[Configuration alloc] init];
    self.profileType = [config facebookProfileType];
    
    [self.streamTableView setDelegate:self];
    [self.streamTableView setDataSource:self];
    [self.streamTableView setAlpha:0];
	
    self.refreshControl = [[ISRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.streamTableView addSubview:self.refreshControl];
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
    
    
    FacebookAdapter *adapter = [AppDelegate instance].facebookAdapter;
    if (adapter.account) {
        [self loadTwitterData];
    } else {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadTwitterData) name:AccountFacebookAccessGranted object:nil];
        [adapter accessFacebookAccountWithAccountStore:[AppDelegate instance].accountStore];
    }
}

- (void)loadTwitterData{
    self.startRefreshDate = [NSDate date];
    [self getProfile];
    [self refreshFeed];
}

- (void)refreshFeed {
    
    FacebookAdapter *adapter = [AppDelegate instance].facebookAdapter;
    
    [adapter getFeed:^(NSArray* jsonResponse) {
        
        [self feedRefreshed:jsonResponse];
    }];   
}

- (void)getNumbers:(NSNumber*)userId {
    FacebookAdapter *adapter = [AppDelegate instance].facebookAdapter;
    
    [adapter getFriendAndSubscriberCountOfUser:userId withCompleteion:^(NSDictionary *jsonResponse) {
        NSNumber *friendsCount = jsonResponse[@"data"][0][@"friend_count"];
        NSNumber *subscribersCount = jsonResponse[@"data"][0][@"subscriber_count"];
        
        NSDictionary* friends = @{ @"name": @"FRIENDS", @"count" : friendsCount };
        NSDictionary* subscribers = @{ @"name": @"SUBSCRIBERS", @"count" : subscribersCount };
        
        self.profile.socialCount1 =  friends;
        self.profile.socialCount2 = subscribers;
        
        self.streamTableView.alpha = 1;
        [self.streamTableView reloadData];
    }];
}


- (void)feedRefreshed:(NSArray*)jsonResponse {
    self.imagesDictionary = [NSMutableDictionary dictionary];
    
    self.feed = jsonResponse;
    [self.streamTableView reloadData];
    
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:_startRefreshDate];
    NSTimeInterval minimumInterval = 3;
    if (interval > minimumInterval) {
        [self.refreshControl endRefreshing];
    } else {
        [self.refreshControl performSelector:@selector(endRefreshing) withObject:nil afterDelay:(minimumInterval-interval)];
    }
}


- (void)getProfile {
    FacebookAdapter *adapter = [AppDelegate instance].facebookAdapter;
    
    if([self.profileType isEqualToString:kFacebookProfileTypePersonal]){
        
        [adapter getProfile:^(NSDictionary* jsonResponse) {
            
            [self profileReceived:jsonResponse];
        
            [self getNumbers:self.profile.userId];
        }];
    }
    else{
        
        [adapter getPageProfile:^(NSDictionary* jsonResponse) {
            
            [self profileReceived:jsonResponse];
        }];
    }
      
}


-(void)profileReceived:(NSDictionary*)jsonResponse{
    
    if([self.profileType isEqualToString:kFacebookProfileTypePersonal]){
        self.profile = [[FacebookPersonalProfile alloc] initWithJSON:jsonResponse];
    }
    else{
        self.profile = [[FacebookPageProfile alloc] initWithJSON:jsonResponse];
    }
    
    
    [self.streamTableView setAlpha:1];
    [self.streamTableView reloadData];
}





- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        return 219;
    } else {
        return [self heightForCellAtIndex:indexPath.row];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0) {
        return 1;
    } else {
        return self.feed.count;
    }
    
}


- (NSString*)verifyMessagesFromDictionary:(NSDictionary*)dict inString:(NSString*)message {
    if ([(NSString*)[dict objectForKey:@"message"] length]>0)
        message = [NSString stringWithFormat:@"%@",[dict objectForKey:@"message"]];
    return message;
}

- (NSString*)verifyLinkFromDictionary:(NSDictionary*)dict {
    if ([(NSString*)[dict objectForKey:@"link"] length]>0)
        return (NSString*)[dict objectForKey:@"link"];
    else if ([(NSString*)[[[dict objectForKey:@"actions"] objectAtIndex:0]objectForKey:@"link"] length]>0)
        return (NSString*)[[[dict objectForKey:@"actions"] objectAtIndex:0]objectForKey:@"link"];
    
    if ([(NSString *)[dict objectForKey:@"id"] length]>0) {
        NSString *aux = [dict objectForKey:@"id"];
        NSArray *anArray = [aux componentsSeparatedByString:@"_"];
        aux = [NSString stringWithFormat:@"http://facebook.com/%@/posts/%@", [anArray objectAtIndex:0], [anArray objectAtIndex:1]];
        return aux;
    }
    return @"";
}

- (NSString*)verifyField:(NSString*)field FromDictionary:(NSDictionary*)dict inString:(NSString*)message {
    if ([(NSString*)[dict objectForKey:field] length] >0) {
        if (!message || [message isEqualToString:@""]) {
            message = [NSString stringWithFormat:@"%@",[dict objectForKey:field]];
        }
        else {
            message = [NSString stringWithFormat:@"%@\n%@",message,[dict objectForKey:field]];
        }
    }
    return message;
}

- (NSString*)verifyFieldApplicationsFromDictionary:(NSDictionary*)dict inString:(NSString*)message {
    if ([((NSString*)[[dict objectForKey:@"application"] objectForKey:@"name"]) rangeOfString:@"Facebook for"].location == 0) {
        if ([message isEqualToString:@""]) {
            message = [[dict objectForKey:@"application"] objectForKey:@"name"];
        }
    }
    return message;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        ProfileCell* cell = (ProfileCell*)[tableView dequeueReusableCellWithIdentifier:@"TweetProfileCell"];
        
        [cell.usernameLabel setText:self.profile.name];
        
        [cell.followingLabel setText:self.profile.socialCount1[@"name"]];
        [cell.followingCountLabel setText:[self.profile.socialCount1[@"count"] stringValue]];
        
        [cell.followerLabel setText:self.profile.socialCount2[@"name"]];
        [cell.followerCountLabel setText:[self.profile.socialCount2[@"count"] stringValue]];
        
        [cell.screenNameLabel setText:[NSString stringWithFormat:@"%@", self.profile.username]];
        
        if (self.imagesDictionary[kFacebookProfileImageKey]) {
            cell.profilePictureImageView.image = self.imagesDictionary[kFacebookProfileImageKey];
        } else {
            [self getImageFromUrl:self.profile.profileImageUrl asynchronouslyForImageView:cell.profilePictureImageView andKey:kFacebookProfileImageKey];
            
            [self getImageFromUrl:self.profile.profileCoverUrl asynchronouslyForImageView:cell.bannerImageView andKey:kFacebookBannerImageKey];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        FeedCell *cell = (FeedCell*)[tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
        
        NSDictionary *feedItem = self.feed[indexPath.row];
        NSDictionary *user = feedItem[@"from"];
        
        cell.usernameLabel.text = user[@"name"];
        
        cell.tweetLabel.text = [self messageFromDict:feedItem];
        
        cell.tweetLabel.frame =
        CGRectMake(cell.tweetLabel.frame.origin.x,
                   cell.tweetLabel.frame.origin.y,
                   tableView.bounds.size.width - 84,
                   [self heightForCellAtIndex:indexPath.row]-50);
        cell.tweetLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        cell.tweetLabel.font = [UIFont systemFontOfSize:13.0f];

        NSString *userName = user[@"name"];
        cell.profileImageView.image = nil;
        
        if (self.imagesDictionary[userName]) {
            cell.profileImageView.image = self.imagesDictionary[userName];
        } else {
            NSString* imageUrl = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=normal", user[@"id"]];
            
            [self getImageFromUrl:imageUrl asynchronouslyForImageView:cell.profileImageView andKey:userName];
        }
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
        NSDate *date = [dateFormat dateFromString:feedItem[@"created_time"]];
        
        cell.dateLabel.text = [Utils getTimeAsString:date];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }    
}

-(void)getImageFromUrl:(NSString*)imageUrl asynchronouslyForImageView:(UIImageView*)imageView andKey:(NSString*)key {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{        
        NSURL *url = [NSURL URLWithString:imageUrl];
        
        __block NSData *imageData;        
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            imageData =[NSData dataWithContentsOfURL:url];
            
            if(imageData) {            
                [self.imagesDictionary setObject:[UIImage imageWithData:imageData] forKey:key];
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    imageView.image = self.imagesDictionary[key];
                });
            }
        });
    });
}

- (NSString *)messageFromDict:(NSDictionary *)dict {
    NSString *message;
    //////STATUS
    if ([[dict objectForKey:@"type"] isEqualToString:@"status"]) {
        message = [self verifyMessagesFromDictionary:dict inString:message];
        message = [self verifyField:@"story" FromDictionary:dict inString:message];
        message = message ? [[NSMutableString stringWithString:message] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] : @"";
    }           //////PHOTO
    else if ([[dict objectForKey:@"type"] isEqualToString:@"photo"]) {
        message = [self verifyMessagesFromDictionary:dict inString:message];
        message = [self verifyField:@"story" FromDictionary:dict inString:message];
        message = [self verifyField:@"name" FromDictionary:dict inString:message];
        message = [self verifyField:@"caption" FromDictionary:dict inString:message];
        message = [self verifyFieldApplicationsFromDictionary:dict inString:message];
        message = message ? [[NSMutableString stringWithString:message] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] : @"";
    }           //////LINK
    else if ([[dict objectForKey:@"type"] isEqualToString:@"link"]) {
        message = [self verifyMessagesFromDictionary:dict inString:message];
        message = [self verifyField:@"story" FromDictionary:dict inString:message];
        message = [self verifyField:@"name" FromDictionary:dict inString:message];
        if ([[dict objectForKey:@"application"] count]>0) {
            message = [self verifyField:@"description" FromDictionary:dict inString:message];
        }
    }           //////VIDEO
    else if ([[dict objectForKey:@"type"] isEqualToString:@"video"]) {
        message = [self verifyMessagesFromDictionary:dict inString:message];
        message = [self verifyField:@"name" FromDictionary:dict inString:message];
        message = [self verifyField:@"description" FromDictionary:dict inString:message];
//        message = (NSString *)[[NSMutableString stringWithString:message] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }           ////CHECKIN
    else if ([[dict objectForKey:@"type"] isEqualToString:@"checkin"]) {
        message = [self verifyField:@"caption" FromDictionary:dict inString:message];
        message = message ? [[NSMutableString stringWithString:message] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] : @"";
    }
    else {
        message = [self verifyField:@"name" FromDictionary:dict inString:message];
        message = [self verifyField:@"story" FromDictionary:dict inString:message];
        message = [self verifyField:@"description" FromDictionary:dict inString:message];
    }
    
    return message;
}

- (CGFloat)heightForCellAtIndex:(NSUInteger)index {
    NSDictionary *feedItem = self.feed[index];
    CGFloat cellHeight = 50;
    NSString *feedText = [self messageFromDict:feedItem];
    
    CGSize labelHeight = [feedText sizeWithFont:[UIFont systemFontOfSize:13.0f] constrainedToSize:CGSizeMake(self.streamTableView.bounds.size.width - 84, 4000)];
    
    cellHeight += labelHeight.height;
    
    cellHeight = cellHeight > 70 ? cellHeight : 70;
    return cellHeight;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    if ([self.view window] == nil) {
        self.view = nil;
        _imagesDictionary = nil;
        _feed = nil; }
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewWillDisappear:animated];
}

@end
