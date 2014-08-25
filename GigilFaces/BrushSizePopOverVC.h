//
//  BrushSizePopOverVC.h
//  GigilFaces
//
//  Created by Nicole on 8/22/14.
//  Copyright (c) 2014 nicole. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BrushSizePopOverViewControllerDelegate

-(void)sliderValueChanged:(float)brushSize;

@end

@interface BrushSizePopOverVC : UIViewController

@property (nonatomic, strong) id <BrushSizePopOverViewControllerDelegate> delegate;
@property (nonatomic) float brushSize;
@property (strong, nonatomic) UIColor *brushColor;

@end
