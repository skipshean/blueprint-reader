//
//  FeedListModel.h
//  ADVNewsFeeder
//
//  Created by Tope on 30/04/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MWFeedParser.h"

@protocol FeedListModelDelegate;

@interface FeedListModel : NSObject <MWFeedParserDelegate>

@property (nonatomic, assign) id<FeedListModelDelegate> delegate;

- (void)parseFeed;

@end



@protocol FeedListModelDelegate <NSObject>

-(void)didFinishParsingFeedWithItems:(NSArray*)items wasSuccessful:(BOOL)success;

@end
