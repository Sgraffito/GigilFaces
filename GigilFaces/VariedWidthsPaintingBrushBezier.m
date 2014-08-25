//
//  VariedWidthsPaintingBrushBezier.m
//  GigilFaces
//
//  Created by Nicole on 8/22/14.
//  Copyright (c) 2014 nicole. All rights reserved.
//

#import "VariedWidthsPaintingBrushBezier.h"
#import <dispatch/dispatch.h>

#define CAPACITY 100

typedef struct {
    CGPoint firstPoint;
    CGPoint secondPoint;
} LineSegment;

@implementation VariedWidthsPaintingBrushBezier {
    CGPoint pts[5];
    CGPoint ptsBuffer[CAPACITY];
    int bufIdx;
    int ctr;
    BOOL isFirstTouchPoint;
    LineSegment lastSegmentOfPrev;
    LineSegment curveAdjacentSegments;
    dispatch_queue_t drawingQueue;
    float FF;
    float LOWER;
    float UPPER;
}

- (void)addFirstPoint:(CGPoint)firstPoint {
    drawingQueue = dispatch_queue_create("drawingQueue", NULL);
    ctr = 0;
    bufIdx = 0;
    pts[0] = firstPoint;
    isFirstTouchPoint = YES;
}

- (void)moveToPoint:(CGPoint)point {
    [super moveToPoint:point];
}

- (void)addCurveToPoint:(CGPoint)endPoint controlPoint1:(CGPoint)controlPoint1 controlPoint2:(CGPoint)controlPoint2 {
    [super addCurveToPoint:endPoint controlPoint1:controlPoint1 controlPoint2:controlPoint2];
}

- (void)addLineToPoint:(CGPoint)point {
    [super addLineToPoint:point];
}

- (void)setLineWidth:(CGFloat)lineWidth {
    FF = lineWidth / 50;
    LOWER = .05;
    UPPER = 2.75;
}

- (void)addLastPoint:(CGPoint)point {
    
    LineSegment firstPoint = lastSegmentOfPrev;
    
    if (isFirstTouchPoint) { return; }
    
    LineSegment lastPoint = (LineSegment){ (CGPoint){point.x, point.y}, (CGPoint){point.x, point.y} };
    
    float frac1 = FF/clamp(len_sq(firstPoint.firstPoint, lastPoint.firstPoint), LOWER, UPPER);
    float frac2 = FF/clamp(len_sq(firstPoint.secondPoint, lastPoint.secondPoint), LOWER, UPPER);
    
    LineSegment ls[2];
    ls[0] = [self lineSegmentPerpendicularTo:(LineSegment){firstPoint.firstPoint, lastPoint.firstPoint} ofRelativeLength:frac1];
    ls[1] = [self lineSegmentPerpendicularTo:(LineSegment){firstPoint.secondPoint, lastPoint.secondPoint} ofRelativeLength:frac2];
    
    [self moveToPoint:firstPoint.firstPoint];
    [self addCurveToPoint:lastPoint.firstPoint controlPoint1:ls[0].firstPoint controlPoint2:ls[1].firstPoint];
    
    [self addLineToPoint:lastPoint.secondPoint];
    [self addCurveToPoint:firstPoint.secondPoint controlPoint1:ls[0].secondPoint controlPoint2:ls[0].secondPoint];
    [self closePath];
}

