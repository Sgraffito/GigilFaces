//
//  ColorSelectedView.m
//  GigilFaces
//
//  Created by Nicole on 8/22/14.
//  Copyright (c) 2014 nicole. All rights reserved.
//

#import "ColorSelectedView.h"

@implementation ColorSelectedView

// NOT CURRENTLY USED
// DELETED FROM STORYBOARD

#pragma mark - Initialization

- (void)setSelectedColor:(UIColor *)selectedColor {
    _selectedColor = selectedColor;
    [self setNeedsDisplay];
}

#pragma mark - Drawing

#define CIRCLE_SIZE 58.0

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Round the corners of the view
    UIBezierPath *roundedCorners = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:45.0];
    [roundedCorners addClip];
    
    // Set the background color of the view
    [[UIColor whiteColor] setFill];
    [roundedCorners fill];
    
    // Add a shadow to the background of the view
    self.layer.masksToBounds = NO;
    self.layer.cornerRadius = 8;                        // Rounded corners
    self.layer.shadowOffset = CGSizeMake(10, 10);       // Location of shadow
    self.layer.shadowRadius = 15;                       // Bigger number makes the shadow edges blurry
    self.layer.shadowOpacity = 0.6;                     // Darkness of the shadow
    CGColorRef shadowColor = [[UIColor colorWithRed:67 / 255.0
                                              green:184 / 255.0
                                               blue:106 / 255.0
                                              alpha:1.0] CGColor];
    self.layer.shadowColor = shadowColor;               // Color of shadow

    // Draw Selected circle
    CGRect circle = CGRectMake(self.frame.size.width / 2.0 - CIRCLE_SIZE / 2.0,
                               self.frame.size.height / 2.0 - CIRCLE_SIZE / 2.0,
                               CIRCLE_SIZE,
                               CIRCLE_SIZE);
    UIBezierPath *selectedColorCircle = [UIBezierPath bezierPathWithOvalInRect:circle];
    
    // Selected circle color
    [self.selectedColor setFill];
    [selectedColorCircle fill];
    
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

- (void)setUp {
    
    // Set the background color of the view to transparent
    self.backgroundColor = nil;
    self.opaque = NO;
}


@end
