//
//  ADVCustomTheme.m
//  
//
//  Created by Tope on 19/03/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "ADVCustomTheme.h"

@interface ADVCustomTheme ()

@property (nonatomic, strong) NSDictionary *theme;

@end


@implementation ADVCustomTheme 

- (void)setThemeFileName:(NSString *)themeFileName {
    if ([themeFileName isEqualToString:_themeFileName]) {
        return;
    }
    
    _themeFileName = themeFileName;
    
    themeFileName = [themeFileName stringByDeletingPathExtension];
    NSString *path = [[NSBundle mainBundle] pathForResource:themeFileName ofType:@"plist" inDirectory:@"Data/iPhone"];
    self.theme = [[NSDictionary alloc] initWithContentsOfFile:path];
}

-(NSString*)name{
    
    return _theme[NSStringFromSelector(_cmd)];
}

- (BOOL)useLayoutWithImages{
    
    return [_theme[NSStringFromSelector(_cmd)] boolValue];
}

- (UIImage *)navigationImage{
    
    return [UIImage imageNamed:_theme[NSStringFromSelector(_cmd)]];
}

- (UIImage *)barButtonImage{
    return [[UIImage imageNamed:_theme[NSStringFromSelector(_cmd)]] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 7, 10, 7)];
}

- (UIImage *)backButtonImage{
    return [[UIImage imageNamed:_theme[NSStringFromSelector(_cmd)]] resizableImageWithCapInsets:UIEdgeInsetsMake(0 ,15,0 ,8)];
}

- (UIImage *)viewBackground{
    
    return [UIImage imageNamed:_theme[NSStringFromSelector(_cmd)]];
}

- (NSString*)fontName{
    return _theme[NSStringFromSelector(_cmd)];
}

- (NSString*)boldFontName{
    return _theme[NSStringFromSelector(_cmd)];
}

// Feed List Controller Style


-(UIImage*)cellBackground{
    return [UIImage imageNamed:_theme[NSStringFromSelector(_cmd)]];
}

-(UIImage*)cellFrameBackground{
    return [UIImage imageNamed:_theme[NSStringFromSelector(_cmd)]];
}

- (UIColor *)cellTextColor
{
    return [self colorWithParams:_theme[NSStringFromSelector(_cmd)]];
}

- (CGFloat)cellTextFontSize {
    return [_theme[NSStringFromSelector(_cmd)] floatValue];
}

- (UIFont *)cellTextFont{
    return [UIFont fontWithName:[self boldFontName] size:[self cellTextFontSize]];
}

- (UIColor *)cellSubtitleTextColor{
    
    return [self colorWithParams:_theme[NSStringFromSelector(_cmd)]];
}

- (CGFloat)cellSubtitleTextFontSize {
    return [_theme[NSStringFromSelector(_cmd)] floatValue];
}

- (UIFont *)cellSubtitleTextFont{
    return [UIFont fontWithName:[self fontName] size:[self cellSubtitleTextFontSize]];
}

- (UIColor *)cellTextShadowColor{
    return [self colorWithParams:_theme[NSStringFromSelector(_cmd)]];
}

- (CGSize)cellTextShadowOffset{
    return CGSizeMake(0, 1);
}

- (UIColor *)cellTopTextColor
{
    return [self colorWithParams:_theme[NSStringFromSelector(_cmd)]];
}

- (CGFloat)cellTopTextFontSize {
    return [_theme[NSStringFromSelector(_cmd)] floatValue];
}

- (UIFont *)cellTopTextFont{
    return [UIFont fontWithName:[self boldFontName] size:[self cellTopTextFontSize]];
}

- (UIColor *)cellTopTextShadowColor{
    return [self colorWithParams:_theme[NSStringFromSelector(_cmd)]];
}

- (CGSize)cellTopTextShadowOffset{
    return CGSizeMake(0, 1);
}

//Detail Controller Style

- (UIColor *)titleColor{
    return [self colorWithParams:_theme[NSStringFromSelector(_cmd)]];
}

- (CGFloat)titleFontSize {
    return [_theme[NSStringFromSelector(_cmd)] floatValue];
}

- (UIFont *)titleFont{
    return [UIFont fontWithName:[self boldFontName] size:[self titleFontSize]];
}
- (UIColor *)titleShadowColor{
    return [self colorWithParams:_theme[NSStringFromSelector(_cmd)]];
}
- (CGSize)titleShadowOffset{
    return CGSizeMake(0, -1);
}
- (UIColor *)dateTextColor{
    return [self colorWithParams:_theme[NSStringFromSelector(_cmd)]];
}

- (CGFloat)dateTextFontSize {
    return [_theme[NSStringFromSelector(_cmd)] floatValue];
}

