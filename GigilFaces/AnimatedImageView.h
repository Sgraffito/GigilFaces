//
//  AnimatedImageView.h
//  GigilFaces
//
//  Created by Nicole on 8/25/14.
//  Copyright (c) 2014 nicole. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnimatedImageView : UIImageView

// Scaling
@property (nonatomic) float finalScaleValue;
@property (nonatomic) float finalRotateValue;
@property (nonatomic) int finalZIndex;

- (void)animate;
- (NSArray *)animatedImageNames; // Abstract
- (NSString *)firstImageName; // Abstract
- (BOOL)selectAnimatedImage:(UITapGestureRecognizer *)gesture;
- (BOOL)cancelButtonClicked:(CGPoint)point;

@end
