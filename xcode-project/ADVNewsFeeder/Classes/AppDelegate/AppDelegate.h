//
//  AppDelegate.h
//  ADVNewsFeeder
//
//  Created by Tope on 09/04/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FacebookAdapter.h"
#import "ADVTheme.h"
#import "TwitterAdapter.h"
#import "MenuViewController.h"

extern CGFloat kCollectionFeedWidthPortrait;
extern CGFloat kCollectionFeedWidthLandscape;

//@class FeedListController;
//@class TwitterFeedViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, MenuViewControllerDelegate>

+(AppDelegate*)instance;

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ACAccountStore *accountStore;

@property (strong, nonatomic) FacebookAdapter *facebookAdapter;

@property (strong, nonatomic) TwitterAdapter *twitterAdapter;

@property (nonatomic, strong) ADVTheme* theme;

@property (strong, nonatomic) MenuViewController *menuViewController;

@property (strong, nonatomic) UINavigationController *feedNavigationController;

@property (strong, nonatomic) UINavigationController *twitterNavigationController;
@property (strong, nonatomic) UINavigationController *facebookNavigationController;
@property (strong, nonatomic) UINavigationController *settingsNavigationController;

-(void)accessFacebookAccount;

-(void)accessTwitterAccount;

-(void)showError:(NSString*)errorMessage;

-(void)userDidSwitchToControllerAtIndexPath:(NSIndexPath*)index;
- (void)togglePaperFold:(id)sender;

- (void)resetAfterThemeChange:(BOOL)cancel;

@end
