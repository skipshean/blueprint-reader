//
//  SwitchViewController.h
//  ADVNewsFeeder
//
//  Created by Tope on 09/05/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SwitchViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UINavigationController *newsNavigationController;

@property (nonatomic, strong) UINavigationController *twitterNavigationController;
@property (nonatomic, strong) UINavigationController *facebookNavigationController;
@property (strong, nonatomic) UINavigationController *settingsNavigationController;

@property (nonatomic, strong) UINavigationController *currentNavigationController;

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet UICollectionViewFlowLayout *collectionViewLayout;

@property (nonatomic, weak) IBOutlet UIView *collectionViewContainer;
@property (nonatomic, strong) NSArray *controllers;
@property (nonatomic, strong) NSArray *icons;
@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, assign) int currentIndex;
@property (nonatomic, assign) BOOL showSettings;
@property (nonatomic, assign) BOOL showSettingsTheme;


- (IBAction)toggleVisibility:(id)sender;

@end
