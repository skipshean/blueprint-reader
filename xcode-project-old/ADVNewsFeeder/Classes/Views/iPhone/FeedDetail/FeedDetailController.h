//
//  FeedDetailController.h
//  ADVNewsFeeder
//
//  Created by Tope on 10/04/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article.h"
#import "GKLParallaxPicturesViewController.h"


@interface FeedDetailController : GKLParallaxPicturesViewController <UIWebViewDelegate>

@property (nonatomic, weak) IBOutlet UIView* mainArticleView;

@property (nonatomic, weak) IBOutlet UILabel* dateLabel;

@property (nonatomic, weak) IBOutlet UILabel* titleLabel;

@property (nonatomic, weak) IBOutlet UIWebView* articleWebView;

@property (nonatomic, weak) IBOutlet UIView* shareButtonsContainer;

@property (nonatomic, weak) IBOutlet UIButton* twitterButton;

@property (nonatomic, weak) IBOutlet UIButton* facebookButton;

@property (nonatomic, strong) Article* article;

-(IBAction)shareButtonTapped:(id)sender;

@end
