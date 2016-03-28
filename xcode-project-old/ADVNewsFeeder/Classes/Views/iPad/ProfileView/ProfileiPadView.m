//
//  ProfileiPadCell.m
//  ADVNewsFeeder
//
//  Created by Valentin Filip on 5/15/13.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "ProfileiPadView.h"
#import "AppDelegate.h"

@implementation ProfileiPadView

-(void)awakeFromNib{
    [[AppDelegate instance].theme customizeFeedProfileiPadCell:self];
}

@end
