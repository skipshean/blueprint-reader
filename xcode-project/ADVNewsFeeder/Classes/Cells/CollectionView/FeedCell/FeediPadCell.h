//
//  FeediPadCell.h
//  ADVNewsFeeder
//
//  Created by Valentin Filip on 5/14/13.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeediPadCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UILabel* usernameLabel;

@property (nonatomic, weak) IBOutlet UILabel* tweetLabel;

@property (nonatomic, weak) IBOutlet UILabel* dateLabel;

@property (nonatomic, weak) IBOutlet UIImageView* profileImageView;

@property (nonatomic, weak) IBOutlet UIView* profileImageContainer;

@property (nonatomic, weak) IBOutlet UIImageView* bgImageView;

@end
