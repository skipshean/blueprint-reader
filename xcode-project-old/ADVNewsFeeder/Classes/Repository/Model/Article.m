//
//  Model.m
//  ADVNewsFeeder
//
//  Created by Tope on 04/04/2013.
//  Copyright (c) 2012 AppDesignVault. All rights reserved.
//

#import "Article.h"

@implementation Article


-(id)initWithTitle:(NSString*)theTitle 
        andExcerpt:(NSString*)theExcerpt 
           andDate:(NSDate*)theDate 
           andTags:(NSArray*)theTags 
        andImageUrl:(NSString*)theImageUrl
           andLink:(NSString*)theLink
        andContent:(NSString*)theContent;
{
    self = [super init];
    
    if(self)
    {
        self.title = theTitle;
        self.excerpt = theExcerpt;
        self.imageUrl = theImageUrl;
        self.tags = theTags;
        self.content = theContent;
        
        self.date = theDate;
        self.link = theLink;
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd MMM yyyy / h:mm:ss a"];
        self.dateString = [dateFormat stringFromDate:self.date];
    }
    
    return self;
}



@end