- (void)addPoint:(CGPoint)point {
    CGPoint p = point;
    ctr += 1;
    pts[ctr] = p;
    
    if (ctr == 4) {
        
        pts[3] = CGPointMake((pts[2].x + pts[4].x) / 2.0,
                             (pts[2].y + pts[4].y) / 2.0);
        
        for (int i = 0; i < 4; i++) {
            ptsBuffer[bufIdx + i] = pts[i];
        }
        
        bufIdx += 4;
        
        dispatch_async(drawingQueue, ^{
            [self removeAllPoints];
            
            if (bufIdx == 0) { return; }
            
            LineSegment ls[4];
            
            for (int i = 0; i < bufIdx; i += 4) {
                
                float frac1 = FF/clamp(len_sq(ptsBuffer[i], ptsBuffer[i+1]), LOWER, UPPER);
                float frac2 = FF/clamp(len_sq(ptsBuffer[i+1], ptsBuffer[i+2]), LOWER, UPPER);
                float frac3 = FF/clamp(len_sq(ptsBuffer[i+2], ptsBuffer[i+3]), LOWER, UPPER);
                
                ls[1] = [self lineSegmentPerpendicularTo:(LineSegment){ptsBuffer[i], ptsBuffer[i+1]} ofRelativeLength:frac1];
                ls[3] = [self lineSegmentPerpendicularTo:(LineSegment){ptsBuffer[i+2], ptsBuffer[i+3]} ofRelativeLength:frac3];
                
                if (isFirstTouchPoint) {
                    ls[0] = (LineSegment) {ptsBuffer[0], ptsBuffer[0]};
                    ls[2] = [self lineSegmentPerpendicularTo:(LineSegment){ptsBuffer[i+1], ptsBuffer[i+2]} ofRelativeLength:frac2];
                    [self moveToPoint:ls[0].firstPoint];
                    isFirstTouchPoint = NO;
                }
                
                else {
                    ls[0] = lastSegmentOfPrev;
                    
                    float xDistance = curveAdjacentSegments.firstPoint.x - lastSegmentOfPrev.firstPoint.x;
                    float yDistance = curveAdjacentSegments.firstPoint.y - lastSegmentOfPrev.firstPoint.y;
                    
                    float xDistance2 = curveAdjacentSegments.secondPoint.x - lastSegmentOfPrev.secondPoint.x;
                    float yDistance2 = curveAdjacentSegments.secondPoint.y - lastSegmentOfPrev.secondPoint.y;
                    
                    LineSegment newCurve;
                    newCurve = (LineSegment){ (CGPoint){lastSegmentOfPrev.firstPoint.x + xDistance, lastSegmentOfPrev.firstPoint.y + yDistance},
                        (CGPoint){lastSegmentOfPrev.secondPoint.x + xDistance2, lastSegmentOfPrev.secondPoint.y + yDistance2} };
                    
                    ls[2] = [self lineSegmentPerpendicularTo:(LineSegment){ptsBuffer[i+1], ptsBuffer[i+2]} ofRelativeLength:frac2];
                }
                
                
                [self moveToPoint:ls[0].firstPoint];
                [self addCurveToPoint:ls[3].firstPoint controlPoint1:ls[1].firstPoint controlPoint2:ls[2].firstPoint];
                
                [self addLineToPoint:ls[3].secondPoint];
                [self addCurveToPoint:ls[0].secondPoint controlPoint1:ls[2].secondPoint controlPoint2:ls[1].secondPoint];
                [self closePath];
                
                lastSegmentOfPrev = ls[3];
                curveAdjacentSegments = ls[2];
                
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                bufIdx = 0;
            });
            
        });
        pts[0] = pts[3];
        pts[1] = pts[4];
        ctr = 1;
    }
}

-(LineSegment) lineSegmentPerpendicularTo: (LineSegment)pp ofRelativeLength:(float)fraction {
    CGFloat x0 = pp.firstPoint.x, y0 = pp.firstPoint.y, x1 = pp.secondPoint.x, y1 = pp.secondPoint.y;
    
    CGFloat dx, dy;
    dx = x1 - x0;
    dy = y1 - y0;
    
    CGFloat xa, ya, xb, yb;
    xa = x1 + fraction/2 * dy;
    ya = y1 - fraction/2 * dx;
    xb = x1 - fraction/2 * dy;
    yb = y1 + fraction/2 * dx;
    
    return (LineSegment){ (CGPoint){xa, ya}, (CGPoint){xb, yb} };
}

float len_sq(CGPoint p1, CGPoint p2) {
    float dx = p2.x - p1.x;
    float dy = p2.y - p1.y;
    return dx * dx + dy * dy;
}

float clamp(float value, float lower, float higher) {
    if (value < lower) return lower;
    if (value > higher) return higher;
    return value;
}

@end
