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
#import "FillPaintingBrushBezier.h"
#import "FaceAnimationsPopOverVC.h"
#import "AnimatedImageView.h"
#import "AnimateGS.h"
#import "RollingEyeView.h"
#import "ToothyGrinView.h"
#import "SaveDrawingBoard.h"
#import "MyDrawingsVC.h"

@interface DrawingBoardView()
@property (nonatomic) UIColor *paperColor;
@property (strong, nonatomic) UIBezierPath *currentBrushStroke;
@property (strong, nonatomic) UIBezierPath *fillBrushStroke;
@property (nonatomic) int totalNumberOfIncrementalImages;


// Pen brush
@property (nonatomic) float inkSupply;
@property (strong, nonatomic) NSMutableArray *multipleBristles; // Of UIBezier
@property (strong, nonatomic) NSMutableArray *multipleBristlesInkSupply; // Of NSNumber
@property (strong, nonatomic) NSMutableArray *multipleBristlesDistance; // Of CGPoint
@property (nonatomic) int brushOpacityCounter;

// Vine brush
@property (strong, nonatomic) NSMutableArray *vineLines;
@property (nonatomic) BOOL fillBezierPath;

// Animated Images
@property (strong, nonatomic) NSMutableArray *animatedImages; // Of UIImageView
@property (strong, nonatomic) NSMutableArray *animatedImagesFrame; // Of CGRect
@property (nonatomic) BOOL animated;

// Undo Mistakes
@property (strong, nonatomic) NSMutableArray *undoMistakes; // Of UIImage
@property (nonatomic) BOOL erasing;

// Redo Mistakes
@property (strong, nonatomic) NSMutableArray *redoMistakes; // Of UIImage
@property (nonatomic) BOOL redo;

// Save Image
@property (strong, nonatomic) NSArray *savedImages;
@property (strong, nonatomic) SaveDrawingBoard *saveDrawingBoard;
@property (nonatomic, retain) NSString *dataFilePath;

@end

@implementation DrawingBoardView {
    dispatch_queue_t saveDataQueue;
}

#pragma mark - Initialization

- (NSString *)drawingTitle {
    if (!_drawingTitle) _drawingTitle = [NSString stringWithFormat:@"Untitled"];
    return _drawingTitle;
}

- (SaveDrawingBoard *)saveDrawingBoard {
    if (!_saveDrawingBoard) _saveDrawingBoard = [[SaveDrawingBoard alloc] init];
    return _saveDrawingBoard;
}

- (NSMutableArray *)redoMistakes {
    if (!_redoMistakes) _redoMistakes = [[NSMutableArray alloc] init];
    return _redoMistakes;
}

- (NSMutableArray *)undoMistakes {
    if (!_undoMistakes) _undoMistakes = [[NSMutableArray alloc] init];
    return _undoMistakes;
}

- (NSMutableArray *)animatedImages {
    if (!_animatedImages) _animatedImages = [[NSMutableArray alloc] init];
    return _animatedImages;
}

- (NSMutableArray *)animatedImagesFrame {
    if (!_animatedImagesFrame) _animatedImagesFrame = [[NSMutableArray alloc] init];
    return _animatedImagesFrame;
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

/* If the index is set, get the old drawing for the view */
- (void)setSavedDataIndex:(int)savedDataIndex {
    _savedDataIndex = savedDataIndex;
    [self getSavedData];
}

#pragma mark - Gestures

- (void)tapAnimatedView:(UITapGestureRecognizer *)gesture {
    
    // Call the tap method in AnimatedImageView class
    AnimatedImageView *image = (AnimatedImageView *)gesture.view;
    [image selectAnimatedImage:gesture];
    
    // If user clicked on the remove button, remove the face animation view from the drawing board
    BOOL cancel = [image cancelButtonClicked:[gesture locationInView:image]];
    if (cancel) {
        
        // Remove the animation from the array of all animations on the drawing board
        for (int i = 0; i < [self.animatedImages count]; i += 1) {
            if ([image isEqual:[self.animatedImages objectAtIndex:i]]) {
                [self.animatedImages removeObjectAtIndex:i];
            }
        }
                
        // Remove the image from the drawing board
        [image removeFromSuperview];
    }
}

- (void)paintDot:(UITapGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateEnded) {
        
        if (self.brushSelected != -1) {

            // If the brush selected is a pen, temporarily make it a marker
            // Because a pen is filled, not stroked
            int saveCurrentBrushStroke = self.brushSelected;
            if (self.brushSelected == 2) {
                self.brushSelected = 1;
            }
            
            // Draw the point
            UIBezierPath *tapBrush = [[UIBezierPath alloc] init];
            tapBrush.lineWidth = self.brushSize;
            //tapBrush.lineJoinStyle = kCGLineJoinRound;
            tapBrush.lineCapStyle = kCGLineCapRound;
            
            // Draw line between same points (will give circle)
            [tapBrush moveToPoint:[gesture locationInView:self]];
            [tapBrush addLineToPoint:[gesture locationInView:self]];
            
            // Draw the stroke
            self.currentBrushStroke = tapBrush;
            
            [self drawBitmap];
            [self setNeedsDisplay];
            [self.currentBrushStroke removeAllPoints];
            
            // Save past versions of the uiimage made of brush strokes on the canvas
            [self savePastPaintingMarks];
            
            // Change the brush back to its orginal state (if it was changed)
            self.brushSelected = saveCurrentBrushStroke;
        }
    }
}

