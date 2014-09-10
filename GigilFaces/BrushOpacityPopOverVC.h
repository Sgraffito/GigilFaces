//
//  BrushOpacityPopOverVC.h
//  GigilFaces
//
//  Created by Nicole on 8/22/14.
//  Copyright (c) 2014 nicole. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BrushOpacityPopOverViewControllerDelegate

- (void)opacityValueChanged:(float)opacity;

@end

@interface BrushOpacityPopOverVC : UIViewController

@property (nonatomic, strong) id <BrushOpacityPopOverViewControllerDelegate> delegate;
@property (nonatomic) float brushOpacity;
@property (strong, nonatomic) UIColor *brushColor;

@end
