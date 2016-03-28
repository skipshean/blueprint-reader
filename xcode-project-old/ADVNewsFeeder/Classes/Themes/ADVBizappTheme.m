//
//  ADVBizappTheme.m
//  ADVTimelineDesign
//
//  Created by Tope on 19/03/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "ADVBizappTheme.h"

@implementation ADVBizappTheme

-(id)initWithIndex:(int)index{
    
    self = [super init];
    
    if(self){
        self.index = index;
    }
    
    return self;
}

-(NSString*)name{
    
    if(self.index == 0){
        return @"Biz App Blue";
    }
    else if (self.index == 1){
        return @"Biz App Green";
    }
    else{
        return @"Biz App Brown";
    }
}

- (UIImage *)navigationImage{
    
    if(self.index == 0){
        return [UIImage imageNamed:@"bizapp-menubar.png"];
    }
    else if (self.index == 1){
        return [UIImage imageNamed:@"g-bizapp-menubar.png"];
    }
    else{
        return [UIImage imageNamed:@"b-bizapp-menubar.png"];
    }
}

- (UIImage *)barButtonImage{
    return [[UIImage imageNamed:@"bizapp-menu-bar-button"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
}

- (UIImage *)backButtonImage{
    return [[UIImage imageNamed:@"bizapp-back"] resizableImageWithCapInsets:UIEdgeInsetsMake(0 ,15,0 ,8)];
}

- (UIImage *)viewBackground{
    
    if(self.index == 0){
        return [UIImage imageNamed:@"bizapp-bg-app"];
    }
    else if (self.index == 1){
        return [UIImage imageNamed:@"g-bizapp-bg-app"];
    }
    else{
        return [UIImage imageNamed:@"b-bizapp-bg-app"];
    }
}

- (NSString*)fontName{
    return @"Avenir-Book";
}

- (NSString*)boldFontName{
    return @"Avenir-Black";
}

// Feed List Controller Style


-(UIImage*)cellBackground{
    return [UIImage imageNamed:@"bizapp-list-item"];
}

-(UIImage*)cellFrameBackground{
    return [UIImage imageNamed:@"bizapp-list-mask"];
}

- (UIColor *)cellTextColor
{
    return [UIColor darkGrayColor];
}

- (UIFont *)cellTextFont{
    return [UIFont fontWithName:@"Avenir-Black" size:17.0f];
}

- (UIColor *)cellSubtitleTextColor{

    return [UIColor colorWithRed:48.0f/255 green:129.0f/255 blue:193.0f/255 alpha:1.0];
}
    
- (UIFont *)cellSubtitleTextFont{
    return [UIFont fontWithName:@"Avenir-Book" size:12.0f];
}

- (UIColor *)cellTextShadowColor{
    return [UIColor whiteColor];
}

- (CGSize)cellTextShadowOffset{
    return CGSizeMake(0, 1);
}

- (UIColor *)cellTopTextColor
{
    return [UIColor whiteColor];
}

- (UIFont *)cellTopTextFont{
    return [UIFont fontWithName:@"Avenir-Black" size:20.0f];
}

- (UIColor *)cellTopTextShadowColor{
    return [UIColor blackColor];
}

- (CGSize)cellTopTextShadowOffset{
    return CGSizeMake(0, -1);
}

//Detail Controller Style

- (UIColor *)titleColor{
    return [UIColor darkGrayColor];
}
- (UIFont *)titleFont{
    return [UIFont fontWithName:@"Avenir-Black" size:20.0f];
}
- (UIColor *)titleShadowColor{
    return [UIColor whiteColor];
}
- (CGSize)titleShadowOffset{
    return CGSizeMake(0, -1);
}
- (UIColor *)dateTextColor{
    return [UIColor colorWithRed:48.0f/255 green:129.0f/255 blue:193.0f/255 alpha:1.0];
}

- (UIFont *)dateTextFont{
    return [UIFont fontWithName:@"Avenir-Book" size:12.0f];
}

//Twitter Profile Feed Style
- (CGFloat)followerCountSize{
    return 26.0f;
}
- (CGFloat)followerLabelSize{
    return 11.0f;
}
- (CGFloat)followingCountSize{
   return 26.0f; 
}
- (CGFloat)followingLabelSize{
    return 11.0f;
}
- (CGFloat)usernameSize{
    return 20.0f;
}
- (CGFloat)screenNameSize{
    return 14.0f;
}
- (UIColor*)statsBarColor{
    return [UIColor colorWithRed:60.0f/255 green:140.0f/255 blue:204.0f/255 alpha:1.0f];
}

- (UIColor*)followerCountColor{
    
    return [UIColor whiteColor];
}
- (UIColor*)followerLabelColor{
    
    return [UIColor colorWithRed:21.0f/255 green:48.0f/255 blue:71.0f/255 alpha:1.0f];
}

- (UIColor*)followingCountColor{
    
    return [UIColor whiteColor];
}

- (UIColor*)followingLabelColor{
    
    return [UIColor colorWithRed:21.0f/255 green:48.0f/255 blue:71.0f/255 alpha:1.0f];
}


- (UIColor*)screenNameColor{
    return [UIColor colorWithRed:60.0f/255 green:140.0f/255 blue:204.0f/255 alpha:1.0f];
}

//Tweet Cell Style
-(CGFloat)usernameLabelSize{
    return 15.0f;
}
-(CGFloat)tweetLabelSize{
    return 13.0f;
}
-(CGFloat)tweetDateLabelSize{
    return 12.0f;
}

-(UIColor*)usernameLabelColor{
    return [UIColor colorWithRed:48.0f/255 green:129.0f/255 blue:193.0f/255 alpha:1.0];
    //return [UIColor colorWithWhite:0.29f alpha:1.0f];
}
-(UIColor*)tweetLabelColor{
    return [UIColor colorWithWhite:0.50f alpha:1.0f];
}
-(UIColor*)tweetDateLabelColor{
    return [UIColor colorWithWhite:0.76f alpha:1.0f];
}


@end
