//
//  SaveDrawingBoard.h
//  GigilFaces
//
//  Created by Nicole on 8/27/14.
//  Copyright (c) 2014 nicole. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SaveDrawingBoard : NSObject

@property (nonatomic, strong) UIImage *finalImage;
@property (nonatomic, strong) UIImage *finalSmallImage;
@property (strong, nonatomic) NSString *finalImageTitle;
//@property (strong, nonatomic) NSMutableArray *animatedImagesCategory; // Of NSNumber
//@property (strong, nonatomic) NSMutableArray *animatedImagesTag; // Of NSNumber
@property (strong, nonatomic) NSMutableArray *animatedImagesFrames; // Of CGRect
@property (strong, nonatomic) NSMutableArray *animatedImagesScale; // Of NSNumber
@property (strong, nonatomic) NSMutableArray *animatedImagesRotate; // Of NSNumber
@property (strong, nonatomic) NSMutableArray *animatedImagesCenter; // Of NSNumber
@property (strong, nonatomic) NSMutableArray *animatedImagesZIndex; // Of NSNumber
@property (strong, nonatomic) NSMutableArray *animatedImagesSerialNumber; //Of NSString
@property (strong, nonatomic) NSMutableArray *animatedImagesType; // Of NSString
@property (nonatomic) NSInteger maxZIndex;

@end
