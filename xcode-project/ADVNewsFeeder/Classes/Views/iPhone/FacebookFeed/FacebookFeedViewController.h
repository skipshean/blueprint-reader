//
//  TwitterFeedViewController.h
//  ADVNewsFeeder
//
//  Created by Tope on 11/04/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FacebookFeedViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView* streamTableView;
@end
