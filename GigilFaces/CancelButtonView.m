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


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    UIBezierPath *clippingBounds = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:40.0];
    [clippingBounds addClip];
    
    [[UIColor redColor] setFill];
    [clippingBounds fill];
    
    // Add a shadow to the background of the view
    self.layer.masksToBounds = NO;
    self.layer.cornerRadius = 0;                        // Rounded corners
    self.layer.shadowOffset = CGSizeMake(2, 2);         // Location of shadow
    self.layer.shadowRadius = 2;                        // Bigger number makes the shadow edges blurry
    self.layer.shadowOpacity = 0.25;                     // Darkness of the shadow
    CGColorRef shadowColor = [[UIColor darkGrayColor] CGColor];
    self.layer.shadowColor = shadowColor;               // Color of shadow
    
    // Add a stroke
    [[UIColor whiteColor] setStroke];
    [clippingBounds setLineWidth:6.0];
    [clippingBounds stroke];
    
    // Add an x
    UIBezierPath *diagonalLine = [UIBezierPath bezierPath];
    [diagonalLine moveToPoint:CGPointMake(0, 0)];
    [diagonalLine addLineToPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height)];
    [diagonalLine closePath];
    [[UIColor whiteColor] setStroke];
    [diagonalLine setLineWidth:4.0];
    [diagonalLine stroke];
    
    UIBezierPath *diagonaLine2 = [UIBezierPath bezierPath];
    [diagonaLine2 moveToPoint:CGPointMake(0, self.bounds.size.height)];
    [diagonaLine2 addLineToPoint:CGPointMake(self.bounds.size.width, 0)];
    [diagonaLine2 closePath];
    [[UIColor whiteColor] setStroke];
    [diagonaLine2 setLineWidth:4.0];
    [diagonaLine2 stroke];
}

- (void)awakeFromNib {
    [self setUp];
}

- (void)setUp {
    self.backgroundColor = nil;
    self.opaque = NO;
}


@end
