//
//  DrawingBoardView.m
//  GigilFaces
//
//  Created by Nicole on 8/22/14.
//  Copyright (c) 2014 nicole. All rights reserved.
//

#import "DrawingBoardView.h"
#import "SmoothPaintingBrushBezier.h"
#import "VariedWidthsPaintingBrushBezier.h"
#import "VineLineBezierPath.h"
#import "FaceAnimationsPopOverVC.h"
#import "AnimatedImageView.h"
#import "AnimateGS.h"

@interface DrawingBoardView()
@property (nonatomic) UIColor *paperColor;
@property (strong, nonatomic) UIBezierPath *currentBrushStroke;
@property (strong, nonatomic) UIImage *incrementalImage;

// Pen brush
@property (nonatomic) float inkSupply;
@property (strong, nonatomic) NSMutableArray *multipleBristles; // Of UIBezier
@property (strong, nonatomic) NSMutableArray *multipleBristlesInkSupply; // Of NSNumber
@property (strong, nonatomic) NSMutableArray *multipleBristlesDistance; // Of CGPoint
@property (nonatomic) int brushOpacityCounter;

// Vine brush
@property (strong, nonatomic) NSMutableArray *vineLines;

// Animated Images
@property (strong, nonatomic) NSMutableArray *animatedImages; // Of UIImageView

@end

@implementation DrawingBoardView

#pragma mark - Initialization

- (NSMutableArray *)animatedImages {
    if (!_animatedImages) _animatedImages = [[NSMutableArray alloc] init];
    return _animatedImages;
}

- (NSMutableArray *)vineLines {
    if (!_vineLines ) _vineLines = [[NSMutableArray alloc] init];
    return _vineLines;
}

- (NSMutableArray *)multipleBristlesInkSupply {
    if (!_multipleBristlesInkSupply) _multipleBristlesInkSupply = [[NSMutableArray alloc] init];
    return _multipleBristlesInkSupply;
}

- (NSMutableArray *)multipleBristlesDistance {
    if (!_multipleBristlesDistance) _multipleBristlesDistance = [[NSMutableArray alloc] init];
    return _multipleBristlesDistance;
}

- (NSMutableArray *)multipleBristles {
    if (!_multipleBristles) _multipleBristles = [[NSMutableArray alloc] init];
    return _multipleBristles;
}

- (void)setClearCanvas:(BOOL)clearCanvas {
    _clearCanvas = clearCanvas;
    [self setNeedsDisplay];
}

#pragma mark - Gestures

- (void)paint:(UIPanGestureRecognizer *)gesture {
    
    /* Create a brush to draw a line */
    if (gesture.state == UIGestureRecognizerStateBegan) {
        if (self.brushSelected == -1) { return; }
        if (self.brushSelected == 0) { [self initalizeDrawMarker:gesture]; }
        if (self.brushSelected == 1) { [self initalizeDrawCrayon:gesture]; }
        if (self.brushSelected == 2) { [self initalizeDrawPen:gesture]; }
        if (self.brushSelected == 3) { [self initalizeDrawEraser:gesture]; }
        if (self.brushSelected == 4) { [self initalizeDrawVineBrush:gesture]; }
    }
    
    /* Draw line */
    else if (gesture.state == UIGestureRecognizerStateChanged) {
        if (self.brushSelected == -1) { return; }
        if (self.brushSelected == 0) { [self drawMarker:gesture]; }
        if (self.brushSelected == 1) { [self drawCrayon:gesture]; }
        if (self.brushSelected == 2) { [self drawPen:gesture]; }
        if (self.brushSelected == 3) { [self drawEraser:gesture]; }
        if (self.brushSelected == 4) { [self drawVineBrush:gesture]; }
        
        [self setNeedsDisplay];
    }
    
    /* Stop drawing line */
    else if (gesture.state == UIGestureRecognizerStateEnded) {
        if (self.brushSelected == -1) { return; }
        if (self.brushSelected == 0) { [self endDrawMarker]; }
        if (self.brushSelected == 1) { [self endDrawCrayon]; }
        if (self.brushSelected == 2) { [self endDrawPen:gesture]; }
        if (self.brushSelected == 3) { [self endDrawEraser]; }
        if (self.brushSelected == 4) { [self endDrawVineBrush]; }
        
        [self setNeedsDisplay];
    }
}

#pragma mark - Marker

