//
//  TwitterFeedControlleriPad.h
//  ADVNewsFeeder
//
//  Created by Tope on 09/05/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICollectionViewWaterfallLayout.h"

@class ProfileiPadView;



@interface TwitterFeedControlleriPad : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateWaterfallLayout>

@property (strong, nonatomic) IBOutlet ProfileiPadView *profileView;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@end
