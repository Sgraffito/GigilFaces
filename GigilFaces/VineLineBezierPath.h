//
//  VineLineBezierPath.h
//  VineDrawing
//
//  Created by Nicole on 8/13/14.
//  Copyright (c) 2014 nicole. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VineBranchBezierPath.h"

@protocol VineLineDelegate <NSObject>

- (void)vineLineDidCreateBranch:(VineBranchBezierPath *)branchPath;

@end

@interface VineLineBezierPath : UIBezierPath

- (void)addFirstPoint:(CGPoint)firstPoint;

@property (nonatomic) int counter; // counter variable to keep track of the point index
@property (nonatomic, weak) id delegate;
@property (nonatomic, retain, readonly) NSMutableArray *branchLines;
@property (nonatomic) float minBranchSeperation;
@property (nonatomic) float maxBranchLength;
@property (nonatomic) float leafSize;

@end
