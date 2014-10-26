//
//  DepartmentsHelper.m
//  Post Tracker
//
//  Created by Dmitry Putintsev on 10/24/14.
//  Copyright (c) 2014 Dmitry Putintsev. All rights reserved.
//

#import "DepartmentsHelper.h"
#import "City.h"
#import "PostOffice.h"

@implementation DepartmentsHelper

- (id)init {
    self = [super init];
    
    if (self) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"departments" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        NSError *error;
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        if (!error) {
            NSArray *jsonCities = [jsonDictionary objectForKey:@"cities"];
            NSArray *jsonDepartments = [jsonDictionary objectForKey:@"departments"];

            NSMutableArray *cities = [NSMutableArray arrayWithCapacity:[jsonCities count]];
            NSMutableArray *departments = [NSMutableArray arrayWithCapacity:[jsonDepartments count]];
            
            for (NSDictionary *jsonCity in jsonCities) {
                City *city = [City cityWithJSON:jsonCity];
                [cities addObject:city];
            }
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            
            NSString *currentCityName = [userDefaults objectForKey:@"currentCity"];
            if (!currentCityName) {
                City *currentCity = [cities objectAtIndex:0];
                self.currentCity = currentCity;
                [userDefaults setObject:currentCity.rusName forKey:@"currentCity"];
                [userDefaults synchronize];
            }
            
            for (NSDictionary *jsonDepartment in jsonDepartments) {
                PostOffice *department = [PostOffice postOfficeWithJSON:jsonDepartment];
                [departments addObject:department];
            }
            
            _cities = cities;
            _departments = departments;
        }
    }
    
    return self;
}

+ (instancetype)sharedInstance {
    static DepartmentsHelper *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [self new];
    });
    
    return _sharedInstance;
}

- (City *)cityWithId:(int)cityID {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cityID == %@", cityID];
    NSArray *cities = [self.cities filteredArrayUsingPredicate:predicate];
    if ([cities count]) {
        return [cities objectAtIndex:0];
    } else {
        return nil;
    }
}

- (City *)cityWithName:(NSString *)cityName {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"rusName like[cd] %@", cityName];
    NSArray *cities = [self.cities filteredArrayUsingPredicate:predicate];
    if ([cities count]) {
        return [cities objectAtIndex:0];
    } else {
        return nil;
    }
}

- (City *)currentCity {
    if (!_currentCity) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *currentCityName = [userDefaults objectForKey:@"currentCity"];
        _currentCity = [self cityWithName:currentCityName];
    }
    
    return _currentCity;
}

- (NSString *)currentCityName {
    return self.currentCity.rusName;
}

- (NSArray *)departmentsWithCityID:(int)cityID {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cityID == %@", [NSNumber numberWithInt:cityID]];
    NSArray *departments = [self.departments filteredArrayUsingPredicate:predicate];
    return departments;
}

- (NSArray *)departmentsWithCurrentCity {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cityID == %@", [NSNumber numberWithInt:self.currentCity.cityID]];
    NSArray *departments = [self.departments filteredArrayUsingPredicate:predicate];
    return departments;
}

@end
