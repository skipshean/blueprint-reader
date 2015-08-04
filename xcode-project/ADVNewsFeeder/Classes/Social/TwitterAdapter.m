//
//  TwitterAdapter.m
//  ADVNewsFeeder
//
//  Created by Tope on 10/04/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "TwitterAdapter.h"
#import "AppDelegate.h"
#import "Configuration.h"

@interface TwitterAdapter ()

@property (strong, nonatomic) ACAccountStore *accountStore;

@end


@implementation TwitterAdapter

-(void)accessTwitterAccountWithAccountStore:(ACAccountStore*)store{
   
    self.accountStore = store;
    ACAccountType *twitterAccountType = [self.accountStore
                                         accountTypeWithAccountTypeIdentifier:
                                         ACAccountTypeIdentifierTwitter];
    
    dispatch_async(dispatch_get_global_queue(
                                             DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.accountStore
         requestAccessToAccountsWithType:twitterAccountType
         options:nil completion:^(BOOL granted, NSError *error)
         {
             if (granted)
             {
                 NSArray *twitterAccounts = [self.accountStore
                                             accountsWithAccountType:twitterAccountType];
                
                 NSString *twitterAccountIdentifier = [[NSUserDefaults standardUserDefaults] objectForKey:AccountTwitterSelectedIdentifier];
                 
                 self.account = [self.accountStore accountWithIdentifier:twitterAccountIdentifier];
                 
                 if (self.account)
                 {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         
                         [[NSNotificationCenter defaultCenter] postNotificationName:AccountTwitterAccessGranted object:nil];
                     });
                 }
                 else
                 {
                     [[NSUserDefaults standardUserDefaults] removeObjectForKey:AccountTwitterSelectedIdentifier];
                     
                     [[NSUserDefaults standardUserDefaults] synchronize];
                     
                     if (twitterAccounts.count > 1)
                     {
                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Select an account"
                                                                             message:@"Please choose one of your Twitter accounts"
                                                                            delegate:self
                                                                   cancelButtonTitle:@"Cancel"
                                                                   otherButtonTitles:nil];
                         
                         for (ACAccount *account in twitterAccounts)
                         {
                             [alertView addButtonWithTitle:account.accountDescription];
                         }
                         
                         dispatch_async(
                                        dispatch_get_main_queue(), ^{
                                            [alertView show];
                                        });
                     }
                     else
                     {
                         self.account = [twitterAccounts lastObject];
                         
                         dispatch_async(
                                        dispatch_get_main_queue(), ^{
                                            
                                            [[NSNotificationCenter defaultCenter] postNotificationName:AccountTwitterAccessGranted
                                             object:nil];
                                        });
                     }
                 }
             }
             else
             {
                 if (error)
                 {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Twitter Error"
                                                                             message:@"Please make sure you have a Twitter account set up in Settings. Also grant access to this app"
                                                                            delegate:nil
                                                                   cancelButtonTitle:@"Dismiss"
                                                                   otherButtonTitles:nil];
                         [alertView show];
                     });
                 }
                 else
                 {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Twitter Error"
                                                                             message:@"We can't access Facebook, please add an account in the Settings app"
                                                                            delegate:nil
                                                                   cancelButtonTitle:@"Dimiss"
                                                                   otherButtonTitles:nil];
                         [alertView show];
                     });
                 }
             }
         }];
    });

}

- (void)refreshTwitterFeedWithCompletion:(void (^)(NSArray* jsonResponse))completion {
    
    if(!self.account){
        ACAccountStore* store = [AppDelegate instance].accountStore;
        [self accessTwitterAccountWithAccountStore:store];
        return;
    }
    
    Configuration* config = [[Configuration alloc] init];
    
    
    NSURL* url = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/user_timeline.json"];
    NSDictionary* params = @{@"count" : @"50", @"screen_name" : [config twitterUsername]};
    
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                            requestMethod:SLRequestMethodGET
                                                      URL:url parameters:params];
    
    request.account = self.account;
    
    [request performRequestWithHandler:^(NSData *responseData,
                                         NSHTTPURLResponse *urlResponse, NSError *error) {

        
        if (error)
        {
            NSString* errorMessage = [NSString stringWithFormat:@"There was an error reading your Twitter feed. %@",
                                      [error localizedDescription]];
            
            [[AppDelegate instance] showError:errorMessage];
        }
        else
        {
            NSError *jsonError;
            NSArray *responseJSON = [NSJSONSerialization
                                     JSONObjectWithData:responseData
                                     options:NSJSONReadingAllowFragments
                                     error:&jsonError];
            
            if (jsonError)
            {
                NSString* errorMessage = [NSString stringWithFormat:@"There was an error reading your Twitter feed. %@",
                                          [jsonError localizedDescription]];
                
                [[AppDelegate instance] showError:errorMessage];
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if(completion){
                        completion(responseJSON);
                    }
                });
            }
        }
    }];
}

- (void)getTwitterProfileWithCompletion:(void (^)(NSDictionary* jsonResponse))completion {
    
    if(!self.account){
        ACAccountStore* store = [AppDelegate instance].accountStore;
        [self accessTwitterAccountWithAccountStore:store];
        return;
    }
    
    Configuration* config = [[Configuration alloc] init];
     
    NSURL* url = [NSURL URLWithString:@"http://api.twitter.com/1.1/users/show.json"];
    NSDictionary* params = @{@"screen_name" : [config twitterUsername]};
    
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                            requestMethod:SLRequestMethodGET
                                                      URL:url parameters:params];
    
    request.account = self.account;
    
    [request performRequestWithHandler:^(NSData *responseData,
                                         NSHTTPURLResponse *urlResponse, NSError *error) {
        
        
        if (error)
        {
            NSString* errorMessage = [NSString stringWithFormat:@"There was an error reading your Twitter feed. %@",
                                      [error localizedDescription]];
            
            [[AppDelegate instance] showError:errorMessage];
        }
        else
        {
            NSError *jsonError;
            NSDictionary *responseJSON = [NSJSONSerialization
                                     JSONObjectWithData:responseData
                                     options:NSJSONReadingMutableLeaves
                                     error:&jsonError];
            
            if (jsonError)
            {
                NSString* errorMessage = [NSString stringWithFormat:@"There was an error reading your Twitter feed. %@",
                                          [jsonError localizedDescription]];
                
                [[AppDelegate instance] showError:errorMessage];
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if(completion){
                        completion(responseJSON);
                    }
                });
            }
        }
    }];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex) {
        
        ACAccountType *twitterAccountType = [self.accountStore accountTypeWithAccountTypeIdentifier:
                                             ACAccountTypeIdentifierTwitter];
        NSArray *twitterAccounts = [self.accountStore
                                    accountsWithAccountType:twitterAccountType];
        
        self.account = twitterAccounts[(buttonIndex - 1)];
        
        [[NSUserDefaults standardUserDefaults] setObject:self.account.identifier forKey:AccountTwitterSelectedIdentifier];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:AccountTwitterAccessGranted object:nil];
    }

}
@end