- (void)paint:(UIPanGestureRecognizer *)gesture {
    
    /* Create a brush to draw a line */
    if (gesture.state == UIGestureRecognizerStateBegan) {
        if (self.brushSelected == -1) { return; }
        if (self.brushSelected == 0) { [self initalizeDrawMarker:gesture]; }
        if (self.brushSelected == 1) { [self initalizeDrawCrayon:gesture]; }
        if (self.brushSelected == 2) { [self initalizeDrawPen:gesture]; }
        if (self.brushSelected == 3) { [self initalizeDrawEraser:gesture]; }
        if (self.brushSelected == 4) { [self initalizeFillBrush:gesture]; }
    }
    
    /* Draw line */
    else if (gesture.state == UIGestureRecognizerStateChanged) {
        if (self.brushSelected == -1) { return; }
        if (self.brushSelected == 0) { [self drawMarker:gesture]; }
        if (self.brushSelected == 1) { [self drawCrayon:gesture]; }
        if (self.brushSelected == 2) { [self drawPen:gesture]; }
        if (self.brushSelected == 3) { [self drawEraser:gesture]; }
        if (self.brushSelected == 4) { [self drawFillBrush:gesture]; }
        
        [self setNeedsDisplay];
    }
    
    /* Stop drawing line */
    else if (gesture.state == UIGestureRecognizerStateEnded) {
        if (self.brushSelected == -1) { return; }
        if (self.brushSelected == 0) { [self endDrawMarker]; }
        if (self.brushSelected == 1) { [self endDrawCrayon]; }
        if (self.brushSelected == 2) { [self endDrawPen:gesture]; }
        if (self.brushSelected == 3) { [self endDrawEraser]; }
        if (self.brushSelected == 4) { [self endDrawFillBrush]; }
        
        [self setNeedsDisplay];
        
        // Save past versions of the uiimage made of brush strokes on the canvas
        [self savePastPaintingMarks];
    }
}

- (void)savePastPaintingMarks {
    
    // Add the incremental image to an undo list
    if ([self.undoMistakes count] <= 8) {
        [self.undoMistakes addObject:self.incrementalImage];
    }
    else if ([self.undoMistakes count] > 8) {
        [self.undoMistakes removeObjectAtIndex:0];
        [self.undoMistakes addObject:self.incrementalImage];
    }
    
    // Count the total number of times a person draws something
    self.totalNumberOfIncrementalImages += 1;
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
    [self drawBitmap];
    [self.currentBrushStroke removeAllPoints];
}

#pragma mark - Pen

