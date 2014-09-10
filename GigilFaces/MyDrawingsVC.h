//
//  MyDrawingsVC.h
//  GigilFaces
//
//  Created by Nicole on 8/28/14.
//  Copyright (c) 2014 nicole. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyDrawingCVCell.h"

@class MyDrawingsVC;

@interface MyDrawingsVC : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) NSMutableArray *myDrawingImages; // Of UIImage
@property (strong, nonatomic) NSMutableArray *myDrawingTitles; // Of NSString

- (void)addImage:(UIImage *)image;

@end
