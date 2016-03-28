//
//  DataLoader.h
//  ADVNewsFeeder
//
//  Created by Tope on 04/04/2013.
//  Copyright (c) 2012 AppDesignVault. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataLoader : NSObject

+(NSArray*)loadDataFromFeedItems:(NSArray*)feedItems;

@end
