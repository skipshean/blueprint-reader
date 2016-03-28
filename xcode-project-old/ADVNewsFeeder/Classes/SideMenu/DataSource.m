//
//  DataSource.m
//  socioville
//
//  Created by Valentin Filip on 10.04.2012.
//  Copyright (c) 2012 App Design Vault. All rights reserved.
//

#import "DataSource.h"
#import "Configuration.h"

@implementation DataSource

@synthesize items;

+ (DataSource *)dataSource {
    DataSource *source = [[DataSource alloc] init];
    
    
    Configuration * config = [[Configuration alloc] init];
    NSString*  feedName = [config rssFeedName];
    
    source.items = @[
                     @{
                         @"title": @"RSS",
                         @"rows": @[
                                 @{@"name": feedName
                                   , @"imageName": @"menu-home"}
                                 ]
                         }
                     ,
                      @{
                          @"rows": @[
                                    @{@"name": @"Facebook"
                                      , @"imageName": @"menu-home"}
                                    , @{@"name": @"Twitter"
                                        , @"imageName": @"menu-eye"}
                                    ]
                      }
                      ,
                      @{
                          @"rows": @[
                                  @{@"name": @"Settings"
                                    , @"imageName": @"menu-clock"}
                                  ]
                          }];
    
    return source;
}

@end
