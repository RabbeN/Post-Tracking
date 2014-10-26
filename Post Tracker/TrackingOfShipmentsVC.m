//
//  TrackingOfShipmentsVC.m
//  Post Tracker
//
//  Created by Dmitry Putintsev on 10/24/14.
//  Copyright (c) 2014 Dmitry Putintsev. All rights reserved.
//

#import "TrackingOfShipmentsVC.h"
#import "UINavigationBar+Addition.h"
#import "TrackNumber.h"
#import "TracksHelper.h"
#import "InsideItem.h"
#import "OutsideItem.h"

static NSString *CellIdentifier = @"TrackingOfShipmentsCell";

@interface TrackingOfShipmentsVC () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) UISegmentedControl *segmentControl;
@property (nonatomic, strong) UITextField *trackTextField;
@property (nonatomic, strong) UIButton *addToMyParcelsButton;
@property (nonatomic, strong) UITableView *resultsTableView;
@property (nonatomic, strong) UIActivityIndicatorView *waitIndicator;
@property (nonatomic, strong) UIButton *searchTrackButton;

@end

@implementation TrackingOfShipmentsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Отслеживание отправлений";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    int segmentViewHeight = 40;
    int trackViewHeight = 48;
    int searchTrackButtonHeight = 45;
    
    CGRect frame = self.view.frame;
    CGRect segmentFrame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, segmentViewHeight);
    CGRect trackFrame;
    if (!self.trackNumber) {
        trackFrame = CGRectMake(frame.origin.x, segmentFrame.origin.y + segmentFrame.size.height, frame.size.width, trackViewHeight);
    } else {
       trackFrame = CGRectMake(frame.origin.x, segmentFrame.origin.y + segmentFrame.size.height, frame.size.width, 0);
    }
    CGRect tableFrame = CGRectMake(frame.origin.x, trackFrame.origin.y + trackFrame.size.height, frame.size.width, frame.size.height - searchTrackButtonHeight - trackFrame.origin.y - trackFrame.size.height - 63);
    CGRect searchTrackButtonFrame = CGRectMake(frame.origin.x, frame.size.height - searchTrackButtonHeight - 63, frame.size.width, searchTrackButtonHeight);

    
    self.segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"По РБ", @"Международные"]];
    self.segmentControl.frame = CGRectMake(10, 5, segmentFrame.size.width - 20, segmentFrame.size.height - 10);
    self.segmentControl.tintColor = [UIColor whiteColor];
    self.segmentControl.selectedSegmentIndex = 0;
    [self.segmentControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    
    UIView *segmentView = [[UIView alloc] initWithFrame:segmentFrame];
    segmentView.backgroundColor = [UIColor colorWithRed:0.105882 green:0.360784 blue:0.67451 alpha:1.0f];
    [segmentView addSubview:self.segmentControl];

    
    UIImageView *trackView = [[UIImageView alloc] initWithFrame:trackFrame];
    trackView.image = [UIImage imageNamed:@"trackTextFieldBackground"];
    trackView.userInteractionEnabled = YES;
    if (self.trackNumber) {
        trackView.hidden = YES;
    }
    
    self.trackTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 2, trackFrame.size.width - 15 - 44, 44)];
    self.trackTextField.placeholder = @"Введите номер отправления";
    self.trackTextField.delegate = self;
    self.trackTextField.returnKeyType = UIReturnKeyDone;
    
    self.addToMyParcelsButton = [[UIButton alloc] initWithFrame:CGRectMake(trackFrame.size.width - 44, 2, 44, 44)];
    [self.addToMyParcelsButton addTarget:self action:@selector(addToMyParcelsTouch) forControlEvents:UIControlEventTouchUpInside];
    [self.addToMyParcelsButton setImage:[UIImage imageNamed:@"addToMyParcels"] forState:UIControlStateNormal];
    
    [trackView addSubview:self.trackTextField];
    [trackView addSubview:self.addToMyParcelsButton];
    
    self.resultsTableView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
    self.resultsTableView.delegate = self;
    self.resultsTableView.dataSource = self;
    self.resultsTableView.hidden = YES;
    
    self.searchTrackButton = [[UIButton alloc] initWithFrame:searchTrackButtonFrame];
    [self.searchTrackButton addTarget:self action:@selector(searchTrackTouch) forControlEvents:UIControlEventTouchUpInside];
    [self.searchTrackButton setImage:[UIImage imageNamed:@"searchTrack"] forState:UIControlStateNormal];
    
    
    self.waitIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.waitIndicator.translatesAutoresizingMaskIntoConstraints = NO;
    self.waitIndicator.hidesWhenStopped = YES;
    
    [self.view addSubview:segmentView];
    [self.view addSubview:trackView];
    [self.view addSubview:self.resultsTableView];
    [self.view addSubview:self.searchTrackButton];
    [self.view addSubview:self.waitIndicator];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    [navigationBar hideBottomHairline];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.waitIndicator
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.waitIndicator
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    
    if (self.trackNumber) {
        [self searchTrackTouch];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    [navigationBar showBottomHairline];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.trackNumber) {
        NSArray *data;
        if (!self.segmentControl.selectedSegmentIndex) {
            data = self.trackNumber.insideData;
        } else {
            data = self.trackNumber.outsideData;
        }
        return [data count];
    } else {
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
    }
    
    NSArray *data;
    if (!self.segmentControl.selectedSegmentIndex) {
        data = self.trackNumber.insideData;
        InsideItem *item = [data objectAtIndex:indexPath.row];
        cell.textLabel.text = item.desc;
        cell.detailTextLabel.text = item.itemDate;
    } else {
        data = self.trackNumber.outsideData;
        OutsideItem *item = [data objectAtIndex:indexPath.row];
        cell.textLabel.text = item.desc;
        cell.detailTextLabel.text = item.itemDate;
    }
    
    return cell;
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
                [[TracksHelper sharedInstance] addTrackNumber:self.trackNumber.name withName:[[alertView textFieldAtIndex:0] text]];
                [[[UIAlertView alloc] initWithTitle:nil message:@"Номер добавлен в мои посылки!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"ОК", nil] show];
            } else {
                [[[UIAlertView alloc] initWithTitle:nil message:@"Отправление с таким именем уже существует!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"ОК", nil] show];
            }
            break;
        default:
            break;
    }
}

- (void)segmentAction:(id)action {
    if (!self.resultsTableView.hidden) {
        [self.resultsTableView reloadData];
    }
}

- (BOOL)trackValidate {
    BOOL isValid = NO;
    NSString *message;
    NSString *trackName = self.trackNumber ? self.trackNumber.name : self.trackTextField.text;
    if ([trackName isEqualToString:@""]) {
        message = @"Введите номер отправления!";
    } else if ([trackName length] != 13) {
        message = @"Неверная длина номера отправления!";
    }
    
    if (message) {
        isValid = NO;
        [[[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"ОК", nil] show];
    } else {
        isValid = YES;
    }
    return isValid;
}

- (void)searchTrackTouch {
    if ([self trackValidate]) {
        if (!self.trackNumber) {
            self.trackNumber = [[TrackNumber alloc] initWithName:self.trackTextField.text andDictionary:nil];
        }
        [self.waitIndicator startAnimating];
        [[TracksHelper sharedInstance] loadDataWithCompletion:^{
            [self.waitIndicator stopAnimating];
            self.resultsTableView.hidden = NO;
            [self.resultsTableView reloadData];
        } forTrack:self.trackNumber];
    }
}

- (void)addToMyParcelsTouch {
    if ([self trackValidate]) {
        if (!self.trackNumber) {
            self.trackNumber = [[TrackNumber alloc] initWithName:self.trackTextField.text andDictionary:nil];
        }
        if ([[TracksHelper sharedInstance] checkNewTrack:self.trackNumber.name]) {
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
    [self searchTrackTouch];
    
    return YES;
}




@end
