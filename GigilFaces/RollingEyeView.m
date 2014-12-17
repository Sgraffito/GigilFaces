//
//  RollingEyeView.m
//  GigilFaces
//
//  Created by Nicole on 8/26/14.
//  Copyright (c) 2014 nicole. All rights reserved.
//

#import "RollingEyeView.h"

@implementation RollingEyeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (NSString *)firstImageName {
    return @"ER1";
}

- (NSArray *)animatedImageNames {
    return @[@"ER1", @"ER2", @"ER3", @"ER4",
             @"ER5", @"ER6", @"ER7", @"ER8", @"ER9",
             @"ER10", @"ER9", @"ER8", @"ER7", @"ER6",
             @"ER5", @"ER4", @"ER3", @"ER2", @"ER1"];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
