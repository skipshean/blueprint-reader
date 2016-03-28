//
//  FacebookAccount.m
//  ADVNewsFeeder
//
//  Created by Tope on 10/04/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//
#define AccountFacebookAccessGranted @"FacebookAccessGranted"

#import "FacebookAdapter.h"

#import "Configuration.h"


@implementation FacebookAdapter


- (void)accessFacebookAccountWithAccountStore:(ACAccountStore*)accountStore {
    [self accessFacebookAccountWithAccountStore:accountStore requestPermissions:NO];
}

- (void)accessFacebookAccountWithAccountStore:(ACAccountStore*)accountStore requestPermissions:(BOOL)reqPerms {
    ACAccountType *facebookAccountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    
    Configuration* config = [[Configuration alloc] init];
    
    NSArray *permissions =  (reqPerms ? @[@"email"] : @[]);
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{        
        NSDictionary *facebookOptions = @{ACFacebookAppIdKey : [config facebookAppId],
                                          ACFacebookPermissionsKey : permissions,
                                          ACFacebookAudienceKey : ACFacebookAudienceEveryone };
        
        [accountStore requestAccessToAccountsWithType:facebookAccountType options:facebookOptions completion:^(BOOL granted, NSError *error) {
            
            if (granted) {                
                self.account = [[accountStore accountsWithAccountType:facebookAccountType] lastObject];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter]
                     postNotificationName:AccountFacebookAccessGranted
                     object:nil];
                });
                
//                [self getStreamWithAccountStore:accountStore];
            } else {
                if (error) {
                    if([error code] == ACErrorAccountNotFound) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Facebook Error"
                                                                                message:@"Account not found. Please setup your account in settings app."
                                                                               delegate:nil
                                                                      cancelButtonTitle:@"OK"
                                                                      otherButtonTitles:nil];
                            [alertView show];
                        });
                    } else {
                        if (!reqPerms) {
                            [self accessFacebookAccountWithAccountStore:accountStore requestPermissions:YES];
                        } else {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Facebook Error"
                                                                                    message:[error localizedDescription]
                                                                                   delegate:nil
                                                                          cancelButtonTitle:@"OK"
                                                                          otherButtonTitles:nil];
                                [alertView show];
                            });
                        }
                    }
                } else {
                    if (!reqPerms) {
                        [self accessFacebookAccountWithAccountStore:accountStore requestPermissions:YES];
                    } else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Facebook Error"
                                                                                message:@"Account access denied."
                                                                               delegate:nil
                                                                      cancelButtonTitle:@"OK"
                                                                      otherButtonTitles:nil];
                            [alertView show];
                        });
                    }
                }
                
            }
        }];
    });    
}

- (void)getStreamWithAccountStore:(ACAccountStore*)accountStore {
    ACAccountType *facebookAccountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    
    Configuration* config = [[Configuration alloc] init];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDictionary *facebookOptions = @{
                                          ACFacebookAppIdKey : [config facebookAppId],
                                          ACFacebookPermissionsKey : @[@"publish_stream"],
                                          ACFacebookAudienceKey : ACFacebookAudienceEveryone };
        [accountStore requestAccessToAccountsWithType:facebookAccountType options:facebookOptions completion:^(BOOL granted,
                                              NSError *error) {
             if (granted) {
                 self.account = [[accountStore accountsWithAccountType:facebookAccountType] lastObject];
                 
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [[NSNotificationCenter defaultCenter]
                      postNotificationName:AccountFacebookAccessGranted
                      object:nil];
                 });
             } else {
                 if (error) {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Facebook Error"
                                                                             message:[error localizedDescription]
                                                                            delegate:nil
                                                                   cancelButtonTitle:@"OK"
                                                                   otherButtonTitles:nil];
                         [alertView show];
                     });
                 } else {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Facebook Error"
                                                                             message:[error localizedDescription]
                                                                            delegate:nil
                                                                   cancelButtonTitle:@"OK"
                                                                   otherButtonTitles:nil];
                         [alertView show];
                     });
                 }
             }
         }];
    });
    
}


- (void)getProfile:(void (^)(NSDictionary* jsonResponse))completion {
    Configuration* config = [[Configuration alloc] init];
    
    SLRequest *request = [SLRequest
                          requestForServiceType:SLServiceTypeFacebook
                          requestMethod:SLRequestMethodGET
                          URL:[NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@", [config facebookUsername]]]
                          parameters:@{ @"fields" : @"cover,first_name,last_name,link,username" }];
    
    request.account = self.account;
    
    [request performRequestWithHandler:^(NSData *responseData,
                                         NSHTTPURLResponse *urlResponse, NSError *error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Facebook Error"
                                                                    message:[NSString stringWithFormat:
                                                                             @"There was an error reading your Facebook feed. %@", [error localizedDescription]]
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                [alertView show];
            });
        } else {
            NSError *jsonError;
            NSDictionary *responseJSON = [NSJSONSerialization
                                          JSONObjectWithData:responseData
                                          options:NSJSONReadingAllowFragments
                                          error:&jsonError];
            
            if (jsonError) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Facebook Error"
                                                                        message:[NSString stringWithFormat:
                                                                                 @"There was an error reading your Facebook feed. %@", [error localizedDescription]]
                                                                       delegate:nil
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                    [alertView show];
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if(completion){
                        completion(responseJSON);
                    }
                });
            }
        }
    }];
}

