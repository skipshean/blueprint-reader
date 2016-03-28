//
//  TweetProfileCell.m
//  ADVNewsFeeder
//
//  Created by Tope on 16/04/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "ProfileCell.h"
#import "AppDelegate.h"

@implementation ProfileCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)awakeFromNib{
    
    [[AppDelegate instance].theme customizeTweetProfileCell:self];
}

@end
