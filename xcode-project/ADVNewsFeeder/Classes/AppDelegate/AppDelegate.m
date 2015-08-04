//
//  AppDelegate.m
//  ADVNewsFeeder
//
//  Created by Tope on 09/04/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "AppDelegate.h"
#import "FacebookAdapter.h"
#import "ADVCustomTheme.h"

#import "FeedListController.h"
#import "PaperFoldNavigationController.h"
#import "SwitchViewController.h"


CGFloat kCollectionFeedWidthPortrait = 360;
CGFloat kCollectionFeedWidthLandscape = 320;


@implementation AppDelegate

+(AppDelegate*)instance{
    
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.accountStore = [[ACAccountStore alloc] init];
    self.facebookAdapter = [[FacebookAdapter alloc] init];
    self.twitterAdapter = [[TwitterAdapter alloc] init];
    
    if(UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad){
    
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detectOrientation) name:@"UIDeviceOrientationDidChangeNotification" object:nil];
        
        [self setupiPhoneViewControllers];
    }
    
    
    [self setupThemes];
    
    return YES;
}

- (void)setupiPhoneViewControllers {
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard"
                                                             bundle: nil];
    
    self.feedNavigationController = (UINavigationController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"FeedNavigationController"];
    
    self.menuViewController = [mainStoryboard instantiateViewControllerWithIdentifier: @"SideViewController"];
    
    [self.menuViewController setDelegate:self];
    
    PaperFoldNavigationController *paperFoldController = (PaperFoldNavigationController*)self.window.rootViewController;
    
    [paperFoldController setRootViewController:self.feedNavigationController];
    [paperFoldController setLeftViewController:self.menuViewController width:260];
}

- (void)resetAfterThemeChange:(BOOL)cancel {
    [self.theme customizeAppAppearance];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {        
        NSDictionary *theme;
        for (int idx = 0; idx < self.theme.sharediPadTheme.availableThemes.count; idx++) {
            NSDictionary *tempTheme = self.theme.sharediPadTheme.availableThemes[idx];
            if ([tempTheme[@"fileName"] isEqualToString:self.theme.sharediPadTheme.themeFileName]) {
                theme = tempTheme;
                break;
            }
        }
        [[NSUserDefaults standardUserDefaults] setValue:theme forKey:kADVThemeCurrentiPadTheme];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard-iPad"
                                                                 bundle: nil];
        SwitchViewController *switchVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"SwitchViewController"];
//        switchVC.showSettings = YES;
//        switchVC.showSettingsTheme = !cancel;
        self.window.rootViewController = switchVC;
        return;
    }
    
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard"
                                                             bundle: nil];
    self.settingsNavigationController = [mainStoryboard instantiateViewControllerWithIdentifier: @"SettingsNav"];
    self.feedNavigationController = (UINavigationController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"FeedNavigationController"];
    self.twitterNavigationController = [mainStoryboard instantiateViewControllerWithIdentifier: @"TwitterNavigationController"];
    self.facebookNavigationController = [mainStoryboard instantiateViewControllerWithIdentifier: @"FacebookNavigationController"];
    self.menuViewController = [mainStoryboard instantiateViewControllerWithIdentifier: @"SideViewController"];
    
    [self.menuViewController setDelegate:self];
    
    PaperFoldNavigationController *paperFoldController = (PaperFoldNavigationController*)self.window.rootViewController;
    
    [paperFoldController setRootViewController:self.settingsNavigationController];
    [paperFoldController setLeftViewController:self.menuViewController width:260];
    
    if (!cancel) {
        UINavigationController *navSettings = (UINavigationController *)self.settingsNavigationController;
        UIViewController *settingsVC = navSettings.viewControllers[0];
        [settingsVC performSegueWithIdentifier:@"selectThemeNoAnim" sender:settingsVC];
    }
}

- (void)detectOrientation {
    PaperFoldNavigationController *paperFoldController = (PaperFoldNavigationController*)self.window.rootViewController;
    if (paperFoldController.paperFoldView.state == PaperFoldStateLeftUnfolded) {
        [paperFoldController.paperFoldView setPaperFoldState:PaperFoldStateDefault animated:YES];
    }
}

- (void)togglePaperFold:(id)sender {
    PaperFoldNavigationController *paperFoldController = (PaperFoldNavigationController*)self.window.rootViewController;
    if (paperFoldController.paperFoldView.state == PaperFoldStateLeftUnfolded) {
        [paperFoldController.paperFoldView setPaperFoldState:PaperFoldStateDefault animated:YES];
    } else {
        [paperFoldController.paperFoldView setPaperFoldState:PaperFoldStateLeftUnfolded animated:YES];
    }
}

-(void)userDidSwitchToControllerAtIndexPath:(NSIndexPath*)indexPath{
    
    PaperFoldNavigationController *paperFoldController = (PaperFoldNavigationController*)self.window.rootViewController;
    
    switch (indexPath.section) {
        case 0:
            [paperFoldController setRootViewController:self.feedNavigationController];
            break;
        case 1: {
            if(indexPath.row == 0){
                if(!self.facebookNavigationController){
                    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard"
                                                                             bundle: nil];
                    self.facebookNavigationController = [mainStoryboard instantiateViewControllerWithIdentifier: @"FacebookNavigationController"];
                }
                
                [paperFoldController setRootViewController:self.facebookNavigationController];
            } else {                
                if(!self.twitterNavigationController){                    
                    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard"
                                                                             bundle: nil];
                    self.twitterNavigationController = [mainStoryboard instantiateViewControllerWithIdentifier: @"TwitterNavigationController"];
                }
                
                [paperFoldController setRootViewController:self.twitterNavigationController];
            }
            break;
        }
        case 2: {
            if(!self.settingsNavigationController){
                UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard"
                                                                         bundle: nil];
                self.settingsNavigationController = [mainStoryboard instantiateViewControllerWithIdentifier: @"SettingsNav"];
            }
            
            [paperFoldController setRootViewController:self.settingsNavigationController];
            break;
        }
        default:
            break;
    }

    [paperFoldController.paperFoldView setPaperFoldState:PaperFoldStateDefault animated:YES];
}

-(void)setupThemes{
    self.theme = [[ADVTheme alloc] init];
    
    [self.theme setupThemes];
  
    [self.theme customizeAppAppearance];
    
}

-(void)accessFacebookAccount{
    
    [self.facebookAdapter accessFacebookAccountWithAccountStore:self.accountStore];
}

-(void)accessTwitterAccount{
    
    [self.twitterAdapter accessTwitterAccountWithAccountStore:self.accountStore];
}

-(void)showError:(NSString*)errorMessage{
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:errorMessage
                                                       delegate:nil
                                              cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        [alertView show];
    });
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
