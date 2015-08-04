//
//  FacebookPageProfile.m
//  ADVNewsFeeder
//
//  Created by Tope on 26/04/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "FacebookPageProfile.h"

@implementation FacebookPageProfile

-(id)initWithJSON:(NSDictionary*)jsonObject{
    if((self = [super init])){
        
        self.userId = [jsonObject objectForKey:@"id"];
        self.name = [jsonObject objectForKey:@"name"];
        self.username = [jsonObject objectForKey:@"username"];
        self.url = [jsonObject objectForKey:@"website"];
        
        self.profileImageUrl = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", self.username];
        
        self.profileCoverUrl = [jsonObject objectForKey:@"cover"][@"source"];
        
        [self getSocialCountsFromJSON:jsonObject];
    }
    
    return self;
}

- (void)getSocialCountsFromJSON:(NSDictionary*)jsonResponse{
    
    NSNumber *likeCount = jsonResponse[@"likes"];
    NSNumber *talkingAboutCount = jsonResponse[@"talking_about_count"];
    
    NSDictionary* likes = @{ @"name": @"LIKES", @"count" : likeCount };
    NSDictionary* talkingAbout = @{ @"name": @"TALKING ABOUT", @"count" : talkingAboutCount };
    
    self.socialCount1 =  likes;
    self.socialCount2 = talkingAbout;
    
}

@end
