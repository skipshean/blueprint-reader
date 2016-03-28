//
//  FeediPadCell.m
//  ADVNewsFeeder
//
//  Created by Valentin Filip on 5/14/13.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "FeediPadCell.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@implementation FeediPadCell

-(void)awakeFromNib {
    [[AppDelegate instance].theme customizeFeediPadCell:self];

}

@end
