//
//  AnimatedImageView.m
//  GigilFaces
//
//  Created by Nicole on 8/25/14.
//  Copyright (c) 2014 nicole. All rights reserved.
//

#import "AnimatedImageView.h"

@interface AnimatedImageView() <UIGestureRecognizerDelegate>
@property (nonatomic) BOOL animated;
@property (nonatomic) CGPoint priorPoint;
@property (nonatomic) BOOL imageSelected;
@property (strong, nonatomic) NSMutableArray *activeRecognizers;

// Gestures
@property (strong, nonatomic) UIPanGestureRecognizer *pan;
@property (strong, nonatomic) UIPinchGestureRecognizer *pinch;
@property (strong, nonatomic) UIRotationGestureRecognizer *rotate;
@property (nonatomic) CGFloat lastScale;
@end

@implementation AnimatedImageView

#pragma mark - Initialization

- (NSMutableArray *)activeRecognizers {
    if (!_activeRecognizers) _activeRecognizers = [[NSMutableArray alloc] init];
    return _activeRecognizers;
}

#pragma mark - Animation

- (void)animate {
    self.animated = !self.animated;
    if (self.animated) {
        [self startAnimating];
    }
    else {
        [self stopAnimating];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setUp];
    }
    return self;
}

- (void)setUp {
    
    // Load images
    NSArray *imageNames = [self animatedImageNames];
    
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (int i = 0; i < imageNames.count; i += 1) {
        [images addObject:[UIImage imageNamed:[imageNames objectAtIndex:i]]];
    }
    
    self.animationImages = images;
    self.animationDuration = 1.0;
    
    self.image = [UIImage imageNamed:@"win_1.png"];
}

- (void)selectAnimatedImage:(UITapGestureRecognizer *)gesture {

    if (gesture.state == UIGestureRecognizerStateEnded) {
        self.imageSelected = !self.imageSelected;
        
        // If image is not selected, add a green background and a pan gesture
        if (self.imageSelected) {
            self.backgroundColor = [UIColor colorWithRed:0 / 255.0 green:166 / 255.0 blue:80 / 255.0 alpha:0.5];
            
            // Add a pan gesture recognizer
            self.pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveAnimatedImage:)];
            [self addGestureRecognizer:self.pan];
            
            // Add a rotate gesture to the rotation bounds
            self.rotate = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
            [self addGestureRecognizer:self.rotate];
            self.rotate.delegate = self;
            
            // Add a pinch gesture
            self.pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
            [self addGestureRecognizer:self.pinch];
            self.pinch.delegate = self; // KEEP, allows two gestures at once
        }
        
        // If image is already selected, remove green background and pan gesture
        else {
            self.backgroundColor = [UIColor clearColor];
            [self removeGestureRecognizer:self.pan];
            [self removeGestureRecognizer:self.rotate];
            [self removeGestureRecognizer:self.pinch];
        }
        
        // Bring selected view to the front of all other views
        [gesture.view.superview bringSubviewToFront:gesture.view];
    }
}

#pragma mark - Pan Gesture

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]
        || [gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        return NO;
    }
    
    return YES;
}

