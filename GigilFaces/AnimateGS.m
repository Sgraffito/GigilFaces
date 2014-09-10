//
//  AnimateGS.m
//  GigilFaces
//
//  Created by Nicole on 8/25/14.
//  Copyright (c) 2014 nicole. All rights reserved.
//

#import "AnimateGS.h"

@implementation AnimateGS

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (NSString *)firstImageName {
    return @"win_1.png";
}

- (NSArray *)animatedImageNames {
    return @[@"win_1.png", @"win_2.png", @"win_3.png", @"win_4.png",
             @"win_5.png", @"win_6.png", @"win_7.png", @"win_8.png",
             @"win_9.png", @"win_10.png", @"win_11.png", @"win_12.png",
             @"win_13.png", @"win_14.png", @"win_15.png", @"win_16.png"];
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
