//
//  MyDrawingCVCell.h
//  GigilFaces
//
//  Created by Nicole on 8/28/14.
//  Copyright (c) 2014 nicole. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CancelButtonView.h"

@interface MyDrawingCVCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *cellImage;
@property (weak, nonatomic) IBOutlet UILabel *cellTitle;

// If user clicks on edit in the segmented control, the view is in edit mode. Else the view is in delete mode
- (void)deleteMode:(BOOL)mode;

@end
