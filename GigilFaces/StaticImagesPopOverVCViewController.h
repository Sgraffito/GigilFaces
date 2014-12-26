//
//  StaticImagesPopOverVCViewController.h
//  GigilFaces
//
//  Created by Nicole on 12/26/14.
//  Copyright (c) 2014 nicole. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StaticImagesPopOverViewControllerDelegate
- (void)staticImageAdded:(int)tag category:(int)category;
@end

@interface StaticImagesPopOverVCViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) id <StaticImagesPopOverViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UICollectionView *staticImagesCollectionView;

@end
