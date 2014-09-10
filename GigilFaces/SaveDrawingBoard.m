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
#define STATIC_IMAGES           @"Static Images"

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.finalImage forKey:FINAL_IMAGE];
    [aCoder encodeObject:self.finalSmallImage forKey:FINAL_SMALL_IMAGE];
    [aCoder encodeObject:self.finalImageTitle forKey:IMAGE_TITLE];
    [aCoder encodeObject:self.animatedImages forKey:ANIMATED_IMAGES];
    [aCoder encodeObject:self.animatedImagesFrames forKey:ANIMATED_IMAGES_FRAME];
    [aCoder encodeObject:self.staticImages forKey:STATIC_IMAGES];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        [self setFinalImage:[aDecoder decodeObjectForKey:FINAL_IMAGE]];
        [self setFinalSmallImage:[aDecoder decodeObjectForKey:FINAL_SMALL_IMAGE]];
        [self setFinalImageTitle:[aDecoder decodeObjectForKey:IMAGE_TITLE]];
        [self setAnimatedImages:[aDecoder decodeObjectForKey:ANIMATED_IMAGES]];
        [self setAnimatedImagesFrames:[aDecoder decodeObjectForKey:ANIMATED_IMAGES_FRAME]];
        [self setStaticImages:[aDecoder decodeObjectForKey:STATIC_IMAGES]];
    }
    return self;
}


@end
