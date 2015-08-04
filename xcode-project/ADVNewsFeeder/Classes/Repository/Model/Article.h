//
//  Model.h
//  ADVNewsFeeder
//
//  Created by Tope on 04/04/2013.
//  Copyright (c) 2012 AppDesignVault. All rights reserved.
//



@interface Article : NSObject

@property (nonatomic, copy) NSString* title;

@property (nonatomic, copy) NSString* excerpt;

@property (nonatomic, strong) NSDate* date;

@property (nonatomic, strong) NSArray* tags;

@property (nonatomic, strong) NSString* imageUrl;

@property (nonatomic, strong) UIImage* image;

@property (nonatomic, copy) NSString* content;

@property (nonatomic, copy) NSString* dateString;

@property (nonatomic, copy) NSString* link;

-(id)initWithTitle:(NSString*)theTitle 
       andExcerpt:(NSString*)theExcerpt 
        andDate:(NSDate*)theDate 
       andTags:(NSArray*)theTags 
          andImageUrl:(NSString*)theImageUrl
           andLink:(NSString*)theLink
        andContent:(NSString*)theContent;

@end
