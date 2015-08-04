//
//  FeedListControlleriPad.h
//  ADVNewsFeeder
//
//  Created by Tope on 30/04/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedListModel.h"

@interface FeedListControlleriPad : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, FeedListModelDelegate>

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;

@property (nonatomic, weak) IBOutlet UICollectionViewFlowLayout *layout;

@property (nonatomic, strong) NSArray* articles;

@property (nonatomic, strong) FeedListModel *model;

-(void)didFinishParsingFeedWithItems:(NSArray *)items wasSuccessful:(BOOL)success;

@end
