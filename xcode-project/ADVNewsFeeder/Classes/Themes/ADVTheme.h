//
//  ADVTheme.h
//  ADVTimelineDesign
//
//  Created by Tope on 19/03/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FeedCell.h"
#import "FeediPadCell.h"
#import "ArticleCell.h"
#import "ProfileCell.h"
#import "ProfileiPadView.h"
#import "FeedDetailController.h"
#import "FeedDetailControlleriPad.h"
#import "ArticleCelliPad.h"
#import "SwitchCollectionCell.h"
#import "ADVCustomTheme.h"
#import "ADVCustomiPadTheme.h"



typedef enum  {
    CellLocationTop,
    CellLocationMiddle,
    CellLocationBottom
}CellLocation;



@interface ADVTheme : NSObject

@property (nonatomic, strong) ADVCustomTheme *sharedTheme;

@property (nonatomic, strong) ADVCustomiPadTheme *sharediPadTheme;

-(void)setupThemes;

- (void)customizeAppAppearance;
- (void)customizeView:(UIView *)view;
- (void)customizeTableView:(UITableView *)tableView;
- (void)customizeArticleCell:(ArticleCell *)tableViewCell;
- (void)customizeArticleDetail:(FeedDetailController *)detailController;
- (void)customizeTweetProfileCell:(ProfileCell*)cell;
- (void)customizeTweetCell:(FeedCell *)cell;
- (NSString*)articleCellIdentifierForIndex:(int)index;
- (CGFloat)articleCellHeightForIndex:(int)index;

//iPad theming
- (void)customizeViewiPad:(UIView *)view;
- (void)customizeArticleCelliPad:(ArticleCelliPad *)cell;
- (void)customizeArticleDetailiPad:(FeedDetailControlleriPad *)detailController;
- (void)customizeFeediPadCell:(FeediPadCell *)cell;
- (void)customizeFeedProfileiPadCell:(ProfileiPadView*)cell;

- (void)customizeSwitchCell:(SwitchCollectionCell*)cell;



@end
