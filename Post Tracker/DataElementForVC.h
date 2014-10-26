//
//  DataElementForVC.h
//  Post Tracker
//
//  Created by Dmitry Putintsev on 10/24/14.
//  Copyright (c) 2014 Dmitry Putintsev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataElementForVC : NSObject

@property (nonatomic, strong) NSString *cellName;
@property (nonatomic, strong) NSString *imageName;

+ (instancetype)elementWithCellName:(NSString *)cellName imageName:(NSString *)imageName;

@end
