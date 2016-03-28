//
//  TwitterProfile.m
//  ADVNewsFeeder
//
//  Created by Tope on 16/04/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "TwitterProfile.h"

@implementation TwitterProfile

-(id)initWithJSON:(NSDictionary*)jsonObject{
    
    self = [super init];
    
    if(self){
        
        self.name = [jsonObject objectForKey:@"name"];
        self.followerCount = [jsonObject objectForKey:@"followers_count"];
        self.followingCount = [jsonObject objectForKey:@"friends_count"];
        self.screenName = [jsonObject objectForKey:@"screen_name"];
        self.url = [jsonObject objectForKey:@"url"];
        
        //Get larger Twitter Profile image
        //Ref: https://dev.twitter.com/docs/user-profile-images-and-banners
        
        self.profileImageUrl = [jsonObject objectForKey:@"profile_image_url"];
        self.profileImageUrl = [self.profileImageUrl stringByReplacingOccurrencesOfString:@"_normal" withString:@"_bigger"];
        
        self.profileBannerUrl = [jsonObject objectForKey:@"profile_banner_url"];
        if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
            ([UIScreen mainScreen].scale == 2.0)) {
            self.profileBannerUrl = [self.profileBannerUrl stringByAppendingString:@"/mobile_retina"];
        } else {
            self.profileBannerUrl = [self.profileBannerUrl stringByAppendingString:@"/mobile"];
        }
        
    }
    
    return self;
}

@end
