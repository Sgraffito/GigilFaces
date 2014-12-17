//
//  CancelButtonView.m
//  GigilFaces
//
//  Created by Nicole on 8/26/14.
//  Copyright (c) 2014 nicole. All rights reserved.
//

#import "CancelButtonView.h"

@interface CancelButtonView()
@property (strong, nonatomic) UIImage *buttonImage;
@property (nonatomic) float scale;
@end

@implementation CancelButtonView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (float)scale {
    if (!_scale) _scale = 1;
    return _scale;
}

- (void)scaleChanged:(float)scale {
    self.scale = scale;
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
//    float newWidth = self.bounds.size.width - 3;
//    float newHeight = self.bounds.size.height - 3;
//    CGRect newRect = CGRectMake(self.bounds.origin.x + 3, self.bounds.origin.y + 3, newWidth, newHeight);

    UIBezierPath *clippingBounds = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:30.0];
    [clippingBounds addClip];
    
    [[UIColor whiteColor] setFill];
    [clippingBounds fill];
    
    // Add a shadow to the background of the view
//    self.layer.masksToBounds = NO;
//    self.layer.cornerRadius = 0;                        // Rounded corners
//    self.layer.shadowOffset = CGSizeMake(1, 2);         // Location of shadow
//    self.layer.shadowRadius = 2;                        // Bigger number makes the shadow edges blurry
//    self.layer.shadowOpacity = 0.25;                    // Darkness of the shadow
//    CGColorRef shadowColor = [[UIColor darkGrayColor] CGColor];
//    self.layer.shadowColor = shadowColor;               // Color of shadoww
    
    
    // Add an x
    UIBezierPath *diagonalLine = [UIBezierPath bezierPath];
    [diagonalLine moveToPoint:CGPointMake(self.bounds.origin.x + 8, self.bounds.origin.y + 8)];
    [diagonalLine addLineToPoint:CGPointMake(self.bounds.size.width - 8, self.bounds.size.height - 8)];
    [diagonalLine closePath];
    [[UIColor redColor] setStroke];
    [diagonalLine setLineWidth:3.0];
    [diagonalLine stroke];
    
    UIBezierPath *diagonaLine2 = [UIBezierPath bezierPath];
    [diagonaLine2 moveToPoint:CGPointMake(self.bounds.origin.x + 8, self.bounds.size.height - 8)];
    [diagonaLine2 addLineToPoint:CGPointMake(self.bounds.size.width - 8, self.bounds.origin.y + 8)];
    [diagonaLine2 closePath];
    [[UIColor redColor] setStroke];
    [diagonaLine2 setLineWidth:3.0];
    [diagonaLine2 stroke];
    
    // Add a stroke
    [[UIColor redColor] setStroke];
    [clippingBounds setLineWidth:6.0];
    [clippingBounds stroke];
}

- (void)awakeFromNib {
    [self setUp];
}

- (void)setUp {
    self.backgroundColor = nil;
    self.opaque = NO;
    self.scale = 1;
}


@end
