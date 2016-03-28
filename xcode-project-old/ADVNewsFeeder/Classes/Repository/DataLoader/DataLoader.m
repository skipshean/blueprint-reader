//
//  DataLoader.m
//  ADVNewsFeeder
//
//  Created by Tope on 04/04/2013.
//  Copyright (c) 2012 AppDesignVault. All rights reserved.
//

#import "DataLoader.h"
#import "Article.h"
#import "MWFeedItem.h"

@implementation DataLoader


+(NSArray*)loadDataFromFeedItems:(NSArray*)feedItems
{
    NSMutableArray* array = [NSMutableArray array];
    for (MWFeedItem* item in feedItems) {
        
        NSString* content = item.content ? item.content : item.summary;
        
        NSString* imageUrl = [self getFirstImageFromContent:content];
        
        if([imageUrl length] == 0){
            imageUrl = [self getImageFromEnclosures:item];
        }
         
        Article* m = [[Article alloc] initWithTitle:item.title andExcerpt:content andDate:item.date andTags:nil andImageUrl:imageUrl andLink:item.link andContent:content];
        
        [array addObject:m];
    }
    
    return [NSArray arrayWithArray:array];
}

+(NSString *)getFirstImageFromContent: (NSString *) html
{
    
    NSString *imageUrl = [[NSString alloc]initWithFormat:@""];
    NSScanner * pageScanner = [NSScanner scannerWithString:html];
    
    [pageScanner setCaseSensitive:NO];
    [pageScanner setCharactersToBeSkipped:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [pageScanner scanUpToString:@"<img " intoString:nil];
    [pageScanner scanString:@"<img " intoString:nil];
    [pageScanner scanUpToString:@"src=\"" intoString:nil];
    [pageScanner scanString:@"src=\"" intoString:nil];
    
    [pageScanner scanUpToString:@"\"" intoString:&imageUrl];
    
    return imageUrl;
}

+(NSString*)getImageFromEnclosures:(MWFeedItem*)item{
    
    for (NSDictionary* enclosure in item.enclosures) {
        
        NSString* type = enclosure[@"type"];
        
        NSRange range = [type rangeOfString:@"image" options:NSCaseInsensitiveSearch];
        if(range.location == 0){
            return enclosure[@"url"];
        }
    }
    
    return nil;
}

@end
