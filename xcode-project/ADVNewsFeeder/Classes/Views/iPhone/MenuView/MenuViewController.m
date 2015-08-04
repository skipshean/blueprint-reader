//
//  MenuViewController.m
//  socioville
//
//  Created by Valentin Filip on 09.04.2012.
//  Copyright (c) 2012 App Design Vault. All rights reserved.
//

#import "MenuViewController.h"
#import "DataSource.h"
#import "AppDelegate.h"


@interface MenuViewController ()

@property (nonatomic, strong) DataSource    *dataSource;
@property (nonatomic, strong) NSIndexPath   *currentSelection;

@end

@implementation MenuViewController

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dataSource = [DataSource dataSource];
    [self.tableView reloadData];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"menu-background.png"]];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.items.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource.items[section][@"rows"] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
   return 23;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menu-header.png"]];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    cell = [aTableView dequeueReusableCellWithIdentifier:@"MenuCell"];
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menu-cell.png"]];
    NSDictionary *item = self.dataSource.items[indexPath.section][@"rows"][indexPath.row];
    
    UIImageView *imgRow = (UIImageView *)[cell viewWithTag:1];
    UIImage *imgRowImage = nil;
    if (item[@"imageName"]) {
        imgRowImage = [UIImage imageNamed:item[@"imageName"]];
    }
    imgRow.image = imgRowImage;
    UILabel *lblText = (UILabel *)[cell viewWithTag:2];
    lblText.text = item[@"name"];
    
    UIView *countView = nil;
    if (item[@"eventCount"] > 0) {
        NSString *countString = [NSString stringWithFormat:@"%@", item[@"eventCount"]];
        CGSize sizeCount = [countString sizeWithFont:[UIFont systemFontOfSize:14.0f]];
        
        UIImage *bkgImg = [UIImage imageNamed:@"sidemenu-count.png"];
        countView = [[UIImageView alloc] initWithImage:[bkgImg stretchableImageWithLeftCapWidth:10 topCapHeight:2]];
        countView.frame = CGRectIntegral(CGRectMake(0, 0, sizeCount.width + 2*10, bkgImg.size.height));
        
        UILabel *lblCount = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(10, (bkgImg.size.height-sizeCount.height)/2, sizeCount.width, sizeCount.height))];
        lblCount.text = countString;
        lblCount.backgroundColor = [UIColor clearColor];
        lblCount.textColor = [UIColor whiteColor];
        lblCount.textAlignment = NSTextAlignmentCenter;
        lblCount.font = [UIFont systemFontOfSize:14.0f];
        lblCount.shadowColor = [UIColor darkGrayColor];
        lblCount.shadowOffset = CGSizeMake(0, 1);
        [countView addSubview:lblCount];
    }
    cell.accessoryView = countView;
    
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.delegate userDidSwitchToControllerAtIndexPath:indexPath];
}

@end
