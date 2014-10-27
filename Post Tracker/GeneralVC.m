//
//  GeneralVC.m
//  Post Tracker
//
//  Created by Dmitry Putintsev on 10/24/14.
//  Copyright (c) 2014 Dmitry Putintsev. All rights reserved.
//

#import "GeneralVC.h"
#import "DataElementForVC.h"
#import "AboutAppVC.h"
#import "TrackingOfShipmentsVC.h"
#import "MyParcelsVC.h"
#import "PostOfficesTableVC.h"
#import "TracksHelper.h"
#import "ReachabilityManager.h"

static NSString *CellIdentifier = @"GeneralCell";

@interface GeneralVC ()

@property (strong, nonatomic) NSArray *data;
@property (assign) int tracksCount;

@end

@implementation GeneralVC

- (id)initWithData:(NSArray *)data {
    self = [super init];
    
    if (self) {
        _data = data;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.data) {
        self.data = @[
                      [DataElementForVC elementWithCellName:@"Отслеживание отправлений" imageName:@"search"],
                      [DataElementForVC elementWithCellName:@"Каталог отделений" imageName:@"offices"],
                      [DataElementForVC elementWithCellName:@"Мои посылки" imageName:@"parcels"],
                      [DataElementForVC elementWithCellName:@"О приложении" imageName:@"aboutApp"]
                      ];
    }
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    self.tableView.scrollEnabled = NO;
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        self.tableView.separatorInset = UIEdgeInsetsZero;
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        self.tableView.layoutMargins = UIEdgeInsetsZero;
    }

    
    UILabel *titleLabel = [UILabel new];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:22.0f];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"PostTracking"];
    [attrString addAttribute:NSFontAttributeName
                       value:[UIFont boldSystemFontOfSize:22]
                       range:NSMakeRange(0, 4)];
    titleLabel.attributedText = attrString;
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tracksCount = [[[TracksHelper sharedInstance] getTrackList] count];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.data count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self calculateRowHeight];
}

- (CGFloat)calculateRowHeight {
    CGFloat tableViewHeight = self.tableView.frame.size.height;
    return tableViewHeight / 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    DataElementForVC *data = [self.data objectAtIndex:indexPath.row];
    
    if (cell) {
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            cell.layoutMargins = UIEdgeInsetsZero;
        }
        if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
            cell.preservesSuperviewLayoutMargins = NO;
        }
        cell.imageView.image = [UIImage imageNamed:data.imageName];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20.0f];
        cell.textLabel.numberOfLines = 0;
        
        if (indexPath.row != 2) {
            cell.textLabel.text = data.cellName;
        } else {
            NSString *text = [NSString stringWithFormat:@"%@ %d", data.cellName, self.tracksCount];
            NSMutableAttributedString *attrubutedString = [[NSMutableAttributedString alloc] initWithString:text];
            [attrubutedString addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:[text rangeOfString:[NSString stringWithFormat:@"%d", self.tracksCount]]];
            
            cell.textLabel.attributedText = attrubutedString;
        }
        
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *vc;
    
    switch (indexPath.row) {
        case 0:
            if (![ReachabilityManager isReachable]) {
                [[[UIAlertView alloc] initWithTitle:nil message:@"Нет подключения к интернету! Для отслеживания отправлений необходимо соединение с интернетом." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"ОК", nil] show];
                return;
            }
            vc = [TrackingOfShipmentsVC new];
            break;
        case 1:
            vc = [PostOfficesTableVC new];
            break;
        case 2:
            vc = [MyParcelsVC new];
            break;
        case 3:
            vc = [AboutAppVC new];
            break;
        default:
            break;
    }

    if (vc) {
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end