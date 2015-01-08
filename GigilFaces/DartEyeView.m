//
//  DartEyeView.m
//  GigilFaces
//
//  Created by Nicole on 12/31/14.
//  Copyright (c) 2014 nicole. All rights reserved.
//

#import "DartEyeView.h"

@implementation DartEyeView

// Serial Number: A0006

- (NSString *)firstImageName {
    return @"DE1";
}

- (NSArray *)animatedImageNames {
    return @[@"DE1", @"DE2", @"DE3", @"DE4", @"DE5", @"DE6", @"DE7", @"DE8", @"DE9", @"DE10",
             @"DE11", @"DE12", @"DE13", @"DE14", @"DE15", @"DE16", @"DE17", @"DE18", @"DE19", @"DE20",
             @"DE21", @"DE22", @"DE23",
             @"DE23", @"DE22", @"DE21",
             @"DE20", @"DE19", @"DE18", @"DE17", @"DE16", @"DE15", @"DE14", @"DE13", @"DE12", @"DE11", @"DE10",
             @"DE9", @"DE8", @"DE7", @"DE6", @"DE5", @"DE4", @"DE3", @"DE2", @"DE1"];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