- (void)initalizeDrawPen:(UIPanGestureRecognizer *)gesture {
    
    // The amout of ink each bristle holds
    self.inkSupply = 0;
    
    // Half of the bristles in the brush
    int halfOfBrush = 3.0; //(int)(4.0 / 3);
    
    // Opacity for the first bristle in the brush
    float opacityGradient = 0.25; //1 / (4.0);
    
    // Create each bristle in the brush
    for (int i = 0; i < (2 * halfOfBrush); i += 1) {
        
        // Create a new bristle
        VariedWidthsPaintingBrushBezier *path = [[VariedWidthsPaintingBrushBezier alloc] init];
        
        // Size of bristle
        int bristleSize = arc4random_uniform(40) + 20;
        if (i == 0) {
            bristleSize = 100;
        }
        if (i == (2 * halfOfBrush)) {
            bristleSize = 100;
        }
        path.lineWidth = bristleSize;
        
        // Location of bristle
        if (i < halfOfBrush) {
            self.inkSupply += opacityGradient;
        }
        else if (i == halfOfBrush) {
            self.inkSupply = opacityGradient;
        }
        else if (i > halfOfBrush) {
            self.inkSupply -= opacityGradient;
        }
        [self.multipleBristlesInkSupply addObject:[NSNumber numberWithFloat:self.inkSupply]];
        
        // Location of the bristle
        CGPoint adjustedLocation = CGPointMake([gesture locationInView:self].x + 1, [gesture locationInView:self].y);
        [path addFirstPoint:adjustedLocation];
        [self.multipleBristlesDistance addObject:[NSValue valueWithCGPoint:adjustedLocation]];

        // Add the bristle to an array
        [self.multipleBristles addObject:path];
    }
}

