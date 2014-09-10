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

- (void)deleteMode:(BOOL)mode;

@end
