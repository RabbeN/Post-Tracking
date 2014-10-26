//
//  AboutAppVC.m
//  Post Tracker
//
//  Created by Dmitry Putintsev on 10/24/14.
//  Copyright (c) 2014 Dmitry Putintsev. All rights reserved.
//

#import "AboutAppVC.h"
#import <MessageUI/MessageUI.h>
#import "DataElementForVC.h"

static NSString *CellIdentifier = @"AboutAppCell";

@interface AboutAppVC () <UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) NSArray *data;

@end

@implementation AboutAppVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"О приложении";
    
    self.view.backgroundColor = [UIColor whiteColor];

    self.data = @[
                  [DataElementForVC elementWithCellName:@"Разработчик - «Джей лаб»" imageName:@"jlab"],
                  [DataElementForVC elementWithCellName:@"Написать в техподдержку" imageName:@"letter"],
                  [DataElementForVC elementWithCellName:@"Оценить приложение" imageName:@"good"],
                  ];
    
    CGRect frame = self.view.frame;
    
    int cellHeight = 42;
    int tableViewHeight = cellHeight * (int)[self.data count];
    int labelHeight = frame.size.height - tableViewHeight - 64;

    CGRect labelFrame = frame;
    labelFrame.origin.x = 15;
    labelFrame.origin.y = 15;
    labelFrame.size.width = frame.size.width - labelFrame.origin.x;
    labelFrame.size.height = labelHeight - labelFrame.origin.y;
    
    
    CGRect tableViewFrame = frame;
    tableViewFrame.origin.y = labelHeight;
    tableViewFrame.size.height = tableViewHeight;
    
    self.label = [[UILabel alloc] initWithFrame:labelFrame];
    self.label.text = @"Приложение «Post Tracking» обеспечивает быстрый доступ к информации о почтовых отправлениях на территории Беларуси и за ее пределами.\nВы можете отслеживать перемещение и статус почтового отправления по его трек-номеру.\n\n«Post Tracking» содержит актуальный каталог всех отделений Белпочты.\n\nПосле ввода трек-номера отправления отслеживать совсем просто: сведения о перемещении и изменении статуса отображаются на одном экране с указанием точного времени каждого этапа.";
    self.label.numberOfLines = 0;
    self.label.clipsToBounds = YES;
    self.label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13.0f];
    self.label.textAlignment = NSTextAlignmentLeft;
    [self.label sizeToFit];
    
    self.tableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        self.tableView.separatorInset = UIEdgeInsetsZero;
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        self.tableView.layoutMargins = UIEdgeInsetsZero;
    }
    self.tableView.scrollEnabled = NO;
    
    [self.view addSubview:self.label];
    [self.view addSubview:self.tableView];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.5f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.5f)];
    view.backgroundColor = self.tableView.separatorColor;
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.data count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 42;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    DataElementForVC *data = [self.data objectAtIndex:indexPath.row];
    
    if (cell) {
        cell.imageView.image = [UIImage imageNamed:data.imageName];
        cell.textLabel.text = data.cellName;
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13.0f];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.jl.by?utm_source=posttracking&utm_medium=mobileapp&utm_campaign=ios"]];
            break;
        case 1:
            if ([MFMailComposeViewController canSendMail]) {
                [self openMail];
            } else {
                [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
                [[[UIAlertView alloc] initWithTitle:@"Ошибка" message:@"Невозможно оправить Email. Функция не доступна." delegate:nil cancelButtonTitle:nil otherButtonTitles:nil] show];
            }
            break;
        case 2:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id765486379"]];
            break;
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)openMail {
    NSString *subject = @"Post Tracking";
    NSString *message = @"";
    NSArray *toRecipents = [NSArray arrayWithObject:@"support@lj.by"];
    
    MFMailComposeViewController *mc = [MFMailComposeViewController new];
    mc.mailComposeDelegate = self;
    [mc setSubject:subject];
    [mc setMessageBody:message isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    [self presentViewController:mc animated:YES completion:NULL];
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