- (void)drawPen:(UIPanGestureRecognizer *)gesture {
    
    int count = 0;
    
    // Draw each line generated by a bristle
    for (UIBezierPath *path in self.multipleBristles) {
        
        // Get the bristle generated in initalizeDrawPen
        VariedWidthsPaintingBrushBezier *currentBrush = (VariedWidthsPaintingBrushBezier *)path;
       
        // Create a new location for the bristle
        float randomNumber = arc4random_uniform(2) + .001;
        CGPoint adjustedLocation = CGPointMake([gesture locationInView:self].x + randomNumber, [gesture locationInView:self].y);
        [currentBrush addPoint:adjustedLocation];
        count += 1;
        
        // Create a new bristle size for the brush
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
    
    int count = 0;
    // Draw each line generated by a bristle
    for (UIBezierPath *path in self.multipleBristles) {
        
        // Get the bristle generated in initalizeDrawPen
        VariedWidthsPaintingBrushBezier *currentBrush = (VariedWidthsPaintingBrushBezier *)path;
        [currentBrush addLastPoint:[gesture locationInView:self]];
        
        int bristleSize = 100;
        path.lineWidth = bristleSize;
        
        count += 1;

    }
    
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
    [self drawBitmap];
    [self.currentBrushStroke removeAllPoints];
}

#pragma mark - Fill Brush

- (void)initalizeFillBrush:(UIPanGestureRecognizer *)gesture {
    
    FillPaintingBrushBezier *smoothBrush = [[FillPaintingBrushBezier alloc] init];
    smoothBrush.lineWidth = 2.0;
    smoothBrush.lineJoinStyle = kCGLineJoinRound;
    smoothBrush.lineCapStyle = kCGLineCapRound;
    [smoothBrush addFirstPoint:[gesture locationInView:self]];

    // Set the current brush to smooth brush
    self.currentBrushStroke = smoothBrush;
    
    FillPaintingBrushBezier *fillBrush = [[FillPaintingBrushBezier alloc] init];
    fillBrush.lineWidth = 2 * self.brushSize;
    fillBrush.lineJoinStyle = kCGLineJoinRound;
    fillBrush.lineCapStyle = kCGLineCapRound;
    [fillBrush addFirstPoint:[gesture locationInView:self]];
    
    // Set the fill brush
    self.fillBrushStroke = fillBrush;
}

- (void)drawFillBrush:(UIPanGestureRecognizer *)gesture {
    FillPaintingBrushBezier *bs = (FillPaintingBrushBezier *)self.currentBrushStroke;
    [bs addNextPoint:[gesture locationInView:self]];
    
    FillPaintingBrushBezier *fb = (FillPaintingBrushBezier *)self.fillBrushStroke;
    [fb addNextPoint:[gesture locationInView:self]];
}

- (void)endDrawFillBrush {
    FillPaintingBrushBezier *bs = (FillPaintingBrushBezier *)self.currentBrushStroke;
    [bs closePath];
    [self.currentBrushStroke removeAllPoints];
    
    FillPaintingBrushBezier *fb = (FillPaintingBrushBezier *)self.fillBrushStroke;
    [fb closePath];
    
    self.fillBezierPath = true;
    [self drawBitmap];
    
    [self.currentBrushStroke removeAllPoints];
    self.fillBrushStroke = nil;
}

#pragma mark - VineBrush

//- (void)initalizeDrawVineBrush:(UIPanGestureRecognizer *)gesture {
//    VineLineBezierPath *newVineLine = [[VineLineBezierPath alloc] init];
//    newVineLine.lineCapStyle = kCGLineJoinRound;
//    newVineLine.delegate = self;
//    newVineLine.lineWidth = self.brushSize;
//    newVineLine.minBranchSeperation = 100.0;
//    newVineLine.maxBranchLength = 100.0;
//    newVineLine.leafSize = 30.0;
//    [newVineLine addFirstPoint:[gesture locationInView:self]];
//    //[self.vineLines addObject:newVineLine];
//    
//    self.currentBrushStroke = newVineLine;
//}
//
//- (void)drawVineBrush:(UIPanGestureRecognizer *)gesture {
//    VineLineBezierPath *currentLine = (VineLineBezierPath *)self.currentBrushStroke;
//    [currentLine addLineToPoint:[gesture locationInView:self]];
//    self.fillBezierPath = true;
//}
//
//- (void)endDrawVineBrush {
//    VineLineBezierPath *currentLine = (VineLineBezierPath *)self.currentBrushStroke;
//    [currentLine closePath];
//    self.fillBezierPath = true;
//    
//    [self drawBitmap];
//    [self.currentBrushStroke removeAllPoints];
//}
//
///*  App delegete method for VineBranchBezierPath */
//- (void)vineLineDidCreateBranch:(VineBranchBezierPath *)branchPath {
//    CAShapeLayer *branchShape = [CAShapeLayer layer];
//    branchShape.path = branchPath.CGPath;
//    branchShape.fillColor = [UIColor clearColor].CGColor;
//    branchShape.strokeColor = self.brushColor.CGColor;
//    branchShape.opacity = self.brushOpacity;
//    branchShape.lineWidth = branchPath.lineWidth;
//    
//    [self.layer addSublayer:branchShape];
//    
//    CABasicAnimation *branchGrowAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
//    branchGrowAnimation.duration = 1.0;
//    branchGrowAnimation.fromValue = [NSNumber numberWithFloat:0.0];
//    branchGrowAnimation.toValue = [NSNumber numberWithFloat:1.0];
//    [branchShape addAnimation:branchGrowAnimation forKey:@"strokeEnd"];
//}

#pragma mark - Drawing

/*  Rounded corners cause a performance hit on the iPad retina */
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    // Makes sure all strokes are within the bounds of the drawing board (including vine brush strokes)
    self.clipsToBounds = YES;
    
    // Draw the strokes
    if (!self.clearCanvas) {
        
        // Set the color of the paint
        [self colorBrushPath];
        [self.brushColor setFill];
        
        // Draw the previous strokes (saved in image)
        [[self.undoMistakes lastObject] drawInRect:rect];
        
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
        
        // Remove all points from the brush strokes
        [self.currentBrushStroke removeAllPoints];
        
        // Set the drawing of the strokes to nil
        self.incrementalImage = nil;
        
        // Remove animated vine strokes from canvas
       [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
        
        // Remove all uimages
        self.undoMistakes = nil;
        //[self.redoMistakes removeAllObjects];
        self.redoMistakes = nil;
        
        // Set clear canvas back to no
        self.clearCanvas = NO;
        
        // Set total number of strokes drawn back to zero
        self.totalNumberOfIncrementalImages = 0;
    }
}

/*  Draw the UIImage, which has all the previous strokes */
- (void)drawBitmap {
    
    // Create the UIImage
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 0.0);
    
    // Set color of the paint (will change to black if you don't do this)
    [self colorBrushPath];

    // Set background color of image (background will change to black if you don't do this!)
    if (!self.incrementalImage) {
        UIBezierPath *rectPath = [UIBezierPath bezierPathWithRect:self.bounds];
        [[UIColor whiteColor] setFill];
        [rectPath fill];
    }
    
    // Draw the UIImage
    // If the object is a not a pen OR if the pen is being erased, draw from the undo mistakes list
    if (self.brushSelected != 2 || self.erasing || self.redo) {
        [[self.undoMistakes lastObject] drawAtPoint:CGPointZero];
        self.erasing = false;
        self.redo = false;
    }
    
    // If the object is a pen and it is not being erased, draw the incremental image
    else if (self.brushSelected == 2) {
        [self.incrementalImage drawAtPoint:CGPointZero];
    }

    // Draw multiple strokes for the pen brush
    if (self.brushSelected == 2) {
        for (UIBezierPath *path in self.multipleBristles) {
            [self.brushColor setFill];
            [self fillBrushPath:path];
        }
    }
    // Draw 1 stroke for the rest of the brushes
    else {
        [self strokeBrushPath:self.currentBrushStroke];
    }
    
    if (self.fillBezierPath) {
        [self fillStroke:self.fillBrushStroke];
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

/*  Fill the brush stroke (Paint Bucket brush) */
- (void)fillStroke:(UIBezierPath *)fill {
    [self.brushColor setFill];
    [fill fillWithBlendMode:kCGBlendModeNormal alpha:self.brushOpacity];
}

/*  Fill the pen stroke */
- (void)fillBrushPath:(UIBezierPath *)fill {

    if (self.brushOpacityCounter >= [self.multipleBristles count]) {
        self.brushOpacityCounter = 0;
    }
    [fill fillWithBlendMode:kCGBlendModeNormal alpha:[[self.multipleBristlesInkSupply objectAtIndex:self.brushOpacityCounter] floatValue]];
    self.brushOpacityCounter += 1;
}


#pragma mark - Undo Painting Mistakes

- (void)undoPaintingMistakes {
    
    // Remove any strokes that have been stored in the undo mistakes array
    if ([self.undoMistakes count] > 1) {
        
        // Add the object to be removed to the redo mistakes
        [self.redoMistakes addObject:[self.undoMistakes lastObject]];
        
        [self.undoMistakes removeLastObject];
        
        self.totalNumberOfIncrementalImages -= 1;
        self.erasing = true;
        [self drawBitmap];
        [self setNeedsDisplay];
    }
    
    // If the user is deleting the first stroke they made on the drawing board...
    else if (([self.undoMistakes count] == 1) && (self.totalNumberOfIncrementalImages == 1)) {
        
        // Add the object to be removed to the redo mistakes
        [self.redoMistakes addObject:[self.undoMistakes lastObject]];

        // Delete the drawing board so it is now white
        self.incrementalImage = nil;
        
        // Reset to zero
        [self.undoMistakes removeAllObjects];
        self.totalNumberOfIncrementalImages = 0;
        
        // Draw the blank canvas
        [self setNeedsDisplay];
    }
}

- (void)redoPaintingMistakes {
    
    // Redo mistakes that the user decides to redo
    if ([self.redoMistakes count] > 0) {
        [self.undoMistakes addObject:[self.redoMistakes lastObject]];
        [self.redoMistakes removeLastObject];
        self.totalNumberOfIncrementalImages += 1;
        self.redo = true;
        [self drawBitmap];
        [self setNeedsDisplay];
    }
}

//- (int)getUndoPaintingMistakesCount {
//    return [self.undoMistakes count];
//}
//
//- (int)getRedoPaintingMistakesCount {
//    return [self.redoMistakes count];
//}

#pragma mark - Create New Drawing

- (void)createNewDrawing {
    
    // Save the old image
    [self saveImage];

    // Clear the canvas of all drawing
    self.clearCanvas = true;
    [self setNeedsDisplay];
    
    dispatch_async(saveDataQueue, ^{

        // Creat a new drawing
        self.savedDataIndex = -1;
    });
    
    self.saveDrawingBoard = nil;
    self.saveDrawingBoard = [[SaveDrawingBoard alloc] init];
    self.drawingTitle = @"Untitled";
}

#pragma mark - Save Image to Camera Roll

- (void)saveImageToCameraRoll {
    
    UIImage *saveImage = [DrawingBoardView imageWithView:self];
    UIImageWriteToSavedPhotosAlbum(saveImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    // Was there an error?
    if (error != NULL)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops, Sorry" message:@"Image could not be saved. Please try again."  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Close", nil];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yay!" message:@"Image was successfully saved in your photo album."  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Close", nil];
        [alert show];
    }
}

