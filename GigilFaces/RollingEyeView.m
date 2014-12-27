//
//  RollingEyeView.m
//  GigilFaces
//
//  Created by Nicole on 12/26/14.
//  Copyright (c) 2014 nicole. All rights reserved.
//

#import "RollingEyeView.h"

@implementation RollingEyeView

// Serial Number: A0003

- (NSString *)firstImageName {
    return @"ER1";
}

- (NSArray *)animatedImageNames {
    return @[@"ER1", @"ER2", @"ER3", @"ER4", @"ER5", @"ER6", @"ER7", @"ER8", @"ER9", @"ER10",
             @"ER10", @"ER9", @"ER8", @"ER7", @"ER6", @"ER5", @"ER4", @"ER3", @"ER2", @"ER1"];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
