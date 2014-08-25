//
//  BrushSizeView.m
//  PopOverViewControllerTest
//
//  Created by Nicole on 8/19/14.
//  Copyright (c) 2014 nicole. All rights reserved.
//

#import "BrushSizeView.h"


@implementation BrushSizeView

- (void)setBrushSize:(float)brushSize {
    _brushSize = brushSize;
    [self setNeedsDisplay];
}

- (void)setBrushColor:(UIColor *)brushColor {
    _brushColor = brushColor;
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    CGRect circle = CGRectMake((self.bounds.size.width / 2.0) - (self.brushSize / 2.0),
                               (self.bounds.size.height / 2.0) - (self.brushSize / 2.0),
                               self.brushSize,
                               self.brushSize);
    UIBezierPath *clip = [UIBezierPath bezierPathWithOvalInRect:circle];
    [clip addClip];
    [self.brushColor setFill];
    [clip fill];
}

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
