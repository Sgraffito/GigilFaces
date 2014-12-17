//
//  TalkingMouthView.m
//  GigilFaces
//
//  Created by Nicole on 12/4/14.
//  Copyright (c) 2014 nicole. All rights reserved.
//

#import "TalkingMouthView.h"

@implementation TalkingMouthView

- (NSString *)firstImageName {
    return @"TM1";
}

- (NSArray *)animatedImageNames {
    return @[@"TM1", @"TM2", @"TM3", @"TM4",
             @"TM5", @"TM6", @"TM7", @"TM8", @"TM9",
             @"TM10", @"TM11", @"TM12"];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
