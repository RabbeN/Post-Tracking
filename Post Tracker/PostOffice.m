//
//  PostOffice.m
//  Post Tracker
//
//  Created by Dmitry Putintsev on 10/24/14.
//  Copyright (c) 2014 Dmitry Putintsev. All rights reserved.
//

#import "PostOffice.h"

@implementation PostOffice

+ (id)postOfficeWithJSON:(NSDictionary *)json {
    return [[self alloc] initWithJSON:json];
}

- (id)initWithJSON:(NSDictionary *)json {
    self = [super init];
    
    if (self) {
        _index = [[json objectForKey:@"index"] description];
        _cityID = [[json objectForKey:@"ID_city"] intValue];
        _name = [json objectForKey:@"name"];
        _address = [json objectForKey:@"adres"];
        _phoneCode = [json objectForKey:@"code"];
        _phone1 = [json objectForKey:@"tel1"] ? [[json objectForKey:@"tel1"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]: nil;
        _phone2 = [json objectForKey:@"tel2"] ? [[json objectForKey:@"tel2"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]: nil;
        _phone3 = [json objectForKey:@"tel3"] ? [[json objectForKey:@"tel3"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]: nil;
        _director = [json objectForKey:@"director"] ? [[json objectForKey:@"director"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]: nil;
        _latitude = [[json objectForKey:@"latitude"] doubleValue];
        _longitude = [[json objectForKey:@"longitude"] doubleValue];
    }
    
    return self;
}

@end
