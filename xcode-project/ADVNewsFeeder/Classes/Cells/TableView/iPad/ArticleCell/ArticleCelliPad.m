//
//  ArticleCelliPad.m
//  ADVNewsFeeder
//
//  Created by Tope on 30/04/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "ArticleCelliPad.h"
#import "AppDelegate.h"

@implementation ArticleCelliPad

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib{
    
    [[AppDelegate instance].theme customizeArticleCelliPad:self];
}

@end
