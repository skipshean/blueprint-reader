//
//  FacebookPersonalProfile.m
//  ADVNewsFeeder
//
//  Created by Tope on 26/04/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "FacebookPersonalProfile.h"

@implementation FacebookPersonalProfile


-(id)initWithJSON:(NSDictionary*)jsonObject{
    if((self = [super init])){
        
        self.userId = [jsonObject objectForKey:@"id"];
        self.name = [NSString stringWithFormat:@"%@ %@", [jsonObject objectForKey:@"first_name"], [jsonObject objectForKey:@"last_name"]];
        self.username = [jsonObject objectForKey:@"username"];
        self.url = [jsonObject objectForKey:@"link"];
        
        self.profileImageUrl = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", self.username];
        
        self.profileCoverUrl = [jsonObject objectForKey:@"cover"][@"source"];
    }
    
    return self;
}

- (void)getSocialCountsFromJSON:(NSDictionary*)jsonResponse{
    
    NSNumber *friendsCount = jsonResponse[@"data"][0][@"friend_count"];
    NSNumber *subscribersCount = jsonResponse[@"data"][0][@"subscriber_count"];
    
    NSDictionary* friends = @{ @"name": @"FRIENDS", @"count" : friendsCount };
    NSDictionary* subscribers = @{ @"name": @"SUBSCRIBERS", @"count" : subscribersCount };
    
    self.socialCount1 =  friends;
    self.socialCount2 = subscribers;

}

@end
