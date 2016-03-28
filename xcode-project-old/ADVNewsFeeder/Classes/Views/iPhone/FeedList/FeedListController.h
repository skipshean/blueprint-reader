//
//  FeedListController.h
//  ADVNewsFeeder
//
//  Created by Tope on 09/04/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWFeedParser.h"
#import "FeedListModel.h"


@interface FeedListController : UIViewController <UITableViewDataSource, UITableViewDelegate, FeedListModelDelegate>

@property (nonatomic, weak) IBOutlet UITableView* feedTableView;

@property (nonatomic, strong) NSArray* articles;

@property (nonatomic, strong) FeedListModel *model;

-(void)didFinishParsingFeedWithItems:(NSArray *)items wasSuccessful:(BOOL)success;


@end