/*   Save the image to the camera roll */
/*  This method is an extension method for UIImage class, and it will also take care of making the image looks good on any future high-resolution devices. */
+ (UIImage *) imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, [[UIScreen mainScreen] scale]);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

#pragma mark - Animated Illustrations

- (void)addFaceAnimation:(int)tag category:(int)category {
    
    AnimatedImageView *test;

    // Create a random position for the view on the drawing board
    if (category == 0 && tag == 0) {
        const float width = 86;
        const float height = 193;
        float randomX = arc4random_uniform(self.frame.size.width - width - 10) + 5;
        float randomY = arc4random_uniform(self.frame.size.height - height - 10) + 5;

        test = [[AnimateGS alloc] initWithFrame:CGRectMake(randomX, randomY, width, height)];
    }
    else if (category == 0 && tag == 1) {
        const float width = 150;
        const float height = 150;
        float randomX = arc4random_uniform(self.frame.size.width - width - 10) + 5;
        float randomY = arc4random_uniform(self.frame.size.height - height - 10) + 5;
        test = [[RollingEyeView alloc] initWithFrame:CGRectMake(randomX, randomY, width, height)];
    }
    else if (category == 0 && tag == 2) {
        const float width = 315;
        const float height = 210;
        float randomX = arc4random_uniform(self.frame.size.width - width - 10) + 5;
        float randomY = arc4random_uniform(self.frame.size.height - height - 10) + 5;
        test = [[ToothyGrinView alloc] initWithFrame:CGRectMake(randomX, randomY, width, height)];

    }
    if (test != nil) {
        // Add a tap gesture to the view
        test.userInteractionEnabled = YES; // Important, lets image view recognize tap
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAnimatedView:)];
        [test addGestureRecognizer:tap];
        

        // Add image to the drawing board view
        [self addSubview:test];
        
        // Add animated image to an array
        [self.animatedImages addObject:test];
    }
}

