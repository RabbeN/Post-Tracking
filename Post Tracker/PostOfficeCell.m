//
//  PostOfficeCell.m
//  Post Tracker
//
//  Created by Dmitry Putintsev on 10/24/14.
//  Copyright (c) 2014 Dmitry Putintsev. All rights reserved.
//

#import "PostOfficeCell.h"

@implementation PostOfficeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.clipsToBounds = YES;
        if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
            self.layoutMargins = UIEdgeInsetsZero;
        }
        if ([self respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
            self.preservesSuperviewLayoutMargins = NO;
        }
        
        self.leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 305, 44)];
        self.leftLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.leftLabel.clipsToBounds = YES;
        self.leftLabel.numberOfLines = 1;
        self.leftLabel.textAlignment = NSTextAlignmentLeft;
        self.leftLabel.opaque = NO;
        self.leftLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0f];
        
        self.rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 305, 44)];
        self.rightLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.rightLabel.clipsToBounds = YES;
        self.rightLabel.numberOfLines = 1;
        self.rightLabel.textAlignment = NSTextAlignmentRight;
        self.rightLabel.opaque = NO;
        self.rightLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0f];
        
        [self.contentView addSubview:self.leftLabel];
        [self.contentView addSubview:self.rightLabel];

        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.leftLabel
                                                                     attribute:NSLayoutAttributeLeading
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeLeading
                                                                    multiplier:1.0
                                                                      constant:15.0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.leftLabel
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1.0
                                                                      constant:5.0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView
                                                                     attribute:NSLayoutAttributeBottom
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.leftLabel
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1.0
                                                                      constant:5.0]];
        
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.rightLabel
                                                                     attribute:NSLayoutAttributeLeading
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.leftLabel
                                                                     attribute:NSLayoutAttributeLeading
                                                                    multiplier:1.0
                                                                      constant:0.0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.rightLabel
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1.0
                                                                      constant:5.0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView
                                                                     attribute:NSLayoutAttributeRight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.rightLabel
                                                                     attribute:NSLayoutAttributeRight
                                                                    multiplier:1.0
                                                                      constant:15.0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView
                                                                     attribute:NSLayoutAttributeBottom
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.rightLabel
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1.0
                                                                      constant:5.0]];
    }
    return self;
}

@end
