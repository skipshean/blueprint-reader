//
//  FacebookProfile.h
//  ADVNewsFeeder
//
//  Created by Valentin Filip on 4/23/13.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FacebookProfile : NSObject

@property (nonatomic, strong) NSNumber* userId;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSDictionary* socialCount1;
@property (nonatomic, strong) NSDictionary* socialCount2;
@property (nonatomic, strong) NSNumber* username;
@property (nonatomic, strong) NSString* url;
@property (nonatomic, strong) NSString* profileImageUrl;
@property (nonatomic, strong) NSString* profileCoverUrl;


- (id)initWithJSON:(NSDictionary*)jsonObject;
- (void)getSocialCountsFromJSON:(NSDictionary*)jsonObject;
@end
