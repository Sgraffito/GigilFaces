//
//  VariedWidthsPaintingBrushBezier.h
//  GigilFaces
//
//  Created by Nicole on 8/22/14.
//  Copyright (c) 2014 nicole. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VariedWidthsPaintingBrushBezier : UIBezierPath

- (void)addFirstPoint:(CGPoint)firstPoint;
- (void)addPoint:(CGPoint)point;
- (void)addLastPoint:(CGPoint)point;

@end
