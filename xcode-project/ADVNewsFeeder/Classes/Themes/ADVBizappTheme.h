//
//  ADVBizappTheme.h
//  ADVTimelineDesign
//
//  Created by Tope on 19/03/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADVTheme.h"

@interface ADVBizappTheme : NSObject <ADVThemeProtocol>

-(id)initWithIndex:(int)index;

@property (nonatomic, assign) int index;

@end
