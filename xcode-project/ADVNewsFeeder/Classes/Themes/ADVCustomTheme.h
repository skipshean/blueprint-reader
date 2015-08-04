//
//  ADVCustomTheme.h
//  
//
//  Created by Tope on 17/04/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kADVThemeCurrentTheme @"kADVThemeCurrentTheme"

@protocol ADVThemeProtocol <NSObject>

- (UIImage *)navigationImage;
- (UIImage *)barButtonImage;
- (UIImage *)backButtonImage;
- (UIImage *)viewBackground;

- (NSString*)fontName;
- (NSString*)boldFontName;

//List Controller Style
- (UIImage*)cellBackground;
- (UIImage*)cellFrameBackground;
- (UIColor *)cellTextColor;
- (UIFont *)cellTextFont;
- (UIColor *)cellTextShadowColor;
- (CGSize)cellTextShadowOffset;
- (UIColor *)cellSubtitleTextColor;
- (UIFont *)cellSubtitleTextFont;
- (UIColor *)cellTopTextColor;
- (UIFont *)cellTopTextFont;
- (UIColor *)cellTopTextShadowColor;
- (CGSize)cellTopTextShadowOffset;

//Detail Controller Style
- (UIColor *)titleColor;
- (UIFont *)titleFont;
- (UIColor *)titleShadowColor;
- (CGSize)titleShadowOffset;
- (UIColor *)dateTextColor;
- (UIFont *)dateTextFont;

//Profile Style
- (CGFloat)followerCountSize;
- (CGFloat)followerLabelSize;
- (CGFloat)followingCountSize;
- (CGFloat)followingLabelSize;
- (UIColor*)followerCountColor;
- (UIColor*)followerLabelColor;
- (UIColor*)followingCountColor;
- (UIColor*)followingLabelColor;
- (CGFloat)usernameSize;
- (CGFloat)screenNameSize;
- (UIColor*)statsBarColor;
- (UIColor*)screenNameColor;

//Feed Cell Style
-(CGFloat)usernameLabelSize;
-(CGFloat)tweetLabelSize;
-(CGFloat)tweetDateLabelSize;

-(UIColor*)usernameLabelColor;
-(UIColor*)tweetLabelColor;
-(UIColor*)tweetDateLabelColor;

- (NSString*)name;
- (BOOL)useLayoutWithImages;

@end


@interface ADVCustomTheme : NSObject <ADVThemeProtocol>

@property (nonatomic, strong) NSString *themeFileName;

@property (nonatomic, strong) NSArray *availableThemes;

-(void)setupThemes;

@end


