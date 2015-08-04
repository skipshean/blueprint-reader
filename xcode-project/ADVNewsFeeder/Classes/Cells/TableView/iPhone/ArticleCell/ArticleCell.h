//
//  ArticleCell.h
//  ADVNewsFeeder
//
//  Created by Tope on 09/04/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//
#define ArticleCellIdentifierTop @"ArticleCellTop"
#define ArticleCellIdentifierAll @"ArticleCell"
#define ArticleCellIdentifierNoImage @"ArticleCellNoImage"

#import <UIKit/UIKit.h>

@interface ArticleCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel* titleLabel;

@property (nonatomic, weak) IBOutlet UILabel* dateLabel;

@property (nonatomic, weak) IBOutlet UIImageView* articleImageView;

@property (nonatomic, weak) IBOutlet UIView* shadowView;

@property (nonatomic, weak) IBOutlet UIImageView* bgImageView;

@property (nonatomic, weak) IBOutlet UIImageView* articleFrameImageView;

@end
