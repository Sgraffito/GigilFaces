//
//  GigilFacesDrawingVC.h
//  GigilFaces
//
//  Created by Nicole on 8/22/14.
//  Copyright (c) 2014 nicole. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GigilFacesDrawingVC : UIViewController

// Save drawing
// If -1, drawing has not been saved before
// If 1, drawing has been saved before
@property (nonatomic) int savedDataIndex;

@end
