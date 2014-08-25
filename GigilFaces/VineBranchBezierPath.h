//
//  VineBranchBezierPath.h
//  VineDrawing
//
//  Created by Nicole on 8/13/14.
//  Copyright (c) 2014 nicole. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VineBranchBezierPath : UIBezierPath

- (id)initWithRandomPathFromPoint:(CGPoint)startPoint maxLength:(float)maxLength leafSize:(float)leafSize;

@end
