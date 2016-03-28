//
//  FacebookAccount.h
//  ADVNewsFeeder
//
//  Created by Tope on 10/04/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#define AccountFacebookAccessGranted @"FacebookAccessGranted"
#define AccountFacebookSelectedIdentifier @"FacebookAccountSelectedIdentifier"

#import <Foundation/Foundation.h>

@interface FacebookAdapter : NSObject

@property (nonatomic, strong) ACAccount* account;

- (void)accessFacebookAccountWithAccountStore:(ACAccountStore*)accountStore;
- (void)getProfile:(void (^)(NSDictionary* jsonResponse))completion;
- (void)getFeed:(void (^)(NSArray* jsonResponse))completion;
- (void)getFriendAndSubscriberCountOfUser:(NSNumber*)userId withCompleteion:(void (^)(NSDictionary* jsonResponse))completion;
- (void)getPageProfile:(void (^)(NSDictionary* jsonResponse))completion;
@end
