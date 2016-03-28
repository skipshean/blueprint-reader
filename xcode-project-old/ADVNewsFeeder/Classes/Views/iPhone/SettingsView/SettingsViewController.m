//
//  SettingsViewController.m
//  ADVNewsFeeder
//
//  Created by Valentin Filip on 4/19/13.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "SettingsViewController.h"
#import "AppDelegate.h"
#import "ADVTheme.h"
#import "ThemeViewController.h"

@interface SettingsViewController ()

@property (nonatomic, strong) NSArray *themes;
@property (nonatomic, strong) NSString *themeFileName;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[AppDelegate instance].theme customizeTableView:self.tableView];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        self.title = @"Settings";
        
        UIBarButtonItem* reloadButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-btn-menu"] style:UIBarButtonItemStylePlain target:self action:@selector(showMenu:)];
        
        self.navigationItem.leftBarButtonItem = reloadButton;
        _themes = [AppDelegate instance].theme.sharedTheme.availableThemes;
        _themeFileName = [AppDelegate instance].theme.sharedTheme.themeFileName;
    } else {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:22];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        
        titleLabel.text = @"Settings";
        self.navigationItem.titleView = titleLabel;
        _themes = [AppDelegate instance].theme.sharediPadTheme.availableThemes;
        _themeFileName = [AppDelegate instance].theme.sharediPadTheme.themeFileName;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_showTheme) {
        _showTheme = NO;
        [self performSegueWithIdentifier:@"selectThemeNoAnim" sender:self];
    }
    [self.tableView reloadData];
}

#pragma mark - Actions

- (void)showMenu:(id)sender {
    [[AppDelegate instance] togglePaperFold:sender];
}

- (IBAction)actionClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"DetailCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = @"Theme";
    NSString *themeName;
    for (int idx = 0; idx < _themes.count; idx++) {
        NSDictionary *theme = _themes[idx];
        if ([theme[@"fileName"] isEqualToString:_themeFileName]) {
            themeName = theme[@"name"];
            break;
        }
    }
    cell.detailTextLabel.text = themeName;
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self performSegueWithIdentifier:@"selectTheme" sender:self];
}


#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"selectTheme"] || [segue.identifier isEqualToString:@"selectThemeNoAnim"]) {
        
    }
}


@end
