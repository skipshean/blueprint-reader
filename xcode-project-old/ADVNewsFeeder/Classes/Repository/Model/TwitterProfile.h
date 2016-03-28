//
//  TwitterProfile.h
//  ADVNewsFeeder
//
//  Created by Tope on 16/04/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TwitterProfile : NSObject

@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSNumber* followerCount;
@property (nonatomic, strong) NSNumber* followingCount;
@property (nonatomic, strong) NSNumber* twitterId;
@property (nonatomic, strong) NSString* screenName;
@property (nonatomic, strong) NSString* url;
@property (nonatomic, strong) NSString* profileImageUrl;
@property (nonatomic, strong) NSString* profileBannerUrl;


-(id)initWithJSON:(NSDictionary*)jsonObject;

@end
