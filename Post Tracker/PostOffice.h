//
//  PostOffice.h
//  Post Tracker
//
//  Created by Dmitry Putintsev on 10/24/14.
//  Copyright (c) 2014 Dmitry Putintsev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostOffice : NSObject

@property (nonatomic, strong) NSString *index;
@property (assign) int cityID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *phoneCode;
@property (nonatomic, strong) NSString *phone1;
@property (nonatomic, strong) NSString *phone2;
@property (nonatomic, strong) NSString *phone3;
@property (nonatomic, strong) NSString *director;
@property (assign) double latitude;
@property (assign) double longitude;

+ (id)postOfficeWithJSON:(NSDictionary *)json;
- (id)initWithJSON:(NSDictionary *)json;

@end