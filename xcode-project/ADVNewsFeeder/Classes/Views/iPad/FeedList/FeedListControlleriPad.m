//
//  FeedListControlleriPad.m
//  ADVNewsFeeder
//
//  Created by Tope on 30/04/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "FeedDetailControlleriPad.h"
#import "FeedListControlleriPad.h"
#import "ArticleCelliPad.h"
#import "Article.h"
#import "AppDelegate.h"
#import "NSString+HTML.h"
#import "ISRefreshControl.h"

@interface FeedListControlleriPad ()

@property (nonatomic, strong) ISRefreshControl *refreshControl;

@end






CGFloat kCollectionNewsWidthPortrait = 360;
CGFloat kCollectionNewsWidthLandscape = 320;

@implementation FeedListControlleriPad

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [[AppDelegate instance].theme customizeViewiPad:self.view];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:22];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    titleLabel.text = @"News";
    self.navigationItem.titleView = titleLabel;
    
    self.refreshControl = [[ISRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.collectionView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self
                            action:@selector(parseFeed)
                  forControlEvents:UIControlEventValueChanged];
    [self.refreshControl beginRefreshing];
    
    self.model = [[FeedListModel alloc] init];
    [self.model setDelegate:self];
    
    [self.model parseFeed];
    
    [self.collectionView setDelegate:self];
    [self.collectionView setDataSource:self];
    [self.collectionView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]]];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.collectionView reloadData];
}

- (void)dealloc {
    self.collectionView.delegate = nil;
    self.collectionView.dataSource = nil;
    self.collectionView = nil;
}

-(void)parseFeed{
    [self.model parseFeed];
}

-(void)didFinishParsingFeedWithItems:(NSArray *)items wasSuccessful:(BOOL)success{
    
    self.articles = items;
    
    [self.collectionView reloadData];
    [self.refreshControl endRefreshing];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.articles.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ArticleCelliPad *cell = (ArticleCelliPad *)[collectionView dequeueReusableCellWithReuseIdentifier:@"ArticleCelliPad" forIndexPath:indexPath];
    
    Article* model = self.articles[indexPath.row];
    
    model.title = [model.title capitalizedString];
    [cell.titleLabel setText:model.title];
    [cell.dateLabel setText:model.dateString];
    
    [self resizeTitleLabel:cell.titleLabel];
    
    NSString* article = [model.excerpt stringByConvertingHTMLToPlainText];
    [cell.summaryLabel setText:article];
    
    CGRect frame = cell.summaryLabel.frame;
    frame.origin.y = CGRectGetMaxY(cell.titleLabel.frame) + 5;
    frame.size.height = cell.bounds.size.height - frame.origin.y - 10;
    cell.summaryLabel.frame = frame;
    
    cell.articleImageView.image = nil;
    if (model.image)
    {
        [cell.articleImageView setImage:model.image];
    }
    else
    {
        if(model.imageUrl){
            
            dispatch_async(dispatch_get_global_queue(
                                                     DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSURL *imageURL = [NSURL URLWithString:model.imageUrl];
                
                __block NSData *imageData;
                
                dispatch_sync(dispatch_get_global_queue(
                                                        DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    imageData =[NSData dataWithContentsOfURL:imageURL];
                    
                    model.image = [UIImage imageWithData:imageData];
                    
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [cell.articleImageView setImage:model.image];
                    });
                });
            });
        }
    }

    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [self performSegueWithIdentifier:@"detail" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UINavigationController *nav = segue.destinationViewController;
    UIViewController* controller = nav.viewControllers[0];
    
    if([controller isKindOfClass:[FeedDetailControlleriPad class]]){
        
        NSArray* indexes = [self.collectionView indexPathsForSelectedItems];
        
        NSIndexPath* indexPath = indexes[0];
        
        Article* article = self.articles[indexPath.row];
        
        FeedDetailControlleriPad* c = (FeedDetailControlleriPad*)controller;
        c.article = article;
    }
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = kCollectionNewsWidthPortrait;
    if(UIInterfaceOrientationIsLandscape(self.interfaceOrientation)){
        width = kCollectionNewsWidthLandscape;
    }
    return CGSizeMake(width, 400);
}



- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    if(UIInterfaceOrientationIsLandscape(self.interfaceOrientation)){
        return UIEdgeInsetsMake(20, 10, 20, 10);
    }
    else{
        return UIEdgeInsetsMake(20, 12, 20, 12);
    }
    
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)resizeTitleLabel:(UILabel*)label{
    
    CGFloat height = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(label.bounds.size.width, 1000)].height;
    
    if(height > 76){
        height = 76;
    }
    
    CGRect frame = label.frame;
    frame.size.height = height;
    label.frame = frame;
}

@end
