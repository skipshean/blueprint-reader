//
//  ProfileiPadCell.h
//  ADVNewsFeeder
//
//  Created by Valentin Filip on 5/15/13.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileiPadView : UIView

@property (nonatomic, weak) IBOutlet UIImageView* profilePictureImageView;

@property (nonatomic, weak) IBOutlet UIImageView* bannerImageView;

@property (nonatomic, weak) IBOutlet UIView* profilePictureContainer;

@property (nonatomic, weak) IBOutlet UILabel* usernameLabel;

@property (nonatomic, weak) IBOutlet UILabel* screenNameLabel;

@property (nonatomic, weak) IBOutlet UILabel* followingCountLabel;

@property (nonatomic, weak) IBOutlet UILabel* followerCountLabel;

@property (nonatomic, weak) IBOutlet UILabel* followingLabel;

@property (nonatomic, weak) IBOutlet UILabel* followerLabel;

@property (nonatomic, weak) IBOutlet UIView* overlayView;

@property (nonatomic, weak) IBOutlet UIView* statsBarView;

@end
