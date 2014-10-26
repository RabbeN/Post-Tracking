//
//  CitiesVC.m
//  Post Tracker
//
//  Created by Dmitry Putintsev on 10/24/14.
//  Copyright (c) 2014 Dmitry Putintsev. All rights reserved.
//

#import "CitiesVC.h"
#import "City.h"
#import "DepartmentsHelper.h"

static NSString *CellIdentifier = @"CitiesCell";

@interface CitiesVC ()

@property (nonatomic, strong) NSDictionary *originalSortedData;
@property (nonatomic, strong) NSDictionary *filtredSortedData;

@property (nonatomic, strong) NSArray *originalSortedKeys;
@property (nonatomic, strong) NSArray *filtredSortedKeys;

@property (nonatomic, strong) NSString *selectedCityName;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@property (nonatomic, strong) UISearchDisplayController *searchController;

@end

@implementation CitiesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Выбор города";
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        self.tableView.separatorInset = UIEdgeInsetsZero;
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        self.tableView.layoutMargins = UIEdgeInsetsZero;
    }
    
    [self sortCities:[[DepartmentsHelper sharedInstance] cities]];
    self.selectedCityName = [[DepartmentsHelper sharedInstance] currentCityName];
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
    [searchBar sizeToFit];
    searchBar.delegate = self;
    searchBar.placeholder = @"Введите город";
    
    self.tableView.tableHeaderView = searchBar;
    
    UISearchDisplayController *searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    searchDisplayController.delegate = self;
    searchDisplayController.searchResultsDataSource = self;
    searchDisplayController.searchResultsDelegate = self;
    [searchDisplayController.searchResultsTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    
    self.searchController = searchDisplayController;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
}

// TODO Add Google Maps
- (void)goToMap {
    
}

- (NSMutableDictionary *)generateDictionary:(NSArray *)sortedArray {
    NSMutableDictionary *dic = [NSMutableDictionary new];
    NSMutableArray *keys = [NSMutableArray new];
    
    NSArray *preValues = @[@"Брест", @"Витебск", @"Гомель", @"Гродно", @"Минск", @"Могилев"];
    NSString *preKey = @"Областные города";
    
    for (City *city in sortedArray) {
        NSString *value = city.rusName;
        NSString *key = [value substringToIndex:1];
        
        if ([preValues containsObject:value]) {
            if (![keys containsObject:preKey]) {
                NSMutableArray *values = [NSMutableArray new];
                [values addObject:value];
                [keys addObject:preKey];
                [dic setValue:values forKey:preKey];
            } else {
                NSMutableArray *values = (NSMutableArray *)[dic valueForKey:preKey];
                [values addObject:value];
                [dic setValue:values forKey:preKey];
            }
            
            continue;
        }
        
        if (![keys containsObject:key]) {
            NSMutableArray *values = [NSMutableArray new];
            [values addObject:value];
            [keys addObject:key];
            [dic setValue:values forKey:key];
        } else {
            NSMutableArray *values = (NSMutableArray *)[dic valueForKey:key];
            [values addObject:value];
            [dic setValue:values forKey:key];
        }
    }
    return dic;
}

- (NSArray *)sortKeys:(NSArray *)keys {
    return [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if ([obj1 isEqualToString:@"Областные города"]) {
            return NSOrderedAscending;
        } else if ([obj2 isEqualToString:@"Областные города"]) {
            return NSOrderedDescending;
        } else {
            return [obj1 compare:obj2 options:NSCaseInsensitiveSearch];
        }
    }];
}

- (void)sortCities:(NSArray *)cities {
    NSArray *sortedData = [cities sortedArrayUsingSelector:@selector(compare:)];
    self.originalSortedData = [self generateDictionary:sortedData];
    self.originalSortedKeys = [self sortKeys:[self.originalSortedData allKeys]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.tableView == tableView) {
        return [self.originalSortedKeys count];
    } else {
        return [self.filtredSortedData count];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.tableView == tableView) {
        NSString *key = [self.originalSortedKeys objectAtIndex:section];
        return [[self.originalSortedData objectForKey:key] count];
    } else {
        NSString *key = [self.filtredSortedKeys objectAtIndex:section];
        return [[self.filtredSortedData objectForKey:key] count];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *key;
    if (self.tableView == tableView) {
        key = [self.originalSortedKeys objectAtIndex:section];
    } else {
        key = [self.filtredSortedKeys objectAtIndex:section];
    }
    return key;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        cell.layoutMargins = UIEdgeInsetsZero;
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        cell.preservesSuperviewLayoutMargins = NO;
    }
    
    NSString *key;
    NSArray *values;
    
    if (self.tableView == tableView) {
        key = [self.originalSortedKeys objectAtIndex:indexPath.section];
        values = [self.originalSortedData objectForKey:key];
    } else {
        key = [self.filtredSortedKeys objectAtIndex:indexPath.section];
        values = [self.filtredSortedData objectForKey:key];
    }
    
    NSString *value = [values objectAtIndex:indexPath.row];

    
    if (cell) {
        if ([value isEqualToString:self.selectedCityName]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            self.selectedIndexPath = indexPath;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0f];
        cell.textLabel.text = value;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *key;
    NSArray *values;
    
    if (self.tableView == tableView) {
        key = [self.originalSortedKeys objectAtIndex:indexPath.section];
        values = [self.originalSortedData objectForKey:key];
    } else {
        key = [self.filtredSortedKeys objectAtIndex:indexPath.section];
        values = [self.filtredSortedData objectForKey:key];
    }
    
    NSString *value = [values objectAtIndex:indexPath.row];
    if (![self.selectedCityName isEqualToString:value]) {
        self.selectedCityName = value;
        City *city = [[DepartmentsHelper sharedInstance] cityWithName:value];
        [[DepartmentsHelper sharedInstance] setCurrentCity:city];
        if (self.tableView == tableView) {
            NSMutableArray *indexPaths = [NSMutableArray arrayWithObject:indexPath];
            if (self.selectedIndexPath) {
                [indexPaths addObject:self.selectedIndexPath];
            }
            [tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        } else {
            [self.searchDisplayController setActive:NO];
            [self.tableView reloadData];
        }
    } else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"rusName CONTAINS[cd] %@", searchText];
    NSArray *cities = [[DepartmentsHelper sharedInstance] cities];
    NSArray *filtredData = [cities filteredArrayUsingPredicate:predicate];
    
    NSArray *sortedFiltredData = [filtredData sortedArrayUsingSelector:@selector(compare:)];
    self.filtredSortedData = [self generateDictionary:sortedFiltredData];
    self.filtredSortedKeys = [self sortKeys:[self.filtredSortedData allKeys]];
}


#pragma mark - SearchBar Delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self filterContentForSearchText:searchText scope:nil];
    [self.tableView reloadData];
}


@end