- (void)initalizeDrawMarker:(UIPanGestureRecognizer *)gesture {
    SmoothPaintingBrushBezier *smoothBrush = [[SmoothPaintingBrushBezier alloc] init];
    smoothBrush.lineWidth = self.brushSize;
    smoothBrush.lineJoinStyle = kCGLineJoinRound;
    smoothBrush.lineCapStyle = kCGLineCapRound;
    [smoothBrush addFirstPoint:[gesture locationInView:self]];
    
    // Set the current brush to smooth brush
    self.currentBrushStroke = smoothBrush;
}

- (void)drawMarker:(UIPanGestureRecognizer *)gesture {
    SmoothPaintingBrushBezier *bs = (SmoothPaintingBrushBezier *)self.currentBrushStroke;
    [bs addLineToPoint:[gesture locationInView:self]];
}

- (void)endDrawMarker {
    SmoothPaintingBrushBezier *currentBrushStroke = (SmoothPaintingBrushBezier *)self.currentBrushStroke;
    [currentBrushStroke setCounter:0];
    [self drawBitmap];
    [self.currentBrushStroke removeAllPoints];
}

#pragma mark - Crayon

- (void)initalizeDrawCrayon:(UIPanGestureRecognizer *)gesture {
    SmoothPaintingBrushBezier *smoothBrush = [[SmoothPaintingBrushBezier alloc] init];
    smoothBrush.lineWidth = self.brushSize;
    smoothBrush.lineJoinStyle = kCGLineJoinRound;
    smoothBrush.lineCapStyle = kCGLineCapRound;
    [smoothBrush addFirstPoint:[gesture locationInView:self]];
    
    // Set the current brush to smooth brush
    self.currentBrushStroke = smoothBrush;
}

- (void)drawCrayon:(UIPanGestureRecognizer *)gesture {
    SmoothPaintingBrushBezier *bs = (SmoothPaintingBrushBezier *)self.currentBrushStroke;
    [bs addLineToPoint:[gesture locationInView:self]];
}

- (void)endDrawCrayon {
    SmoothPaintingBrushBezier *bs = (SmoothPaintingBrushBezier *)self.currentBrushStroke;
    [bs setCounter:0];
    [self drawBitmap];
    [self.currentBrushStroke removeAllPoints];
}

#pragma mark - Pen

- (void)initalizeDrawPen:(UIPanGestureRecognizer *)gesture {
    self.inkSupply = 0;
    int half = (int)(self.brushSize / 3);
    float opacityGradient = 1 / (self.brushSize);
    
    for (int i = 0; i < (int)(self.brushSize); i += 1) {
        VariedWidthsPaintingBrushBezier *path = [[VariedWidthsPaintingBrushBezier alloc] init];
        
        // Size of bristle
        int bristleSize = arc4random_uniform(40) + 20;
        if (i == 0) {
            bristleSize = 100;
        }
        if (i == (int)(self.brushSize)) {
            bristleSize = 100;
        }
        path.lineWidth = bristleSize;
        
        // Location of bristle
        if (i < half) {
            self.inkSupply += opacityGradient;
        }
        else if (i == half) {
            //self.inkSupply = .1;
        }
        else {
            self.inkSupply -= opacityGradient;
        }
        [self.multipleBristlesInkSupply addObject:[NSNumber numberWithFloat:self.inkSupply]];
        
        CGPoint adjustedLocation = CGPointMake([gesture locationInView:self].x + 1, [gesture locationInView:self].y);
        [path addFirstPoint:adjustedLocation];
        
        [self.multipleBristles addObject:path];
        [self.multipleBristlesDistance addObject:[NSValue valueWithCGPoint:adjustedLocation]];
    }
}

- (void)drawPen:(UIPanGestureRecognizer *)gesture {
    int count = 0;
    for (UIBezierPath *path in self.multipleBristles) {
        VariedWidthsPaintingBrushBezier *currentBrush = (VariedWidthsPaintingBrushBezier *)path;
        float randomNumber = arc4random_uniform(2) + .001;
        CGPoint adjustedLocation = CGPointMake([gesture locationInView:self].x + randomNumber, [gesture locationInView:self].y);
        [currentBrush addPoint:adjustedLocation];
        count += 1;
        
        int bristleSize = arc4random_uniform(40) + 20;
        if (count == 0) {
            bristleSize = 100;
        }
        if (count == [self.multipleBristles count]) {
            bristleSize = 100;
        }
        path.lineWidth = bristleSize;
        
    }
    
    [self drawBitmap];
}

- (void)endDrawPen:(UIPanGestureRecognizer *)gesture{
    [self drawBitmap];
    [self.multipleBristles removeAllObjects];
    [self.multipleBristlesDistance removeAllObjects];
    [self.multipleBristlesInkSupply removeAllObjects];
}

