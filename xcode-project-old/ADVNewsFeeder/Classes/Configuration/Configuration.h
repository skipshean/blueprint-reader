//
//  Configuration.h
//  ADVNewsFeeder
//
//  Created by Tope on 24/04/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Configuration : NSObject

@property NSDictionary* configuration;

-(NSString*)rssFeedName;

-(NSString*)rssFeedUrl;

-(NSString*)twitterUsername;

-(NSString*)facebookUsername;
-(NSString*)facebookProfileType;
-(NSString*)facebookAppId;

@end