- (UIFont *)dateTextFont{
    return [UIFont fontWithName:[self fontName] size:[self dateTextFontSize]];
}

//Twitter Profile Feed Style
- (CGFloat)followerCountSize{
    return [_theme[NSStringFromSelector(_cmd)] floatValue];
}
- (CGFloat)followerLabelSize{
    return [_theme[NSStringFromSelector(_cmd)] floatValue];
}
- (CGFloat)followingCountSize{
    return [_theme[NSStringFromSelector(_cmd)] floatValue];
}
- (CGFloat)followingLabelSize{
    return [_theme[NSStringFromSelector(_cmd)] floatValue];
}
- (CGFloat)usernameSize{
    return [_theme[NSStringFromSelector(_cmd)] floatValue];
}
- (CGFloat)screenNameSize{
    return [_theme[NSStringFromSelector(_cmd)] floatValue];
}
- (UIColor*)statsBarColor{
    return [self colorWithParams:_theme[NSStringFromSelector(_cmd)]];
}

- (UIColor*)followerCountColor{
    
    return [self colorWithParams:_theme[NSStringFromSelector(_cmd)]];
}
- (UIColor*)followerLabelColor{
    
    return [self colorWithParams:_theme[NSStringFromSelector(_cmd)]];
}

- (UIColor*)followingCountColor{
    
    return [self colorWithParams:_theme[NSStringFromSelector(_cmd)]];
}

- (UIColor*)followingLabelColor{
    
    return [self colorWithParams:_theme[NSStringFromSelector(_cmd)]];
}

- (UIColor*)screenNameColor{
   return [self colorWithParams:_theme[NSStringFromSelector(_cmd)]];
}

//Tweet Cell Style
-(CGFloat)usernameLabelSize{
    return [_theme[NSStringFromSelector(_cmd)] floatValue];
}
-(CGFloat)tweetLabelSize{
    return [_theme[NSStringFromSelector(_cmd)] floatValue];
}
-(CGFloat)tweetDateLabelSize{
    return [_theme[NSStringFromSelector(_cmd)] floatValue];
}

-(UIColor*)usernameLabelColor{
    
    return [self colorWithParams:_theme[NSStringFromSelector(_cmd)]];
    
}
-(UIColor*)tweetLabelColor{
    return [self colorWithParams:_theme[NSStringFromSelector(_cmd)]];
}
-(UIColor*)tweetDateLabelColor{
    return [self colorWithParams:_theme[NSStringFromSelector(_cmd)]];
}

- (UIColor *)colorWithParams:(id)param {
    if ([param isKindOfClass:[NSString class]]) {
        return [UIColor performSelector:NSSelectorFromString(param)];
    } else if ([param isKindOfClass:[NSDictionary class]]) {
        NSDictionary *params = (NSDictionary *)param;
        if (params.count == 2) {
            return [UIColor colorWithWhite:[params[@"white"] floatValue] alpha:[params[@"alpha"] floatValue]];
        } else if (params.count == 4) {
            return [UIColor colorWithRed:[params[@"red"] floatValue] green:[params[@"green"] floatValue] blue:[params[@"blue"] floatValue] alpha:[params[@"alpha"] floatValue]];
        }
    }
    
    return [UIColor blackColor];
}

- (NSArray *)availableThemes {
    if (_availableThemes) {
        return _availableThemes;
    }
    
    NSString *documentsPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Data/iPhone"];
    
    NSFileManager *manager = [[NSFileManager alloc] init];
    NSDirectoryEnumerator *fileEnumerator = [manager enumeratorAtPath:documentsPath];
    
    NSMutableArray *validThemes = [NSMutableArray array];
    for (NSString *filename in fileEnumerator) {
        if ([filename rangeOfString:@"Theme.plist"].location != NSNotFound) {
            
            NSString *path = [documentsPath stringByAppendingPathComponent:filename];
            NSDictionary *theme = [[NSDictionary alloc] initWithContentsOfFile:path];
            [validThemes addObject:@{@"fileName": filename
             , @"name": theme[@"name"]
             }];
        }
    }
    
    NSLog(@"Themes: %@", validThemes);
    _availableThemes = validThemes;
    return _availableThemes;
}

-(void)setupThemes{
    if ([[NSUserDefaults standardUserDefaults] valueForKey:kADVThemeCurrentTheme]) {
        self.themeFileName = [[NSUserDefaults standardUserDefaults] valueForKey:kADVThemeCurrentTheme][@"fileName"];
        
    } else {
        
        self.themeFileName = self.availableThemes[0][@"fileName"];
        [[NSUserDefaults standardUserDefaults] setValue:self.availableThemes[0] forKey:kADVThemeCurrentTheme];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}


@end
