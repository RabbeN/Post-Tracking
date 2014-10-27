//
//  PostOfficesTableVC.m
//  Post Tracker
//
//  Created by Dmitry Putintsev on 10/24/14.
//  Copyright (c) 2014 Dmitry Putintsev. All rights reserved.
//

#import "PostOfficesTableVC.h"
#import "DepartmentsHelper.h"
#import "PostOfficeVC.h"
#import "CitiesVC.h"
#import "PostOffice.h"
#import "City.h"

static NSString *CellIdentifier = @"GeneralCell";

@interface PostOfficesTableVC ()

@property (nonatomic, strong) NSArray *originalData;
@property (nonatomic, strong) NSArray *searchData;
@property (nonatomic, strong) UISearchDisplayController *searchController;
@property (nonatomic, strong) City *selectedCity;

@end

@implementation PostOfficesTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Каталог отделений";
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        self.tableView.separatorInset = UIEdgeInsetsZero;
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        self.tableView.layoutMargins = UIEdgeInsetsZero;
    }
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
    [searchBar sizeToFit];
    searchBar.delegate = self;
    searchBar.placeholder = @"Введите индекс или улицу";
    
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
    
    if (!self.selectedCity || ![self.selectedCity isEqual:[[DepartmentsHelper sharedInstance] currentCity]]) {
        self.selectedCity = [[DepartmentsHelper sharedInstance] currentCity];
        self.originalData = [[DepartmentsHelper sharedInstance] departmentsWithCurrentCity];
        [self.tableView reloadData];
    }
}

// TODO Add Google Maps
- (void)goToMap {
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        return [self.originalData count] + 1;
    } else {
        return [self.searchData count] + 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        cell.layoutMargins = UIEdgeInsetsZero;
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        cell.preservesSuperviewLayoutMargins = NO;
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0f];
    
    if (indexPath.row == 0) {
        NSString *cityName = self.selectedCity.rusName;
        NSString *changaPlace = @"(изменить место)";
        NSString *text = [NSString stringWithFormat:@"%@ %@", cityName, changaPlace];
        NSMutableAttributedString *attrubutedString = [[NSMutableAttributedString alloc] initWithString:text];
        [attrubutedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@".HelveticaNeueInterface-MediumP4" size:16.0f] range:[text rangeOfString:cityName]];
        [attrubutedString addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:[text rangeOfString:changaPlace]];

        cell.textLabel.attributedText = attrubutedString;
    } else {
        NSArray *data;
        if (self.tableView == tableView) {
            data = self.originalData;
        } else {
            data = self.searchData;
        }
        PostOffice *postOffice = [data objectAtIndex:indexPath.row - 1];
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@    %@", postOffice.index, postOffice.address];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *vc;
    if (indexPath.row == 0) {
        vc = [CitiesVC new];
    } else {
        NSArray *data;
        if (self.tableView == tableView) {
            data = self.originalData;
        } else {
            data = self.searchData;
        }
        PostOffice *postOffice = [data objectAtIndex:indexPath.row - 1];
        PostOfficeVC *postOfficeVC = [PostOfficeVC new];
        postOfficeVC.postOffice = postOffice;
        postOfficeVC.city = [[DepartmentsHelper sharedInstance] currentCity];
        vc = postOfficeVC;
    }
    [self.navigationController pushViewController:vc animated:YES];
}



#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(address CONTAINS[cd] %@) OR (index CONTAINS[cd] %@)", searchText, searchText];
    self.searchData = [self.originalData filteredArrayUsingPredicate:predicate];
}


#pragma mark - SearchBar Delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self filterContentForSearchText:searchText scope:nil];
    [self.tableView reloadData];
}

@end
