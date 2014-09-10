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
    return @"eye_roll1.png";
}

- (NSArray *)animatedImageNames {
    return @[@"eye_roll1.png", @"eye_roll2.png", @"eye_roll3.png", @"eye_roll4.png",
             @"eye_roll5.png", @"eye_roll6.png", @"eye_roll7.png", @"eye_roll8.png", @"eye_roll9.png",
             @"eye_roll10.png", @"eye_roll11.png", @"eye_roll12.png", @"eye_roll13.png", @"eye_roll14.png",
             @"eye_roll15.png", @"eye_roll16.png", @"eye_roll17.png", @"eye_roll18.png"];
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
