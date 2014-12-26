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
@property (strong, nonatomic) UIImage *incrementalImage;
@property (strong, nonatomic) UIImage *smallImage;
@property (nonatomic) int savedDataIndex;
@property (strong, nonatomic) NSString *drawingTitle;

- (void)addFirstTimeFaceAnimation:(int)tag category:(int)category
                        xLocation:(float)x yLocation:(float)y
                       scaleValue:(float)scale rotateValue:(float)rotate
                      centerValue:(CGPoint)center
                        imageType:(NSString *)imageType;
- (void)addFaceAnimation:(NSString *)serialNumber
               xLocation:(float)x yLocation:(float)y
              scaleValue:(float)scale rotateValue:(float)rotate
             centerValue:(CGPoint)center
                  zIndex:(int)zIndexValue;
- (void)playAnimationButtonClicked;
- (void)clearAnimatedArray;
- (void)undoPaintingMistakes;
- (void)redoPaintingMistakes;
- (int)getAnimatedViewCount;
- (void)saveImageToCameraRoll;
- (void)saveImage;
- (void)createNewDrawing;

@end
