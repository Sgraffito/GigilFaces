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

- (void)setOpacity:(float)opacity {
    _opacity = opacity;
    [self setNeedsDisplay];
}

- (void)setBrushColor:(UIColor *)brushColor {
    _brushColor = brushColor;
    [self setNeedsDisplay];
}

#pragma mark - Drawing

#define BRUSH_SIZE 200.0

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGRect circle = CGRectMake((self.bounds.size.width / 2.0) - (BRUSH_SIZE / 2.0),
                               (self.bounds.size.height / 2.0) - (BRUSH_SIZE / 2.0),
                               BRUSH_SIZE,
                               BRUSH_SIZE);
    UIBezierPath *clip = [UIBezierPath bezierPathWithOvalInRect:circle];
    
    [self.brushColor setFill];
    [clip fillWithBlendMode:kCGBlendModeNormal alpha:self.opacity];
    [clip addClip];
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
    self.backgroundColor = nil;
    self.opaque = NO;
}

@end
