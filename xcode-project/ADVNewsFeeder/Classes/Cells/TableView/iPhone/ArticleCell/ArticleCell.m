//
//  ArticleCell.m
//  ADVNewsFeeder
//
//  Created by Tope on 09/04/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "ArticleCell.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@implementation ArticleCell

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
    
    [[AppDelegate instance].theme customizeArticleCell:self];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [[AppDelegate instance].theme customizeArticleCell:self];
}


@end
