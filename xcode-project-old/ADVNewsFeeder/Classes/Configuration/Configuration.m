//
//  Configuration.m
//  ADVNewsFeeder
//
//  Created by Tope on 24/04/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "Configuration.h"

@implementation Configuration


- (id)init {
    
    self = [super init];
    
    if(self){
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Configuration" ofType:@"plist" inDirectory:@"Configuration"];
        
        self.configuration = [[NSDictionary alloc] initWithContentsOfFile:path];
    }
   
    return self;
}

-(NSString*)rssFeedName{
    
    return _configuration[NSStringFromSelector(_cmd)];
}


-(NSString*)rssFeedUrl{
    
    return _configuration[NSStringFromSelector(_cmd)];
}

-(NSString*)twitterUsername{
    return _configuration[NSStringFromSelector(_cmd)];
}

-(NSString*)facebookUsername{
    return _configuration[NSStringFromSelector(_cmd)];
}

-(NSString*)facebookProfileType{
   return _configuration[NSStringFromSelector(_cmd)]; 
}

-(NSString*)facebookAppId{
   return _configuration[NSStringFromSelector(_cmd)];  
}


@end
