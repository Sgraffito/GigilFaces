//
//  ToothyGrinView.m
//  GigilFaces
//
//  Created by Nicole on 8/26/14.
//  Copyright (c) 2014 nicole. All rights reserved.
//

#import "ToothyGrinView.h"

@implementation ToothyGrinView

- (NSString *)firstImageName {
    return @"toothy_grin1.png";
}

- (NSArray *)animatedImageNames {
    return @[@"toothy_grin1.png", @"toothy_grin2.png", @"toothy_grin3.png", @"toothy_grin4.png",
             @"toothy_grin5.png", @"toothy_grin6.png", @"toothy_grin7.png", @"toothy_grin8.png", @"toothy_grin9.png",
             @"toothy_grin10.png"];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
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
