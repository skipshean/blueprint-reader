//
//  ThemeViewController.m
//  ADVNewsFeeder
//
//  Created by Valentin Filip on 4/19/13.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "ThemeViewController.h"
#import "AppDelegate.h"
#import "ADVTheme.h"

#import "SettingsViewController.h"

@interface ThemeViewController ()

@property (nonatomic, strong) NSArray *themes;
@property (nonatomic, strong) NSString *themeFileName;
@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation ThemeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        self.title = @"Theme";
        _themes = [AppDelegate instance].theme.sharedTheme.availableThemes;
        _themeFileName = [AppDelegate instance].theme.sharedTheme.themeFileName;
    } else {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:22];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        
        titleLabel.text = @"Theme";
        self.navigationItem.titleView = titleLabel;
        _themes = [AppDelegate instance].theme.sharediPadTheme.availableThemes;
        _themeFileName = [AppDelegate instance].theme.sharediPadTheme.themeFileName;
    }
    
    for (int idx = 0; idx < _themes.count; idx++) {
        NSDictionary *theme = _themes[idx];
        if ([theme[@"fileName"] isEqualToString:_themeFileName]) {
            self.currentIndex = idx;
            break;
        }
    }
    [self.tableView reloadData];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _themes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *theme = _themes[indexPath.row];
    
    cell.textLabel.text = theme[@"name"];
    if (indexPath.row == _currentIndex) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
        
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0]];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    self.currentIndex = indexPath.row;
    cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    NSDictionary *theme = _themes[indexPath.row];
    
    [[NSUserDefaults standardUserDefaults] setValue:theme forKey:kADVThemeCurrentTheme];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [AppDelegate instance].theme.sharedTheme.themeFileName = theme[@"fileName"];
    } else {
        [AppDelegate instance].theme.sharediPadTheme.themeFileName = theme[@"fileName"];
    }
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [[AppDelegate instance] resetAfterThemeChange:NO];
    } else {
        [self dismissViewControllerAnimated:YES completion:^{
            [[AppDelegate instance] resetAfterThemeChange:NO];
        }];
    }
}

@end