/*  Return the number of animated images on the drawing board */
- (int)getAnimatedViewCount {
    return (int)[self.animatedImages count];
}

- (void)playAnimationButtonClicked {
    
    self.animated = !self.animated;

    if (self.animated) {
        // Animate all the images that have been added to the view
        for (AnimatedImageView *image in self.animatedImages) {
            [image animate];
        }
    }
    
    else {
        for (AnimatedImageView *image in self.animatedImages) {
            [image animate];
        }
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

#pragma mark - NSCoding

- (NSString *)getPathToDocumentsDir
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    
    // Return the full path to sandbox's Documents directory
    return documentsDir;
}

#define FILE_NAME @"Saved Final Image"

- (void)createBinaryFile:(NSString *)fileName
{
    // Create an object for interacting with the sanbox's file system
    NSFileManager *fm = [NSFileManager defaultManager];
    
    // Initialize the property variable with the full path to the sandbox's Documents directory, which is where the binary file will be created
    self.dataFilePath = [self.getPathToDocumentsDir stringByAppendingPathComponent:fileName];
    
    // Check to see if the binary file exists in the sandbox's Documents directory
    BOOL fileExists = [fm fileExistsAtPath:self.dataFilePath];
    
    if (fileExists == NO) {
        
        // This statement creates the binary file in the sandbox's Documents directory and initialize it with the empty array called, bookArray
        [NSKeyedArchiver archiveRootObject:self.saveDrawingBoard toFile:self.dataFilePath];
    }
}

- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}

