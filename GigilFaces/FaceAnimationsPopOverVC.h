//
//  FaceAnimationsPopOverVC.h
//  GigilFaces
//
//  Created by Nicole on 8/23/14.
//  Copyright (c) 2014 nicole. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol FaceAnimationPopOverViewControllerDelegate
- (void)faceShapeChanged:(int)tag category:(int)category;
@end

@interface FaceAnimationsPopOverVC : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) id <FaceAnimationPopOverViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UICollectionView *animationsCollectionView;

@end
