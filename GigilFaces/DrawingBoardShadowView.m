//
//  DrawingBoardShadowView.m
//  GigilFaces
//
//  Created by Nicole on 8/22/14.
//  Copyright (c) 2014 nicole. All rights reserved.
//

#import "DrawingBoardShadowView.h"

@implementation DrawingBoardShadowView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Round the corners of the view
    UIBezierPath *roundedCorners = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:30.0];
    [roundedCorners addClip];
    
    // Set the background color of the view
    [[UIColor whiteColor] setFill];
    self.backgroundColor = [UIColor whiteColor];
    [roundedCorners fill];
    
    // Add a shadow to the background of the view
    self.layer.masksToBounds = NO;
    self.layer.cornerRadius = 0;                        // Rounded corners
    self.layer.shadowOffset = CGSizeMake(10, 10);       // Location of shadow
    self.layer.shadowRadius = 15;                       // Bigger number makes the shadow edges blurry
    self.layer.shadowOpacity = 0.6;                     // Darkness of the shadow
    CGColorRef shadowColor = [[UIColor colorWithRed:67 / 255.0
                                              green:184 / 255.0
                                               blue:106 / 255.0
                                              alpha:1.0] CGColor];
    self.layer.shadowColor = shadowColor;               // Color of shadow
    self.layer.shouldRasterize = YES;
}

#pragma mark - Setup

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    [self setUp];
}

/*  Setup the view when it first appears */
- (void)setUp {
}

@end
