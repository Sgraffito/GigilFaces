//
//  ColorSelectedView.m
//  GigilFaces
//
//  Created by Nicole on 8/22/14.
//  Copyright (c) 2014 nicole. All rights reserved.
//

#import "ColorSelectedView.h"

@interface ColorSelectedView()
@property (strong, nonatomic) UIColor *dkGrey;
@end

@implementation ColorSelectedView

// NOT CURRENTLY USED
// DELETED FROM STORYBOARD

#pragma mark - Initialization

- (void)setSelectedColor:(UIColor *)selectedColor {
    _selectedColor = selectedColor;
    [self setNeedsDisplay];
}

- (UIColor *)dkGrey {
    if (!_dkGrey) _dkGrey = [UIColor colorWithRed:28 / 255.0 green:28 / 255.0 blue:28 / 255.0 alpha:1.0];
    return _dkGrey;
}

#pragma mark - Drawing

#define RECT_SIZE 58.0

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Round the corners of the view
    UIBezierPath *roundedCorners = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:4.0];
    [roundedCorners addClip];
    
    // Set the background color of the view
    [self.dkGrey setFill];
    [roundedCorners fill];
    
    // Draw Selected circle
    CGRect circle = CGRectMake(self.frame.size.width / 2.0 - RECT_SIZE / 1.95,
                               self.frame.size.height / 2.0 - RECT_SIZE / 2.1,
                               RECT_SIZE,
                               RECT_SIZE - 3.0);
    UIBezierPath *selectedColorCircle = [UIBezierPath bezierPathWithRect:circle];
    
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