#pragma mark - Eraser

- (void)initalizeDrawEraser:(UIPanGestureRecognizer *)gesture {
    SmoothPaintingBrushBezier *smoothBrush = [[SmoothPaintingBrushBezier alloc] init];
    smoothBrush.lineWidth = self.brushSize;
    smoothBrush.lineJoinStyle = kCGLineJoinRound;
    smoothBrush.lineCapStyle = kCGLineCapRound;
    [smoothBrush addFirstPoint:[gesture locationInView:self]];
    
    // Set the current brush to smooth brush
    self.currentBrushStroke = smoothBrush;
}

- (void)drawEraser:(UIPanGestureRecognizer *)gesture {
    SmoothPaintingBrushBezier *bs = (SmoothPaintingBrushBezier *)self.currentBrushStroke;
    [bs addLineToPoint:[gesture locationInView:self]];
}

- (void)endDrawEraser {
    SmoothPaintingBrushBezier *bs = (SmoothPaintingBrushBezier *)self.currentBrushStroke;
    [bs setCounter:0];
    [self drawBitmap];
    [self.currentBrushStroke removeAllPoints];
}

#pragma mark - VineBrush

- (void)initalizeDrawVineBrush:(UIPanGestureRecognizer *)gesture {
    VineLineBezierPath *newVineLine = [[VineLineBezierPath alloc] init];
    newVineLine.lineCapStyle = kCGLineJoinRound;
    newVineLine.delegate = self;
    newVineLine.lineWidth = self.brushSize;
    newVineLine.minBranchSeperation = 100.0;
    newVineLine.maxBranchLength = 100.0;
    newVineLine.leafSize = 30.0;
    [newVineLine addFirstPoint:[gesture locationInView:self]];
    //[self.vineLines addObject:newVineLine];
    
    self.currentBrushStroke = newVineLine;
}

- (void)drawVineBrush:(UIPanGestureRecognizer *)gesture {
    VineLineBezierPath *currentLine = (VineLineBezierPath *)self.currentBrushStroke;
    [currentLine addLineToPoint:[gesture locationInView:self]];
}

- (void)endDrawVineBrush {
    [self drawBitmap];
    [self.currentBrushStroke removeAllPoints];
}

#pragma mark - Drawing

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    // Round the corners of the view
    UIBezierPath *roundedCorners = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:20.0];
    [roundedCorners addClip];
    self.clipsToBounds = YES;
    
    // Set the background color of the view
    [self.paperColor setFill];
    [roundedCorners fill];
        
    // Draw the strokes
    if (!self.clearCanvas) {
        
        // Set the color of the paint
        [self colorBrushPath];
        [self.brushColor setFill];
        
        // Draw the previous strokes (saved in image)
        [self.incrementalImage drawInRect:rect];
        
        // If brush is a pen only draw the UIImage
        if (self.brushSelected == 2) {
            [self.incrementalImage drawInRect:rect];
        }

        // All other brushes, draw last stroke
        else {
            // Draw the current stroke
            UIBezierPath *lastStroke = self.currentBrushStroke;
            [self strokeBrushPath:lastStroke];
        }
    }
    
    // If the user clicked the clear button, clear the canvas of all brushstrokes
    else {
        [self.currentBrushStroke removeAllPoints];
        self.incrementalImage = nil;
        
        // Remove animated vine strokes from canvas
       [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
        
        // Remove animated images
//        for(UIView *subview in [self subviews]) {
//            [subview removeFromSuperview];
//        }
        
        // Set clear canvas back to no
        self.clearCanvas = NO;
    }
}

/*  Draw the UIImage, which has all the previous strokes */
- (void)drawBitmap {
    
    // Create the UIImage
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 0.0);
    
    // Set color of the paint (will change to black if you don't do this)
    [self colorBrushPath];

    // Set background color of image (background will change to black if you don't do this)
    if (!self.incrementalImage) {
        UIBezierPath *rectPath = [UIBezierPath bezierPathWithRect:self.bounds];
        [[UIColor whiteColor] setFill];
        [rectPath fill];
    }
    
    // Draw the UIImage
    [self.incrementalImage drawAtPoint:CGPointZero];

    // Draw multiple strokes for the pen brush
    if (self.brushSelected == 2) {
        for (UIBezierPath *path in self.multipleBristles) {
            [self.brushColor setFill];
            [self fillBrushPath:path];
        }
    }
    
    // Draw 1 stroke for the rest of the brushes
    else {
        // Draw the stroke
        [self strokeBrushPath:self.currentBrushStroke];
    }
    
    // Continue drawing the UIImage
    self.incrementalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

