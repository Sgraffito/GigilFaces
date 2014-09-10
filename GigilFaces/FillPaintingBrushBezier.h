//
//  FillPaintingBrushBezier.h
//  GigilFaces
//
//  Created by Nicole on 9/3/14.
//  Copyright (c) 2014 nicole. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FillPaintingBrushBezier : UIBezierPath

@property (nonatomic) int counter; // counter variable to keep track of the point index

- (void)addFirstPoint:(CGPoint)firstPoint;
- (void)addNextPoint:(CGPoint)point;

@end
