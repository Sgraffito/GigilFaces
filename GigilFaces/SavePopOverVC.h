//
//  SavePopOverVC.h
//  GigilFaces
//
//  Created by Nicole on 8/29/14.
//  Copyright (c) 2014 nicole. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SavePopOverViewControllerDelegate
- (void)savedTitle:(NSString *)drawingTitle;
- (void)doneButton;
- (void)savePictureToCameraRoll;

@end

@interface SavePopOverVC : UIViewController

@property (nonatomic, strong) id <SavePopOverViewControllerDelegate> delegate;
@property (strong, nonatomic) NSString *drawingTitle;
@property (strong, nonatomic) NSString *drawingSubtitle;

@end
