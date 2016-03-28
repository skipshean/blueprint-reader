//
//  FacebookFeedControlleriPad.h
//  ADVNewsFeeder
//
//  Created by Valentin Filip on 5/15/13.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICollectionViewWaterfallLayout.h"

@class ProfileiPadView;


@interface FacebookFeedControlleriPad : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateWaterfallLayout>

@property (strong, nonatomic) IBOutlet ProfileiPadView *profileView;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@end