- (void)saveImage {

    // Allows user to switch views quickly while the data is saved
   dispatch_sync(saveDataQueue, ^{
        
        // Create the file if it does not already exist
        [self createBinaryFile:FILE_NAME];
        
        NSFileManager *fm = [NSFileManager defaultManager];
        
        // Save the drawing board with the last UIImage made of the drawing board
        self.saveDrawingBoard.finalImage = [self.undoMistakes lastObject];
        UIImage *bigImage = [DrawingBoardView imageWithView:self];
        self.saveDrawingBoard.finalSmallImage = [self imageWithImage:bigImage convertToSize:CGSizeMake(218, 163)];
        self.saveDrawingBoard.finalImageTitle = self.drawingTitle;
        
        [self.animatedImagesFrame removeAllObjects];
        for (UIImageView *image in self.animatedImages) {
            CGRect imageFrame = image.frame;
            [self.animatedImagesFrame addObject:[NSValue valueWithCGRect:imageFrame]];
        }
        self.saveDrawingBoard.animatedImagesFrames = self.animatedImagesFrame;
        
        self.saveDrawingBoard.animatedImages = self.animatedImages;
        
        // Get datapath for the file
        self.dataFilePath = [[self getPathToDocumentsDir] stringByAppendingPathComponent:FILE_NAME];
        BOOL fileExists = [fm fileExistsAtPath:self.dataFilePath];
        
        // Save the image if the file exists
        if (fileExists == YES) {
            
            NSMutableArray *temp = [[NSMutableArray alloc] initWithArray:self.savedImages];
            
            if (self.savedDataIndex == -1) {
                [temp addObject:self.saveDrawingBoard];
            }
            
            if (self.savedDataIndex >= 0) {
                [temp replaceObjectAtIndex:self.savedDataIndex withObject:self.saveDrawingBoard];
            }
            
            [NSKeyedArchiver archiveRootObject:temp toFile:self.dataFilePath];
        }
    });
}

#pragma mark - Setup

- (void)commonInit {
    [self setUp];
    //[self createBinaryFile:FILE_NAME];
}

- (void)getSavedData {
    
    // Get file path to directory where data is stored
    self.dataFilePath = [[self getPathToDocumentsDir] stringByAppendingPathComponent:FILE_NAME];
    
    // Get the stored data
    NSArray *temp = [NSKeyedUnarchiver unarchiveObjectWithFile:self.dataFilePath];
    self.savedImages = [[NSArray alloc] initWithArray:temp];
    
    // If the user started a new drawing board, start a new drawing board to save the data
    if (self.savedDataIndex == -1) {
        self.saveDrawingBoard = [[SaveDrawingBoard alloc] init];
        self.drawingTitle = @"Untitled";
    }

    // If the user is editing a previous drawing, get the stored data for the drawing
    if (self.savedDataIndex >= 0) {
        
        // Get the stored data
        SaveDrawingBoard *temp = self.savedImages[self.savedDataIndex];
        self.saveDrawingBoard = temp;
        
        // Check to make sure the stored data is not empty
        if (self.saveDrawingBoard != nil) {
            if (self.saveDrawingBoard.finalImage != nil) {
                
                // Add the saved image to the undoMistakes array
                [self.undoMistakes addObject:self.saveDrawingBoard.finalImage];
                self.incrementalImage = self.saveDrawingBoard.finalImage;
                self.drawingTitle = self.saveDrawingBoard.finalImageTitle;
                
                self.animatedImages = self.saveDrawingBoard.animatedImages;
                self.animatedImagesFrame = self.saveDrawingBoard.animatedImagesFrames;
                
                int count = 0;
                for (UIImageView *image in self.animatedImages) {
                    image.frame = [[self.animatedImagesFrame objectAtIndex:count] CGRectValue];
                    
                    // Add a tap gesture to the view
                    image.userInteractionEnabled = YES; // Important, lets image view recognize tap
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAnimatedView:)];
                    [image addGestureRecognizer:tap];

                    [self addSubview:image];
                    count += 1;
                }

                self.totalNumberOfIncrementalImages += 1;
            }
        }
        // Continue with setup
        [self commonInit];
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

/*  Setup the view when it first appears */
- (void)setUp {
    
    // Set the background color of the view to white
    self.backgroundColor = [UIColor whiteColor];
    
    // Add a pan gesture to the view
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(paint:)];
    [self addGestureRecognizer:pan];
    
    // Add a tap gesture to the view
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(paintDot:)];
    [self addGestureRecognizer:tap];
    
    // The marker is automatically selected the first time the view is shown
    self.brushSelected = 0;
    
    self.paperColor = [UIColor whiteColor];
    self.clearCanvas = false;
    self.animated = false;
    self.redo = false;
    self.fillBezierPath = false;
    
    // Create queue for saving data
    saveDataQueue = dispatch_queue_create("saveDataQueue", NULL);
}

@end
