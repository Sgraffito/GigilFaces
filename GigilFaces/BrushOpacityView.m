//
//  BrushOpacityView.m
//  GigilFaces
//
//  Created by Nicole on 8/22/14.
//  Copyright (c) 2014 nicole. All rights reserved.
//

#import "BrushOpacityView.h"

@implementation BrushOpacityView

#pragma mark - Initalization

/**
 *  Set the opacity of the brush. If the brush opacity changes,
 *  redraw the circle in the pop-over.
 *
 *  @param opacity Opacity of the brush.
 */
- (void)setOpacity:(float)opacity {
    _opacity = opacity;
    // Redraw circle
    [self setNeedsDisplay];
}

/**
 *  Set the color of the brush. If the brush color changes,
 *  If the brush color changes, redraw the circle in the pop-over.
 *
 *  @param brushColor Color of the brush.
 */
- (void)setBrushColor:(UIColor *)brushColor {
    _brushColor = brushColor;
    // Redraw circle
    [self setNeedsDisplay];
}

#pragma mark - Drawing

// Brush size in the Brush Opacity Pop-Over is constant
#define BRUSH_SIZE 200.0

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    // Create a circle
    CGRect circle = CGRectMake((self.bounds.size.width / 2.0) - (BRUSH_SIZE / 2.0),
                               (self.bounds.size.height / 2.0) - (BRUSH_SIZE / 2.0),
                               BRUSH_SIZE,
                               BRUSH_SIZE);
    UIBezierPath *clip = [UIBezierPath bezierPathWithOvalInRect:circle];
    
    // Set the color of the circle
    [self.brushColor setFill];
    [clip fillWithBlendMode:kCGBlendModeNormal alpha:self.opacity];
    [clip addClip];
}

#pragma mark - Setup

/**
 *  When view first loads, call setUp function.
 *
 *  @param frame
 *
 *  @return id
 */
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

/**
 *  When view awakes, call the setUp function
 */
- (void)awakeFromNib {
    [self setUp];
}

/**
 *  Set the backgound color of the shape to transparent.
 *  Important! Background around the circle will be white otherwise.
 */
- (void)setUp {
    self.backgroundColor = nil;
    self.opaque = NO;
}

@end
