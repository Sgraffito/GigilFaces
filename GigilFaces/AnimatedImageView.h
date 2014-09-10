//
//  AnimatedImageView.h
//  GigilFaces
//
//  Created by Nicole on 8/25/14.
//  Copyright (c) 2014 nicole. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnimatedImageView : UIImageView

- (void)animate;
- (NSArray *)animatedImageNames; // Abstract
- (NSString *)firstImageName; // Abstract
- (void)selectAnimatedImage:(UITapGestureRecognizer *)gesture;
- (BOOL)cancelButtonClicked:(CGPoint)point;
- (void)moveAnimatedImage:(UIPanGestureRecognizer *)gesture;

@end
