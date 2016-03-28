//
//  ArticleCelliPad.h
//  ADVNewsFeeder
//
//  Created by Tope on 30/04/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArticleCelliPad : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UILabel* titleLabel;

@property (nonatomic, weak) IBOutlet UILabel* dateLabel;

@property (nonatomic, weak) IBOutlet UILabel* summaryLabel;

@property (nonatomic, weak) IBOutlet UIImageView* articleImageView;

@property (nonatomic, weak) IBOutlet UIImageView* articleFrameImageView;

@property (nonatomic, weak) IBOutlet UIImageView* bgImageView;


@end
