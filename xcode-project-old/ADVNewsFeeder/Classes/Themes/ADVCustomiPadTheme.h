//
//  ADVCustomiPadTheme.h
//  
//
//  Created by Tope on 01/05/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kADVThemeCurrentiPadTheme @"kADVThemeCurrentiPadTheme"

@protocol ADVThemeiPadProtocol <NSObject>

- (NSString*)name;

- (UIImage *)navigationImage;
- (UIImage *)barButtonImage;
- (UIImage *)backButtonImage;

- (NSString*)fontName;
- (NSString*)boldFontName;
- (UIImage *)viewBackground;


//Article List
- (UIColor *)listTitleTextColor;
- (CGFloat)listTitleTextSize;
- (UIColor *)listTitleTextShadowColor;
- (CGSize)listTitleTextShadowOffset;

- (UIColor *)listDateTextColor;
- (CGFloat)listDateTextSize;

- (UIColor *)listSummaryTextColor;
- (CGFloat)listSummaryTextSize;


//Article Detail
- (UIColor *)detailTitleTextColor;
- (CGFloat)detailTitleTextSize;
- (UIColor *)detailTitleTextShadowColor;
- (CGSize)detailTitleTextShadowOffset;

- (UIColor *)detailDateTextColor;
- (CGFloat)detailDateTextSize;

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


@end

@interface ADVCustomiPadTheme : NSObject <ADVThemeiPadProtocol>

@property (nonatomic, strong) NSString *themeFileName;

@property (nonatomic, strong) NSArray *availableThemes;

-(void)setupThemes;

@end
