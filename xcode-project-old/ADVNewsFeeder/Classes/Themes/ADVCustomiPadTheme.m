//
//  ADVCustomiPadTheme.m
//  
//
//  Created by Tope on 01/05/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "ADVCustomiPadTheme.h"

@interface ADVCustomiPadTheme ()

@property (nonatomic, strong) NSDictionary *theme;

@end

@implementation ADVCustomiPadTheme

- (void)setThemeFileName:(NSString *)themeFileName {
    if ([themeFileName isEqualToString:_themeFileName]) {
        return;
    }
    
    _themeFileName = themeFileName;
    
    themeFileName = [themeFileName stringByDeletingPathExtension];
    NSString *path = [[NSBundle mainBundle] pathForResource:themeFileName ofType:@"plist" inDirectory:@"Data/iPad"];
    self.theme = [[NSDictionary alloc] initWithContentsOfFile:path];
}

-(NSString*)name{
    
    return _theme[NSStringFromSelector(_cmd)];
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

- (NSString*)fontName{
    
    return _theme[NSStringFromSelector(_cmd)];
}

- (NSString*)boldFontName{
    
    return _theme[NSStringFromSelector(_cmd)];
}

- (UIImage *)viewBackground{
    
    return [UIImage imageNamed:_theme[NSStringFromSelector(_cmd)]];
}

//Article List
- (UIColor *)listTitleTextColor{
    
     return [self colorWithParams:_theme[NSStringFromSelector(_cmd)]];
}

- (CGFloat)listTitleTextSize{
    
    return [_theme[NSStringFromSelector(_cmd)] floatValue];
}

- (UIColor *)listTitleTextShadowColor{
    
     return [self colorWithParams:_theme[NSStringFromSelector(_cmd)]];
}

- (CGSize)listTitleTextShadowOffset{
    
    return CGSizeMake(0, 2);
}


- (UIColor *)listDateTextColor{
    
     return [self colorWithParams:_theme[NSStringFromSelector(_cmd)]];
}

- (CGFloat)listDateTextSize{
    
    return [_theme[NSStringFromSelector(_cmd)] floatValue];
}

- (UIColor *)listSummaryTextColor{
    
    return [self colorWithParams:_theme[NSStringFromSelector(_cmd)]];
}

- (CGFloat)listSummaryTextSize{
    
    return [_theme[NSStringFromSelector(_cmd)] floatValue];
}


//Article Detail

- (UIColor *)detailTitleTextColor{
    
    return [self colorWithParams:_theme[NSStringFromSelector(_cmd)]];
}

- (CGFloat)detailTitleTextSize{
    
    return [_theme[NSStringFromSelector(_cmd)] floatValue];
}

- (UIColor *)detailTitleTextShadowColor{
    
    return [self colorWithParams:_theme[NSStringFromSelector(_cmd)]];
}

- (CGSize)detailTitleTextShadowOffset{
    
    return CGSizeMake(0, 2);
}


- (UIColor *)detailDateTextColor{
    
    return [self colorWithParams:_theme[NSStringFromSelector(_cmd)]];
}

- (CGFloat)detailDateTextSize{
    
    return [_theme[NSStringFromSelector(_cmd)] floatValue];
}

//Profile Feed Style
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


//Feed Cell Style
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
    
    NSString *documentsPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Data/iPad"];
    
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


-(void)setupThemes {
    if ([[NSUserDefaults standardUserDefaults] valueForKey:kADVThemeCurrentiPadTheme]) {
        self.themeFileName = [[NSUserDefaults standardUserDefaults] valueForKey:kADVThemeCurrentiPadTheme][@"fileName"];
        
    } else {
        
        self.themeFileName = self.availableThemes[0][@"fileName"];
        [[NSUserDefaults standardUserDefaults] setValue:self.availableThemes[0] forKey:kADVThemeCurrentiPadTheme];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

@end