- (void)moveAnimatedImage:(UIPanGestureRecognizer *)gesture {

    CGPoint movement;

    if (gesture.state == UIGestureRecognizerStateBegan
        || gesture.state == UIGestureRecognizerStateChanged
        || gesture.state == UIGestureRecognizerStateEnded) {

        // Get the view that the user clicked on
        UIView *singleView = gesture.view;
        CGRect rec = singleView.frame;

        // Bounds of the animated image superview
        UIView *bounceBounds = gesture.view.superview;
        CGRect animatedImageBounds = bounceBounds.bounds;
        
        // Make sure card does not go out of bounds
        if ((rec.origin.x >= animatedImageBounds.origin.x)
            && (rec.origin.x + rec.size.width <= animatedImageBounds.origin.x + animatedImageBounds.size.width)) {
            
            CGPoint translation = [gesture translationInView:bounceBounds];
            movement = translation;
            
            gesture.view.center = CGPointMake(gesture.view.center.x + translation.x,
                                              gesture.view.center.y + translation.y);
            rec = gesture.view.frame;
            
            // Right bounds
            if (singleView.frame.origin.x <= bounceBounds.bounds.origin.x) {
                rec.origin.x = singleView.bounds.origin.x;
            }
            
            // Left bounds
            else if ((singleView.frame.origin.x + singleView.frame.size.width) >
                     (bounceBounds.bounds.origin.x + bounceBounds.bounds.size.width)) {
                rec.origin.x = bounceBounds.bounds.origin.x + bounceBounds.bounds.size.width - singleView.frame.size.width;
            }
            
            // Top bounds
            if (singleView.frame.origin.y < bounceBounds.bounds.origin.y) {
                rec.origin.y = singleView.bounds.origin.y;
            }
            
            // Bottom bounds
            else if ((singleView.frame.origin.y + singleView.frame.size.height) >
                     (bounceBounds.bounds.origin.y + bounceBounds.bounds.size.height)) {
                rec.origin.y = bounceBounds.bounds.origin.y + bounceBounds.bounds.size.height - singleView.frame.size.height;
            }
            
            // Update the frame
            gesture.view.frame = rec;
            
            // Reset translation (IMPORTANT!)
            [gesture setTranslation:CGPointZero inView:bounceBounds];
        }
    }
}

#pragma mark - Pinch and Rotate Gesture

- (void)handleGesture:(UIGestureRecognizer *)gesture {
    
    UIView *currentView = gesture.view;
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [self.activeRecognizers addObject:gesture];
        
        if ([gesture respondsToSelector:@selector(scale)]) {
            CGFloat scale = [(UIPinchGestureRecognizer *)gesture scale];
            self.lastScale = scale;
        }
    }
    
    if (gesture.state == UIGestureRecognizerStateChanged) {
        CGAffineTransform transform = currentView.transform;
        for (UIGestureRecognizer *recognizer in self.activeRecognizers) {
            transform = [self applyRecognizer:recognizer toTransform:transform];
        }
        currentView.transform = transform;
        
        [self resetRecognizer:gesture];
    }
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        [self.activeRecognizers removeObject:gesture];
    }
}

- (CGAffineTransform)applyRecognizer:(UIGestureRecognizer *)recognizer toTransform:(CGAffineTransform)transform {
    if ([recognizer respondsToSelector:@selector(rotation)]) {
        return CGAffineTransformRotate(transform, [(UIRotationGestureRecognizer *)recognizer rotation]);
    }
    
    else if ([recognizer respondsToSelector:@selector(scale)]) {
        CGFloat scale = [(UIPinchGestureRecognizer *)recognizer scale];
        CGFloat currentScale = [[[recognizer view].layer valueForKeyPath:@"transform.scale"] floatValue];
        NSLog(@"scale is: %f", currentScale);

        const CGFloat kMaxScale = 1.9;
        const CGFloat kMinScale = 1.0;

        CGFloat newScale = 1 - (self.lastScale - scale);
        newScale = MIN(newScale, kMaxScale / currentScale);
        newScale = MAX(newScale, kMinScale / currentScale);
        CGAffineTransform newTransform = CGAffineTransformScale(transform, newScale, newScale);
        
        self.lastScale = newScale;
        
        return newTransform;
        
//        if (scale > MIN_SCALE) {
//            return CGAffineTransformScale(transform, scale, scale);
//        }
//        if (scale < MAX_SCALE) {
//            return CGAffineTransformScale(transform, scale, scale);
//        }
    }
    
    return transform;
}

- (void)resetRecognizer:(UIGestureRecognizer *)recognizer {
    if ([recognizer respondsToSelector:@selector(rotation)]) {
        UIRotationGestureRecognizer *rotate = (UIRotationGestureRecognizer *)recognizer;
        rotate.rotation = 0;
    }
    else if ([recognizer respondsToSelector:@selector(scale)]) {
        UIPinchGestureRecognizer *pinch = (UIPinchGestureRecognizer *)recognizer;
        pinch.scale = 1.0;
    }
}

#pragma mark - Image Names
- (NSArray *)animatedImageNames {
    return nil; // Abstract
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
