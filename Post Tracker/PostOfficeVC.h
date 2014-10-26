//
//  PostOfficeVC.h
//  Post Tracker
//
//  Created by Dmitry Putintsev on 10/24/14.
//  Copyright (c) 2014 Dmitry Putintsev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "City.h"
#import "PostOffice.h"

@interface PostOfficeVC : UITableViewController <UIAlertViewDelegate>

@property (nonatomic, strong) City *city;
@property (nonatomic, strong) PostOffice *postOffice;
@property (assign) BOOL disableMap;
@property (nonatomic, strong) NSMutableArray *phones;

@end
