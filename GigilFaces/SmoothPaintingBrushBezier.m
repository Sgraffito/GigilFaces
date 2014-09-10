//
//  SmoothPaintingBrushBezier.m
//  GigilFaces
//
//  Created by Nicole on 8/22/14.
//  Copyright (c) 2014 nicole. All rights reserved.
//

#import "SmoothPaintingBrushBezier.h"

@implementation SmoothPaintingBrushBezier {
    CGPoint points[5];
}

- (void)addFirstPoint:(CGPoint)firstPoint {
    points[0] = firstPoint;
}

- (void)moveToPoint:(CGPoint)point {
    [super moveToPoint:point];
}

- (void)addLineToPoint:(CGPoint)point {
    CGPoint p = point;
    self.counter += 1;
    points[self.counter] = p;
    
    // Draw the segment
    if (self.counter == 4) {
        points[3] = CGPointMake((points[2].x + points[4].x) / 2.0,
                                (points[2].y + points[4].y) / 2.0);
        [self moveToPoint:points[0]];
        [self addCurveToPoint:points[3]
                controlPoint1:points[1]
                controlPoint2:points[2]];
        
        // Replace points and get ready to handle next segment
        points[0] = points[3];
        points[1] = points[4];
        self.counter = 1;
    }
}

- (void)closePath {
    [super closePath];
}

@end
