//
//  DrawingBoardView.h
//  GigilFaces
//
//  Created by Nicole on 8/22/14.
//  Copyright (c) 2014 nicole. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawingBoardView : UIView

@property (nonatomic) int brushSelected;
@property (nonatomic) float brushSize;
@property (nonatomic) float brushOpacity;
@property (strong, nonatomic) UIColor *brushColor;
@property (nonatomic) BOOL clearCanvas;

- (void)addFaceAnimation:(int)tag category:(int)category;
- (void)playAnimationButtonClicked;
- (void)clearAnimatedArray;

@end
