//
//  MyParcelsVC.m
//  Post Tracker
//
//  Created by Dmitry Putintsev on 10/24/14.
//  Copyright (c) 2014 Dmitry Putintsev. All rights reserved.
//

#import "MyParcelsVC.h"
#import "TrackNumber.h"
#import "TracksHelper.h"
#import "TrackingOfShipmentsVC.h"
#import "ReachabilityManager.h"

static NSString *CellIdentifier = @"MyParcelsCell";


@interface MyParcelsVC () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) NSMutableArray *tracks;
@property (nonatomic, strong) UITextField *trackTextField;
@property (nonatomic, strong) UIButton *addToMyParcelsButton;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *messageLabel;

@end

@implementation MyParcelsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Мои посылки";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    int trackViewHeight = 48;
    
    CGRect frame = self.view.frame;
    CGRect trackFrame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, trackViewHeight);
    CGRect tableFrame = CGRectMake(frame.origin.x, trackFrame.origin.y + trackFrame.size.height, frame.size.width, frame.size.height - trackFrame.origin.y - trackFrame.size.height - 64);
    CGRect labelFrame = CGRectMake(60, 138, frame.size.width - 120, 150);
    
    UIImageView *trackView = [[UIImageView alloc] initWithFrame:trackFrame];
    trackView.image = [UIImage imageNamed:@"trackTextFieldBackground"];
    trackView.userInteractionEnabled = YES;
    
    self.trackTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 2, trackFrame.size.width - 15 - 44, 44)];
    self.trackTextField.placeholder = @"Введите номер отправления";
    self.trackTextField.delegate = self;
    self.trackTextField.returnKeyType = UIReturnKeyDone;
    
    self.addToMyParcelsButton = [[UIButton alloc] initWithFrame:CGRectMake(trackFrame.size.width - 44, 2, 44, 44)];
    [self.addToMyParcelsButton addTarget:self action:@selector(addToMyParcelsTouch) forControlEvents:UIControlEventTouchUpInside];
    [self.addToMyParcelsButton setImage:[UIImage imageNamed:@"addToMyParcels"] forState:UIControlStateNormal];
    
    [trackView addSubview:self.trackTextField];
    [trackView addSubview:self.addToMyParcelsButton];
    
    self.tableView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        self.tableView.separatorInset = UIEdgeInsetsZero;
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        self.tableView.layoutMargins = UIEdgeInsetsZero;
    }
    
    self.messageLabel = [[UILabel alloc] initWithFrame:labelFrame];
    self.messageLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17.0f];
    self.messageLabel.text = @"У вас пока не добавлено ни одной посылки в избранное";
    self.messageLabel.numberOfLines = 0;
    
    [self.view addSubview:trackView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.messageLabel];
    
    self.tracks = [[[TracksHelper sharedInstance] getTrackList] mutableCopy];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.rightBarButtonItem.title = @"Редакт.";
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.tracks count]) {
        self.messageLabel.hidden = YES;
        self.tableView.hidden = NO;
        
        return [self.tracks count];
    } else {
        self.messageLabel.hidden = NO;
        self.tableView.hidden = YES;
        
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            cell.layoutMargins = UIEdgeInsetsZero;
        }
        if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
            cell.preservesSuperviewLayoutMargins = NO;
        }
        cell.textLabel.numberOfLines = 0;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (cell) {
        NSDictionary *trackDict = [self.tracks objectAtIndex:indexPath.row];
        cell.textLabel.text = [trackDict objectForKey:@"name"];
        cell.detailTextLabel.text = [trackDict objectForKey:@"track"];
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSDictionary *trackDict = [self.tracks objectAtIndex:indexPath.row];
        [self.tracks removeObjectAtIndex:indexPath.row];
        [[TracksHelper sharedInstance] removeTrackNumber:[trackDict objectForKey:@"track"]];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![ReachabilityManager isReachable]) {
        [[[UIAlertView alloc] initWithTitle:nil message:@"Нет подключения к интернету! Для отслеживания отправлений необходимо соединение с интернетом." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"ОК", nil] show];
        return;
    }
    NSDictionary *trackDict = [self.tracks objectAtIndex:indexPath.row];
    NSString *name = [trackDict objectForKey:@"track"];
    TrackingOfShipmentsVC *vc = [TrackingOfShipmentsVC new];
    vc.trackNumber = [[TrackNumber alloc] initWithName:name andDictionary:nil];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    
    self.navigationItem.rightBarButtonItem.title = editing ? @"Применить" : @"Редакт.";
    
    [self.tableView setEditing:editing animated:animated];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
            // cancel
        case 0:
            break;
            // save
        case 1:
            [alertView resignFirstResponder];
            if ([[TracksHelper sharedInstance] checkNewTrackName:[[alertView textFieldAtIndex:0] text]]) {
                [[TracksHelper sharedInstance] addTrackNumber:self.trackTextField.text withName:[[alertView textFieldAtIndex:0] text]];
                
                NSDictionary *trackDict = [NSDictionary dictionaryWithObjects:@[self.trackTextField.text, [[alertView textFieldAtIndex:0] text]] forKeys:@[@"track", @"name"]];
                [self.tracks insertObject:trackDict atIndex:0];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                
                [[[UIAlertView alloc] initWithTitle:nil message:@"Номер добавлен в мои посылки!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"ОК", nil] show];
            } else {
                [[[UIAlertView alloc] initWithTitle:nil message:@"Отправление с таким именем уже существует!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"ОК", nil] show];
            }
            break;
        default:
            break;
    }
}

- (BOOL)trackValidate {
    BOOL isValid = NO;
    NSString *error;
    if ([self.trackTextField.text isEqualToString:@""]) {
        error = @"Введите номер отправления!";
    } else if ([self.trackTextField.text length] != 13) {
        error = @"Неверная длина номера отправления!";
    }
    
    if (error) {
        isValid = NO;
        [[[UIAlertView alloc] initWithTitle:nil message:error delegate:nil cancelButtonTitle:nil otherButtonTitles:@"ОК", nil] show];
    } else {
        isValid = YES;
    }
    return isValid;
}

- (void)addToMyParcelsTouch {
    if ([self trackValidate]) {
        if ([[TracksHelper sharedInstance] checkNewTrack:self.trackTextField.text]) {
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Введите имя отправления" message:nil delegate:self cancelButtonTitle:@"Отмена" otherButtonTitles:@"Сохранить", nil];
            alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            [alertView show];
        } else {
            [[[UIAlertView alloc] initWithTitle:nil message:@"Номер уже есть в моих посылках!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"ОК", nil] show];
            
        }
    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // TODO normal check
    if (range.location >= 13) {
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

@end
