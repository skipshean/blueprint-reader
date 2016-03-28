//
//  SwitchViewController.m
//  ADVNewsFeeder
//
//  Created by Tope on 09/05/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "SwitchViewController.h"
#import "SwitchCollectionCell.h"
#import "CAKeyFrameAnimation+Jumping.h"
#import "SettingsViewController.h"

@interface SwitchViewController ()

@end

@implementation SwitchViewController


- (void)viewDidLoad {
    [super viewDidLoad];
	
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard-iPad"
                                                             bundle: nil];

    self.newsNavigationController = (UINavigationController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"FeedNavigationController"];
    
    self.twitterNavigationController = (UINavigationController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"TwitterNavigationController"];
    self.facebookNavigationController = (UINavigationController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"FacebookNavigationController"];
    self.settingsNavigationController = (UINavigationController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"SettingsNav"];
    
    self.controllers = [NSArray arrayWithObjects:self.newsNavigationController, self.twitterNavigationController, self.facebookNavigationController, self.settingsNavigationController, nil];
    
    self.icons = [NSArray arrayWithObjects:@"newsfeed", @"twitter", @"facebook", @"settings", nil];
    self.titles = [NSArray arrayWithObjects:@"News Feed", @"Twitter", @"Facebook", @"Settings", nil];
    
    
    CGRect onFrame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - self.navigationController.navigationBar.bounds.size.height);
    
    [self.newsNavigationController.view setFrame:onFrame];
    [self.twitterNavigationController.view setFrame:onFrame];
    [self.facebookNavigationController.view setFrame:onFrame];
    
    [self.view insertSubview:self.newsNavigationController.view atIndex:0];
    self.newsNavigationController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.view.autoresizesSubviews = YES;
    self.currentNavigationController = self.newsNavigationController;
    self.currentIndex = 0;
    
    [self.collectionView setDelegate:self];
    [self.collectionView setDataSource:self];
    [self.collectionViewLayout setMinimumInteritemSpacing:20];
    [self.collectionViewLayout setSectionInset:UIEdgeInsetsMake(0, 50, 0, 0)];
    
    CGFloat switchTop = self.view.bounds.size.height - 130;
    [self.collectionViewContainer setFrame:CGRectMake(0, switchTop, self.view.bounds.size.width, self.collectionViewContainer.bounds.size.height)];
    
    UISwipeGestureRecognizer* swipeUpGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeUpFrom:)];
    swipeUpGestureRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    
    UISwipeGestureRecognizer* swipeDownGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeDownFrom:)];
    swipeDownGestureRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    

    [self.view addGestureRecognizer:swipeUpGestureRecognizer];
    [self.view addGestureRecognizer:swipeDownGestureRecognizer];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (_showSettings) {
        _showSettings = NO;
        [self performSegueWithIdentifier:@"showSettings" sender:self];
    }
    
    //CAKeyframeAnimation *animation = [CAKeyframeAnimation dockBounceAnimationWithIconHeight:40];
	//animation.duration = 1.5;
	//[self.collectionViewContainer.layer addAnimation:animation forKey:@"jumping"];
    
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self.currentNavigationController willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}


#pragma mark - Actions


- (IBAction)toggleVisibility:(id)sender {
    CGFloat switchTop = self.view.bounds.size.height - 130;
    if (self.collectionViewContainer.frame.origin.y > switchTop) {
        [self handleSwipeUpFrom:nil];
    } else {
        [self handleSwipeDownFrom:nil];
    }
}

- (void)handleSwipeUpFrom:(UIGestureRecognizer*)recognizer {
    
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         CGFloat switchTop = self.view.bounds.size.height - 130;
                         [self.collectionViewContainer setFrame:CGRectMake(0, switchTop, self.view.bounds.size.width, self.collectionViewContainer.bounds.size.height)];
                         
                     }
                     completion:^(BOOL finished){
                     }];

}

- (void)handleSwipeDownFrom:(UIGestureRecognizer*)recognizer {
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         CGFloat switchTop = self.view.bounds.size.height - 20;
                         [self.collectionViewContainer setFrame:CGRectMake(0, switchTop, self.view.bounds.size.width, self.collectionViewContainer.bounds.size.height)];
                         
                     }
                     completion:^(BOOL finished){
                     }];
}


-(void)switchViewsTo:(UINavigationController*)newNavigationController withLeftAnimation:(BOOL)leftAnimation{
    
    int xOffset = self.view.bounds.size.width;
    
    CGRect leftFrame = CGRectMake(xOffset, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    CGRect onFrame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    CGRect rightFrame = CGRectMake(-xOffset, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    
    if(newNavigationController.view.superview == nil)
    {
        [self.view insertSubview:newNavigationController.view aboveSubview:self.currentNavigationController.view];
        
        newNavigationController.view.frame = leftAnimation ? leftFrame : rightFrame;
        
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options: UIViewAnimationOptionCurveEaseInOut
                         animations:^{

                             newNavigationController.view.frame = onFrame;
                             self.currentNavigationController.view.frame = leftAnimation ? rightFrame : leftFrame;
                         }
                         completion:^(BOOL finished){
                             [self.currentNavigationController.view removeFromSuperview];
                             self.currentNavigationController = newNavigationController;
                         }];

    }
    
    [self toggleVisibility:nil];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.controllers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    SwitchCollectionCell* cell = (SwitchCollectionCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"SwitchCollectionCell" forIndexPath:indexPath];
    
    [cell.iconImageView setImage:[UIImage imageNamed:self.icons[indexPath.row]]];
    [cell.iconLabel setText:self.titles[indexPath.row]];
    
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UINavigationController* newNavigationController = self.controllers[indexPath.row];
    
    if(self.currentNavigationController != newNavigationController){
        if (indexPath.row == [self.collectionView numberOfItemsInSection:0]-1) {
            [self performSegueWithIdentifier:@"showSettings" sender:self];
            [self toggleVisibility:nil];
            return;
        }
        
        BOOL leftAnimation = self.currentIndex < indexPath.row ? YES : NO;
        
        self.currentIndex = indexPath.row;
        [self switchViewsTo:newNavigationController withLeftAnimation:leftAnimation];
    }
}

#pragma mark - Segue 


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showSettings"] || [segue.identifier isEqualToString:@"showSettingsNoAnim"]) {
        UINavigationController *nav = segue.destinationViewController;
        SettingsViewController *childVC = nav.viewControllers[0];
        childVC.showTheme = _showSettingsTheme;
        _showSettingsTheme = NO;
    }
}


@end
