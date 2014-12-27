//
//  BlinkingEyeView.m
//  GigilFaces
//
//  Created by Nicole on 12/16/14.
//  Copyright (c) 2014 nicole. All rights reserved.
//

#import "BlinkingEyeView.h"

@implementation BlinkingEyeView

// Serial Number: A0001

- (NSString *)firstImageName {
    return @"EB1";
}

- (NSArray *)animatedImageNames {
    return @[@"EB1", @"EB1", @"EB1",
             @"EB2", @"EB2", @"EB2", @"EB2",
             @"EB3", @"EB3", @"EB3",
             @"EB2", @"EB2", @"EB2"];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
