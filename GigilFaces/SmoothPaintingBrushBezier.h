//
//  SmoothPaintingBrushBezier.h
//  GigilFaces
//
//  Created by Nicole on 8/22/14.
//  Copyright (c) 2014 nicole. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SmoothPaintingBrushBezier : UIBezierPath

@property (nonatomic) int counter; // counter variable to keep track of the point index

- (void)addFirstPoint:(CGPoint)firstPoint;

@end