/*  Set the color of the stroke */
- (void)colorBrushPath {
    
    // Eraser is white color
    if (self.brushSelected == 3) {
        [[UIColor whiteColor] setStroke];
    }
    
    // Set color for paint brush
    else {
        [self.brushColor setStroke];
    }
}

/*  Draw the stroke */
- (void)strokeBrushPath:(UIBezierPath *)stroke {
    
    if (self.brushSelected == 0) {
        [stroke strokeWithBlendMode:kCGBlendModeMultiply alpha:self.brushOpacity];
    }
    else if (self.brushSelected == 1) {
        [stroke strokeWithBlendMode:kCGBlendModeNormal alpha:self.brushOpacity];
    }
    else if (self.brushSelected == 2) {
        [stroke strokeWithBlendMode:kCGBlendModeNormal alpha:self.brushOpacity];
    }
    else if (self.brushSelected == 3) {
        [stroke strokeWithBlendMode:kCGBlendModeNormal alpha:1.0];
    }
    else if (self.brushSelected == 4) {
        [stroke strokeWithBlendMode:kCGBlendModeNormal alpha:self.brushOpacity];
    }
}

- (void)fillBrushPath:(UIBezierPath *)fill {

    if (self.brushOpacityCounter >= [self.multipleBristles count]) {
        self.brushOpacityCounter = 0;
    }
    [fill fillWithBlendMode:kCGBlendModeNormal alpha:[[self.multipleBristlesInkSupply objectAtIndex:self.brushOpacityCounter] floatValue]];
    self.brushOpacityCounter += 1;
}

/*  App delegete method for VineBranchBezierPath */
- (void)vineLineDidCreateBranch:(VineBranchBezierPath *)branchPath {
    CAShapeLayer *branchShape = [CAShapeLayer layer];
    branchShape.path = branchPath.CGPath;
    branchShape.fillColor = [UIColor clearColor].CGColor;
    branchShape.strokeColor = self.brushColor.CGColor;
    branchShape.opacity = self.brushOpacity;
    branchShape.lineWidth = branchPath.lineWidth;
    
    [self.layer addSublayer:branchShape];
    
    CABasicAnimation *branchGrowAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    branchGrowAnimation.duration = 1.0;
    branchGrowAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    branchGrowAnimation.toValue = [NSNumber numberWithFloat:1.0];
    [branchShape addAnimation:branchGrowAnimation forKey:@"strokeEnd"];
}

#pragma mark - Animated Illustrations

- (void)addFaceAnimation:(int)tag category:(int)category {
    
    // Create a random position for the view on the drawing board
    float randomX = arc4random_uniform(self.frame.size.width - 86) + (5);
    float randomY = arc4random_uniform(self.frame.size.height - 193) + (5);
    AnimatedImageView *test = [[AnimateGS alloc] initWithFrame:CGRectMake(randomX, randomY, 86, 193)];
    
    // Add a tap gesture to the view
    test.userInteractionEnabled = YES; // Important, lets image view recognize tap
    [test addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:test action:@selector(selectAnimatedImage:)]];
    
    // Add image to the drawing board view
    [self addSubview:test];
    
    // Add animated image to an array
    [self.animatedImages addObject:test];
}

- (void)playAnimationButtonClicked {
    
    // Animate all the images that have been added to the view
    for (AnimatedImageView *image in self.animatedImages) {
        [image animate];
    }
}

- (void)clearAnimatedArray {
    
    // Remove all the subviews from the animated array (Don't do in drawRect, will cause crash)
    for (UIView *subview in [self subviews]) {
        [subview removeFromSuperview];
    }
    
    // Remove all animated images from the array
    [self.animatedImages removeAllObjects];
}

#pragma mark - Setup

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    [self setUp];
}

/*  Setup the view when it first appears */
- (void)setUp {
    
    // Set the background color of the view to transparent
    self.backgroundColor = nil;
    self.opaque = NO;
    
    // Add a pan gesture to the view
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(paint:)];
    [self addGestureRecognizer:pan];
    
    // Initialize settings
    self.brushSelected = 0;
    self.brushSize = 40.0;
    self.brushOpacity = 1.0;
    UIColor *violet = [UIColor colorWithRed:102 / 255.0 green:44 / 255.0 blue:144 / 255.0 alpha:1.0];
    self.brushColor = violet;
    self.clearCanvas = NO;
    self.paperColor = [UIColor whiteColor];
}

@end