- (void)getFeed:(void (^)(NSArray* jsonResponse))completion {
    Configuration* config = [[Configuration alloc] init];
    SLRequest *request = [SLRequest
                          requestForServiceType:SLServiceTypeFacebook
                          requestMethod:SLRequestMethodGET
                          URL:[NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/feed", [config facebookUsername]]]
                          parameters:@{ @"limit" : @"50" }];
    
    request.account = self.account;
    
    [request performRequestWithHandler:^(NSData *responseData,
                                         NSHTTPURLResponse *urlResponse, NSError *error) {        
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Facebook Error"
                                                                    message:[NSString stringWithFormat:
                                                                             @"There was an error reading your Facebook feed. %@", [error localizedDescription]]
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                [alertView show];
            });
        } else {
            NSError *jsonError;
            NSDictionary *responseJSON = [NSJSONSerialization
                                          JSONObjectWithData:responseData
                                          options:NSJSONReadingAllowFragments
                                          error:&jsonError];
            
            if (jsonError) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Facebook Error"
                                                                        message:[NSString stringWithFormat:
                                                                                 @"There was an error reading your Facebook feed. %@", [error localizedDescription]]
                                                                       delegate:nil
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                    [alertView show];
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{                    
                    if(completion){
                        completion(responseJSON[@"data"]);
                    }
                });
            }
        }
    }];
}

- (void)getFriendAndSubscriberCountOfUser:(NSNumber*)userId withCompleteion:(void (^)(NSDictionary* jsonResponse))completion{
    

    NSString *query = [NSString stringWithFormat:@"SELECT friend_count, subscriber_count FROM user WHERE uid = %@", userId];
    SLRequest *request = [SLRequest
                          requestForServiceType:SLServiceTypeFacebook
                          requestMethod:SLRequestMethodGET
                          URL:[NSURL URLWithString:@"https://graph.facebook.com/fql"]
                          parameters:[NSDictionary dictionaryWithObject:query forKey:@"q"]];
    
    request.account = self.account;
    
    [request performRequestWithHandler:^(NSData *responseData,
                                         NSHTTPURLResponse *urlResponse, NSError *error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Facebook Error"
                                                                    message:[NSString stringWithFormat:
                                                                             @"There was an error reading your Facebook friend count. %@", [error localizedDescription]]
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                [alertView show];
             });
        } else {
            NSError *jsonError;
            NSDictionary *responseJSON = [NSJSONSerialization
                                          JSONObjectWithData:responseData
                                          options:NSJSONReadingAllowFragments
                                          error:&jsonError];
            
            if (jsonError) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Facebook Error"
                                                                        message:[NSString stringWithFormat:
                                                                                 @"There was an error reading your Facebook friend count. %@", [error localizedDescription]]
                                                                       delegate:nil
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                    [alertView show];
                });
            } else {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if(completion){
                        completion(responseJSON);
                    }
                });
                
            }
        }
    }];
}


- (void)getPageProfile:(void (^)(NSDictionary* jsonResponse))completion {
    Configuration* config = [[Configuration alloc] init];
    
    SLRequest *request = [SLRequest
                          requestForServiceType:SLServiceTypeFacebook
                          requestMethod:SLRequestMethodGET
                          URL:[NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@", [config facebookUsername]]]
                          parameters:@{ @"fields" : @"likes,website,name,username,talking_about_count" }];
    
    request.account = self.account;
    
    [request performRequestWithHandler:^(NSData *responseData,
                                         NSHTTPURLResponse *urlResponse, NSError *error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Facebook Error"
                                                                    message:[NSString stringWithFormat:
                                                                             @"There was an error reading your Facebook feed. %@", [error localizedDescription]]
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                [alertView show];
            });
        } else {
            NSError *jsonError;
            NSDictionary *responseJSON = [NSJSONSerialization
                                          JSONObjectWithData:responseData
                                          options:NSJSONReadingAllowFragments
                                          error:&jsonError];
            
            if (jsonError) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Facebook Error"
                                                                        message:[NSString stringWithFormat:
                                                                                 @"There was an error reading your Facebook feed. %@", [error localizedDescription]]
                                                                       delegate:nil
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                    [alertView show];
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if(completion){
                        completion(responseJSON);
                    }
                });
            }
        }
    }];
}


@end
