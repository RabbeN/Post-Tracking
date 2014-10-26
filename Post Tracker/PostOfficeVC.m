//
//  PostOfficeVC.m
//  Post Tracker
//
//  Created by Dmitry Putintsev on 10/24/14.
//  Copyright (c) 2014 Dmitry Putintsev. All rights reserved.
//

#import "PostOfficeVC.h"
#import "PostOfficeCell.h"

static NSString *CellIdentifier = @"PostOfficeCell";
static NSString *AddressCellIdentifier = @"AddressCell";

@implementation PostOfficeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Почтовое отделение";
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:AddressCellIdentifier];
    [self.tableView registerClass:[PostOfficeCell class] forCellReuseIdentifier:CellIdentifier];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        self.tableView.separatorInset = UIEdgeInsetsZero;
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        self.tableView.layoutMargins = UIEdgeInsetsZero;
    }
    self.tableView.scrollEnabled = NO;
    UIView *view = [UIView new];
    if (self.postOffice.director && ![self.postOffice.director isEqualToString:@""]) {
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 10.0f, self.view.frame.size.width, 20.0f)];
        label1.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13.0f];
        label1.text = @"Начальник почтового отделения:";
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 30.0f, self.view.frame.size.width, 20.0f)];
        label2.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0f];
        label2.text = self.postOffice.director;
        
        [view addSubview:label1];
        [view addSubview:label2];
    }
    self.tableView.tableFooterView = view;

    [self initPnones];
}

- (void)initPnones {
    self.phones = [NSMutableArray new];
    if (self.postOffice.phone1 && ![self.postOffice.phone1 isEqualToString:@""]) {
        [self.phones addObject:self.postOffice.phone1];
    }
    if (self.postOffice.phone2 && ![self.postOffice.phone2 isEqualToString:@""]) {
        [self.phones addObject:self.postOffice.phone2];
    }
    if (self.postOffice.phone3 && ![self.postOffice.phone3 isEqualToString:@""]) {
        [self.phones addObject:self.postOffice.phone3];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2 + [self.phones count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 43.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return [self addressCellAtIndexPath:indexPath];
    } else {
        return [self postOfficeCellAtIndexPath:indexPath];
    }
}

- (UITableViewCell *)addressCellAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:AddressCellIdentifier forIndexPath:indexPath];
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        cell.layoutMargins = UIEdgeInsetsZero;
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        cell.preservesSuperviewLayoutMargins = NO;
    }
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0f];
    cell.textLabel.textColor = [UIColor colorWithRed:0.105882 green:0.360784 blue:0.67451 alpha:1.0f];
    cell.textLabel.text = [NSString stringWithFormat:@"г. %@, %@", self.city.rusName, self.postOffice.address];

    return cell;
}

- (PostOfficeCell *)postOfficeCellAtIndexPath:(NSIndexPath *)indexPath {
    PostOfficeCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSString *leftValue = @"";
    NSString *rightValue = @"";
    
    if (indexPath.row == 1) {
        leftValue = @"Индекс";
        rightValue = [NSString stringWithFormat:@"%@", self.postOffice.index];
    } else {
        leftValue = @"Телефон";
        rightValue = [NSString stringWithFormat:@"%@-%@", self.postOffice.phoneCode, [self.phones objectAtIndex:indexPath.row - 2]];
        cell.rightLabel.textColor = [UIColor colorWithRed:0.105882 green:0.360784 blue:0.67451 alpha:1.0f];
    }
    
    cell.leftLabel.text = leftValue;
    cell.rightLabel.text = rightValue;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= 2) {
        [[[UIAlertView alloc] initWithTitle:@"Внимание" message:@"Вы действительно хотите позвонить по данному номеру?" delegate:self cancelButtonTitle:@"Нет" otherButtonTitles:@"ОК", nil] show];
    } else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (buttonIndex == 1) {
        NSString *phoneNumber = [self.phones objectAtIndex:indexPath.row - 2];
        NSString *urlString = [NSString stringWithFormat:@"tel://%@", phoneNumber];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }
}


@end
