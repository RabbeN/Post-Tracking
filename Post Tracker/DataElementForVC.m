//
//  DataElementForVC.m
//  Post Tracker
//
//  Created by Dmitry Putintsev on 10/24/14.
//  Copyright (c) 2014 Dmitry Putintsev. All rights reserved.
//

#import "DataElementForVC.h"

@implementation DataElementForVC

+ (instancetype)elementWithCellName:(NSString *)cellName imageName:(NSString *)imageName {
    DataElementForVC *dataElement = [self new];
    if (dataElement) {
        dataElement.cellName = cellName;
        dataElement.imageName = imageName;
    }
    return dataElement;
}

@end
