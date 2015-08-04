//
//  FeedListModel.m
//  ADVNewsFeeder
//
//  Created by Tope on 30/04/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "FeedListModel.h"
#import "Configuration.h"
#import "DataLoader.h"

@interface FeedListModel ()

@property (nonatomic, strong) MWFeedParser *feedParser;

@property (nonatomic, retain) NSMutableArray *parsedItems;

@property (nonatomic, retain) NSArray *articles;

@end


@implementation FeedListModel


-(id)init{
    
    self = [super init];
    if(self){
        
        Configuration* config = [[Configuration alloc] init];
        NSURL *feedURL = [NSURL URLWithString:[config rssFeedUrl]];
        self.feedParser = [[MWFeedParser alloc] initWithFeedURL:feedURL];
        self.feedParser.delegate = self;
        self.feedParser.feedParseType = ParseTypeFull; // Parse feed info and all items
        self.feedParser.connectionType = ConnectionTypeAsynchronously;

    }
    
    return self;
}

- (void)dealloc {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    self.feedParser.delegate = nil;
}

- (void)parseFeed{
    
    self.parsedItems = [NSMutableArray array];
    [self.feedParser parse];
}

- (void)feedParserDidStart:(MWFeedParser *)parser {
	NSLog(@"Started Parsing: %@", parser.url);
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)info {
	NSLog(@"Parsed Feed Info: “%@”", info.title);
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item {
	NSLog(@"Parsed Feed Item: “%@”", item.title);
	if (item) [self.parsedItems addObject:item];
}

- (void)feedParserDidFinish:(MWFeedParser *)parser {
	NSLog(@"Finished Parsing%@", (parser.stopped ? @" (Stopped)" : @""));
    
    self.articles = [DataLoader loadDataFromFeedItems:self.parsedItems];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didFinishParsingFeedWithItems:wasSuccessful:)]) {
        [self.delegate didFinishParsingFeedWithItems:self.articles wasSuccessful:YES];
    }    
}

- (void)feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error {
	NSLog(@"Finished Parsing With Error: %@", error);
    if (self.parsedItems.count != 0) {
    
        // Failed but some items parsed, so show and inform of error
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Parsing Incomplete"
                                                        message:@"There was an error during the parsing of this feed. Not all of the feed items could parsed."
                                                       delegate:nil
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    [self.delegate didFinishParsingFeedWithItems:nil wasSuccessful:NO];
    
}



@end
