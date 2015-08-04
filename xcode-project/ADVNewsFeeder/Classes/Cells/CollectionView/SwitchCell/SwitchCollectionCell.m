//
//  SwitchCollectionCell.m
//  ADVNewsFeeder
//
//  Created by Tope on 09/05/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "SwitchCollectionCell.h"
#import "AppDelegate.h"

@implementation SwitchCollectionCell

-(void)awakeFromNib{
    
    [[AppDelegate instance].theme customizeSwitchCell:self];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.frame = CGRectIntegral(self.frame);
}

@end
