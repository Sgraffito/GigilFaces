//
//  SaveDrawingBoard.m
//  GigilFaces
//
//  Created by Nicole on 8/27/14.
//  Copyright (c) 2014 nicole. All rights reserved.
//

#import "SaveDrawingBoard.h"

@interface SaveDrawingBoard()
@end

@implementation SaveDrawingBoard

#define FINAL_IMAGE             @"Final Image"
#define FINAL_SMALL_IMAGE       @"Final Small Image"
#define IMAGE_TITLE             @"Image Label"
#define IMAGE_SUBTITLE          @"Image Subtitle"
#define ANIMATED_IMAGES         @"Animated Images"
#define ANIMATED_IMAGES_FRAME   @"Animated Images Frame"
#define ANIMATED_IMAGES_SCALE   @"Animated Images Scale"
#define ANIMATED_IMAGES_ROTATE  @"Animated Images Rotate"
#define ANIMATED_IMAGES_CENTER  @"Animated Images Center"
#define ANIMATED_IMAGES_SERIAL  @"Animated Images Serial Number"
#define ANIMATED_IMAGES_TYPE    @"Animated Images Type"
#define ANIMATED_IMAGES_Z       @"Animated Images Z-Index"
#define MAX_Z_INDEX             @"Max Z Index"


#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.finalImage forKey:FINAL_IMAGE];
    [aCoder encodeObject:self.finalSmallImage forKey:FINAL_SMALL_IMAGE];
    [aCoder encodeObject:self.finalImageTitle forKey:IMAGE_TITLE];
    [aCoder encodeObject:self.animatedImagesFrames forKey:ANIMATED_IMAGES_FRAME];
    [aCoder encodeObject:self.animatedImagesScale forKey:ANIMATED_IMAGES_SCALE];
    [aCoder encodeObject:self.animatedImagesRotate forKey:ANIMATED_IMAGES_ROTATE];
    [aCoder encodeObject:self.animatedImagesCenter forKey:ANIMATED_IMAGES_CENTER];
    [aCoder encodeObject:self.animatedImagesSerialNumber forKey:ANIMATED_IMAGES_SERIAL];
    [aCoder encodeObject:self.animatedImagesType forKey:ANIMATED_IMAGES_TYPE];
    [aCoder encodeObject:self.animatedImagesZIndex forKey:ANIMATED_IMAGES_Z];
    [aCoder encodeInteger:self.maxZIndex forKey:MAX_Z_INDEX];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        [self setFinalImage:[aDecoder decodeObjectForKey:FINAL_IMAGE]];
        [self setFinalSmallImage:[aDecoder decodeObjectForKey:FINAL_SMALL_IMAGE]];
        [self setFinalImageTitle:[aDecoder decodeObjectForKey:IMAGE_TITLE]];
        [self setAnimatedImagesFrames:[aDecoder decodeObjectForKey:ANIMATED_IMAGES_FRAME]];
        [self setAnimatedImagesScale:[aDecoder decodeObjectForKey:ANIMATED_IMAGES_SCALE]];
        [self setAnimatedImagesRotate:[aDecoder decodeObjectForKey:ANIMATED_IMAGES_ROTATE]];
        [self setAnimatedImagesCenter:[aDecoder decodeObjectForKey:ANIMATED_IMAGES_CENTER]];
        [self setAnimatedImagesSerialNumber:[aDecoder decodeObjectForKey:ANIMATED_IMAGES_SERIAL]];
        [self setAnimatedImagesType:[aDecoder decodeObjectForKey:ANIMATED_IMAGES_TYPE]];
        [self setAnimatedImagesZIndex:[aDecoder decodeObjectForKey:ANIMATED_IMAGES_Z]];
        [self setMaxZIndex:[aDecoder decodeIntegerForKey:MAX_Z_INDEX]];
    }
    return self;
}


@end
