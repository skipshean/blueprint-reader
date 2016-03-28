//
//  FeedListController.m
//  ADVNewsFeeder
//
//  Created by Tope on 09/04/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "ADVTheme.h"
#import "FeedListController.h"
#import "DataLoader.h"
#import "Article.h"
#import "FeedDetailController.h"
#import "ArticleCell.h"
#import "AppDelegate.h"
#import "ISRefreshControl.h"
#import "Configuration.h"
#import "PaperFoldNavigationController.h"


@interface FeedListController ()

@property (nonatomic, strong) ISRefreshControl *refreshControl;

@end

@implementation FeedListController

- (void)viewDidLoad {
    
    self.model = [[FeedListModel alloc] init];
    self.model.delegate = self;
    
    self.refreshControl = [[ISRefreshControl alloc] init];
    [self.feedTableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self
                            action:@selector(parseFeed)
                  forControlEvents:UIControlEventValueChanged];
    [self.refreshControl beginRefreshing];
    
    [self.feedTableView setDelegate:self];
    [self.feedTableView setDataSource:self];
    self.feedTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [[AppDelegate instance].theme customizeTableView:self.feedTableView];
    [[AppDelegate instance].theme customizeView:self.view];
    
    [self parseFeed];
    
    self.title = @"Loading feed...";

    UIBarButtonItem* reloadButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-btn-menu"] style:UIBarButtonItemStylePlain target:self action:@selector(showMenu:)];
    
    self.navigationItem.leftBarButtonItem = reloadButton;
    
    [super viewDidLoad];
	
}

- (void)dealloc {
    NSLog(@"%@ dealloc", NSStringFromClass([self class]));
    self.model.delegate = nil;
    
    self.feedTableView.delegate = nil;
    self.feedTableView.dataSource = nil;
    self.feedTableView = nil;
    self.model = nil;
    self.articles = nil;
}

- (void)showMenu:(id)sender {
    [[AppDelegate instance] togglePaperFold:sender];
}

-(void)parseFeed{
    [self.model parseFeed];
}

-(void)didFinishParsingFeedWithItems:(NSArray *)items wasSuccessful:(BOOL)success{
    
    self.articles = items;
    NSDate *date = [NSDate date];
    
	self.feedTableView.userInteractionEnabled = YES;
	[self.feedTableView reloadData];
    
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:date];
    NSTimeInterval minimumInterval = 3;
    if (interval > minimumInterval) {
        self.title = @"Articles";
        [self.refreshControl endRefreshing];
    } else {
        [self performSelector:@selector(setTitle:) withObject:@"Articles" afterDelay:(minimumInterval-interval)];
        [self.refreshControl performSelector:@selector(endRefreshing) withObject:nil afterDelay:(minimumInterval-interval)];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ADVTheme* theme = [AppDelegate instance].theme;
    
    NSString *CellIdentifier = [theme articleCellIdentifierForIndex:indexPath.row];
    
    ArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
    Article* model = self.articles[indexPath.row];
    
    model.title = [model.title capitalizedString];
    [cell.titleLabel setText:model.title];
    [cell.dateLabel setText:model.dateString];
    
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
    [self performSegueWithIdentifier:@"detail" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    UIViewController* controller = segue.destinationViewController;
    
    if([controller isKindOfClass:[FeedDetailController class]]){
    
        NSIndexPath* indexPath = [self.feedTableView indexPathForSelectedRow];
    
        Article* article = self.articles[indexPath.row];
    
        FeedDetailController* c = (FeedDetailController*)controller;
        c.article = article;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.articles count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ADVTheme* theme = [AppDelegate instance].theme;
    return [theme articleCellHeightForIndex:indexPath.row];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
