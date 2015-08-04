//
//  TweetCell.m
//  ADVNewsFeeder
//
//  Created by Tope on 11/04/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "FeedCell.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"

@implementation FeedCell

-(void)awakeFromNib {
    [[AppDelegate instance].theme customizeTweetCell:self];
    
    CALayer* layer = self.profileImageContainer.layer;
    layer.cornerRadius = 1;
    layer.borderWidth = 3;
    layer.borderColor = [UIColor colorWithWhite:1.0f alpha:1.0f].CGColor;
    layer.shadowColor = [UIColor darkGrayColor].CGColor;
    layer.shadowOpacity = 0.5;
    layer.shadowOffset = CGSizeMake(1, 1);
    layer.shadowRadius = 1;
    
    self.profileImageView.layer.cornerRadius = 2;
}

@end
