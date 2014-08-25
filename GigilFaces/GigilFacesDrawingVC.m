//
//  GigilFacesDrawingVC.m
//  GigilFaces
//
//  Created by Nicole on 8/22/14.
//  Copyright (c) 2014 nicole. All rights reserved.
//

#import "GigilFacesDrawingVC.h"
#import "ColorSelectedView.h"
#import "DrawingUtensilsTrayView.h"
#import "DrawingBoardView.h"
#import "DrawingBoardShadowView.h"
#import "BrushSizePopOverVC.h"
#import "BrushOpacityPopOverVC.h"
#import "FaceAnimationsPopOverVC.h"
#import "NoAnimatedImagesPopOverVC.h"

@interface GigilFacesDrawingVC() <BrushSizePopOverViewControllerDelegate, BrushOpacityPopOverViewControllerDelegate, FaceAnimationPopOverViewControllerDelegate>

// Colors
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *colorButtons;
@property (strong, nonatomic) NSArray *colorChoices; // Of UIColor
@property (weak, nonatomic) IBOutlet ColorSelectedView *selectedColorView;
@property (strong, nonatomic) UIColor *selectedColor;

// Brush Size
@property (nonatomic) float brushSize;
@property (weak, nonatomic) IBOutlet UIButton *chageBrushSizeButton;

// Brush Opacity
@property (nonatomic) float brushOpacity;
@property (weak, nonatomic) IBOutlet UIButton *changeBrushOpacityButton;

// Drawing Board
@property (weak, nonatomic) IBOutlet DrawingBoardView *drawingBoard;

// Brushes
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *brushButtons;
@property (strong, nonatomic) NSMutableArray *brushSelected;
@property (nonatomic) int currentBrushSelected;

// Pop-Overs
@property (nonatomic, strong) UIPopoverController *brushSizePopover;
@property (nonatomic, strong) UIPopoverController *brushOpacityPopover;
@property (nonatomic, strong) UIPopoverController *faceAnimationsPopover;
@property (nonatomic, strong) UIPopoverController *noAnimatedImagesPopover;

// Play Animation Button
@property (weak, nonatomic) IBOutlet UIButton *playAnimationButton;
@property (nonatomic) BOOL playButtonPressed;
@property (nonatomic) int numberOfAnimationsAdded;

// Clear Screen Button
@property (weak, nonatomic) IBOutlet UIButton *clearScreenButton;

// Add Face Animations Button
@property (weak, nonatomic) IBOutlet UIButton *addFaceAnimationsButton;

@end

/****************************************************************************************************/

@implementation GigilFacesDrawingVC

#pragma mark - Initialization

- (UIColor *)selectedColor {
    if (!_selectedColor) {
        UIColor * violet = [UIColor colorWithRed:102 / 255.0 green:44 / 255.0 blue:144 / 255.0 alpha:1.0];
        _selectedColor = violet;
    }
    return _selectedColor;
}

/*  All the color choices in the palette */
- (NSArray *)colorChoices {
    
    if (!_colorChoices) {
        UIColor * green = [UIColor colorWithRed:0 / 255.0 green:166 / 255.0 blue:80 / 255.0 alpha:1.0];
        UIColor * greenYellow = [UIColor colorWithRed:174 / 255.0 green:209 / 255.0 blue:53 / 255.0 alpha:1.0];
        UIColor * yellow = [UIColor colorWithRed:254 / 255.0 green:242 / 255.0 blue:0 / 255.0 alpha:1.0];
        UIColor * yellowOrange = [UIColor colorWithRed:253 / 255.0 green:184 / 255.0 blue:19 / 255.0 alpha:1.0];
        UIColor * orange = [UIColor colorWithRed:246 / 255.0 green:139 / 255.0 blue:31 / 255.0 alpha:1.0];
        UIColor * orangeRed = [UIColor colorWithRed:241 / 255.0 green:90 / 255.0 blue:35 / 255.0 alpha:1.0];
        UIColor * red = [UIColor colorWithRed:238 / 255.0 green:28 / 255.0 blue:37 / 255.0 alpha:1.0];
        UIColor * redViolet = [UIColor colorWithRed:182 / 255.0 green:35 / 255.0 blue:103 / 255.0 alpha:1.0];
        UIColor * violet = [UIColor colorWithRed:102 / 255.0 green:44 / 255.0 blue:144 / 255.0 alpha:1.0];
        UIColor * violetBlue = [UIColor colorWithRed:83 / 255.0 green:79 / 255.0 blue:163 / 255.0 alpha:1.0];
        UIColor * blue = [UIColor colorWithRed:0 / 255.0 green:119 / 255.0 blue:177 / 255.0 alpha:1.0];
        UIColor * blueGreen = [UIColor colorWithRed:109 / 255.0 green:200 / 255.0 blue:191 / 255.0 alpha:1.0];
        UIColor * black  = [UIColor blackColor];
        UIColor * white = [UIColor whiteColor];
        
        _colorChoices = @[green, greenYellow, yellow, yellowOrange, orange, orangeRed, red, redViolet, violet,violetBlue, blue, blueGreen, black, white];
    }
    return _colorChoices;
}

- (NSMutableArray *)brushSelected {
    if (!_brushSelected) {
        // The first brush is always selected when the program starts
        _brushSelected = [[NSMutableArray alloc] initWithArray:@[@YES, @NO, @NO, @NO, @NO]];
    }
    return _brushSelected;
}

#pragma mark - Buttons

- (IBAction)playAnimationButtonClicked:(UIButton *)sender {
    
    // Check to make sure there are animated images on the drawing board
    if (self.numberOfAnimationsAdded > 0) {
       
        // Changed the title of the button when animation starts
        if (self.playButtonPressed) {
            [self.playAnimationButton setTitle:@"Stop Animation" forState:UIControlStateNormal];
            
            // Disable All brushes
            for (UIButton *button in self.brushButtons) {
                button.enabled = NO;
            }
            
            // Disable size and opacity buttons
            self.chageBrushSizeButton.enabled = NO;
            self.changeBrushOpacityButton.enabled = NO;
            self.addFaceAnimationsButton.enabled = NO;
            
            // Disable clear screen button
            self.clearScreenButton.enabled = NO;
            
            // Disable drawing
            self.drawingBoard.brushSelected = -1;
        }
        
        // Change the title of the button when animation stops
        else {
            [self.playAnimationButton setTitle:@"Start Animation" forState:UIControlStateNormal];
            
            // Enable all brushes
            for (UIButton *button in self.brushButtons) {
                button.enabled = YES;
            }
            
            // Enable size and opacity buttons
            self.chageBrushSizeButton.enabled = YES;
            self.changeBrushOpacityButton.enabled = YES;
            self.addFaceAnimationsButton.enabled = YES;
            
            // Enable clear screen button
            self.clearScreenButton.enabled = YES;
            
            // Re-enable drawing
            self.drawingBoard.brushSelected = self.currentBrushSelected;
        }
        
        // Notify the drawing board that animation is starting
        [self.drawingBoard playAnimationButtonClicked];
    }
    
    // If no animations have been added yet, create a pop over to notify the user
    else {
        NoAnimatedImagesPopOverVC *warningVC = [[NoAnimatedImagesPopOverVC alloc]
                                                       initWithNibName:@"NoAnimatedImagesPopOverVC" bundle:nil];
        
        self.noAnimatedImagesPopover = [[UIPopoverController alloc] initWithContentViewController:warningVC];
        self.noAnimatedImagesPopover.popoverContentSize = CGSizeMake(180, 90);
        [self.noAnimatedImagesPopover presentPopoverFromRect:[(UIButton *)sender frame]
                                                  inView:self.view
                                permittedArrowDirections:UIPopoverArrowDirectionAny
                                                animated:YES];

        // Dismiss the pop over automatically
        [UIView animateWithDuration:3.0 animations:^ {
            [self.noAnimatedImagesPopover dismissPopoverAnimated:YES];
        }];
    }
    self.playButtonPressed = !self.playButtonPressed;
}

- (IBAction)faceAnimationSelected:(UIButton *)sender {
    FaceAnimationsPopOverVC *collectionViewController = [[FaceAnimationsPopOverVC alloc]
                                                         initWithNibName:@"FaceAnimationsPopOverVC" bundle:nil];
    collectionViewController.delegate = self;
    
    self.faceAnimationsPopover = [[UIPopoverController alloc] initWithContentViewController:collectionViewController];
    self.faceAnimationsPopover.popoverContentSize = CGSizeMake(265, 470);
    [self.faceAnimationsPopover presentPopoverFromRect:[(UIButton *) sender frame]
                                                inView:self.view
                              permittedArrowDirections:UIPopoverArrowDirectionAny
                                            animated:YES];
}

- (IBAction)brushOpacitySelected:(UIButton *)sender {
    BrushOpacityPopOverVC *sliderViewController = [[BrushOpacityPopOverVC alloc]
                                                   initWithNibName:@"BrushOpacityPopOverVC" bundle:nil];
    sliderViewController.brushColor = self.selectedColor;
    sliderViewController.brushOpacity = self.brushOpacity;
    sliderViewController.delegate = self;
    
    self.brushOpacityPopover = [[UIPopoverController alloc] initWithContentViewController:sliderViewController];
    self.brushOpacityPopover.popoverContentSize = CGSizeMake(265, 362);
    [self.brushOpacityPopover presentPopoverFromRect:[(UIButton *)sender frame]
                                              inView:self.view
                            permittedArrowDirections:UIPopoverArrowDirectionAny
                                            animated:YES];
}

- (IBAction)brushSizeSelected:(UIButton *)sender {
    BrushSizePopOverVC *sliderViewController = [[BrushSizePopOverVC alloc]
                                                  initWithNibName:@"BrushSizePopOverVC"
                                                  bundle:nil];
    sliderViewController.brushSize = self.brushSize; // CHANGE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    sliderViewController.brushColor = self.selectedColor;
    sliderViewController.delegate = self;
    
    self.brushSizePopover = [[UIPopoverController alloc] initWithContentViewController:sliderViewController];
    self.brushSizePopover.popoverContentSize = CGSizeMake(265, 362);
    [self.brushSizePopover presentPopoverFromRect:[(UIButton *)sender frame]
                                           inView:self.view
                         permittedArrowDirections:UIPopoverArrowDirectionAny
                                         animated:YES];
}

- (IBAction)clearScreenSelected:(UIButton *)sender {
    
    // Clear the drawing board of painting strokes
    self.drawingBoard.clearCanvas = YES;
    
    // Clear the drawing board of animated images
    [self.drawingBoard clearAnimatedArray];
    
    // Reset number of animations added to zero
    self.numberOfAnimationsAdded = 0;
    
    // Reset play button presssed
    self.playButtonPressed = true;
}

/*  When the user changes the color, update the color selected view with the color */
- (IBAction)colorSelected:(UIButton *)sender {
    UIColor *colorPicked = [self.colorChoices objectAtIndex:sender.tag];
    self.selectedColor = colorPicked;
    self.selectedColorView.selectedColor = colorPicked;
    self.drawingBoard.brushColor = colorPicked;
}

/* When the user changes the brush, update the brush background image */
- (IBAction)brushSelected:(UIButton *)sender {
    
    // Get the button that was selected
    int index = sender.tag;
    UIButton *selectedButton = [self.brushButtons objectAtIndex:index];

    // If any other button was hightlighted, change image to unselected image
    for (int i = 0; i < [self.brushButtons count]; i += 1) {
        
        BOOL buttonSelected = [[self.brushSelected objectAtIndex:i] boolValue];
        UIButton *button = [self.brushButtons objectAtIndex:i];
        
        // If the same button is clicked on again, don't change image
        if ((button.tag == selectedButton.tag) && buttonSelected) {
            continue;
        }
        
        // If another button was selected, change image to smaller version
        if (buttonSelected) {
            
            //Change the old selected button's size
            CGRect oldButtonNewFrame = button.frame;
            oldButtonNewFrame.size = CGSizeMake(62, 55);
            button.frame = oldButtonNewFrame;
            
            // Get unselected image for button
            NSArray *unSelectedImageNames = [GigilFacesDrawingVC validUnSelectedImageNames];
            UIImage *unselectedButtonImage = [UIImage imageNamed:[unSelectedImageNames objectAtIndex:i]];
            [button setBackgroundImage:unselectedButtonImage forState:UIControlStateNormal];
            
            // Set selection to 'false'
            [self.brushSelected replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:NO]];
            break;
        }
    }
    
    // If the selected button was unselected, change the background image to the larger image
    if (![[self.brushSelected objectAtIndex:index] boolValue]) {
        CGRect newButtonNewFrame = selectedButton.frame;
        newButtonNewFrame.size = CGSizeMake(102, 55);
        selectedButton.frame = newButtonNewFrame;
        
        // Get selected image for button
        NSArray *selectedImageNames = [GigilFacesDrawingVC validSelectedImageNames];
        UIImage *selectedButtonImage = [UIImage imageNamed:[selectedImageNames objectAtIndex:index]];
        [selectedButton setBackgroundImage:selectedButtonImage forState:UIControlStateNormal];
        
        // Set selection to 'true'
        [self.brushSelected replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:YES]];
    }
   
    // If the selected button was selected already, change the background image to the smaller image
    else {
        CGRect oldButtonNewFrame = selectedButton.frame;
        oldButtonNewFrame.size = CGSizeMake(62, 55);
        selectedButton.frame = oldButtonNewFrame;
        
        // Get unselected image for button
        NSArray *unSelectedImageNames = [GigilFacesDrawingVC validUnSelectedImageNames];
        UIImage *unselectedButtonImage = [UIImage imageNamed:[unSelectedImageNames objectAtIndex:index]];
        [selectedButton setBackgroundImage:unselectedButtonImage forState:UIControlStateNormal];
        
        // Set selection to 'false'
        [self.brushSelected replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:NO]];
    }
    
    // Disable the size and opacity buttons if the pen brush is enabled, enable if not
    // Pen brush opacity and size CAN NOT be changed at the moment
    if ([[self.brushSelected objectAtIndex:2] boolValue]) {
        self.chageBrushSizeButton.enabled = NO;
        self.changeBrushOpacityButton.enabled = NO;
    }
    else {
        self.chageBrushSizeButton.enabled = YES;
        self.changeBrushOpacityButton.enabled = YES;
    }
    
    // If any brush has been selected by the user, send the brush selected to the drawing board
    for (NSNumber *selectedBrush in self.brushSelected) {
        if ([selectedBrush boolValue]) {
            self.drawingBoard.brushSelected = index;
            self.currentBrushSelected = index;
            return;
        }
    }

    // If no brush is now selected, tell the drawing board that no brush has been selected
    self.drawingBoard.brushSelected = -1;
    self.currentBrushSelected = -1;
}

+ (NSArray *)validSelectedImageNames {
    return @[@"markerSelected", @"crayonSelected", @"penSelected", @"eraserSelected", @"vineBrushSelected"];
}

+ (NSArray *)validUnSelectedImageNames {
    return @[@"markerUnSelected", @"crayonUnSelected", @"penUnSelected", @"eraserUnSelected", @"vineBrushUnSelected"];
}

#pragma mark - Protocal Delegates

-(void)sliderValueChanged:(float)brushSize {
    self.brushSize = brushSize;
    self.drawingBoard.brushSize = brushSize;
}

-(void)opacityValueChanged:(float)opacity {
    self.brushOpacity = opacity;
    self.drawingBoard.brushOpacity = opacity;
}

/*  Add a face animation to the drawing board */
- (void)faceShapeChanged:(int)tag category:(int)category {
    
    // Increase count of number of animated images added to the drawing board
    self.numberOfAnimationsAdded += 1;
    
    // Tell the drawing board to add the image
    [self.drawingBoard addFaceAnimation:tag category:category];
}

#pragma mark - Setup

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initalize the color-selected-view with a color
    self.selectedColorView.selectedColor = self.selectedColor;
    
    // Add a white rectangle behind the drawing utensils
    CGRect drawingUtensilsBackgroundBounds = CGRectMake(0, 65, 74, 601);
    DrawingUtensilsTrayView *drawingUtensilsBackground = [[DrawingUtensilsTrayView alloc] initWithFrame:drawingUtensilsBackgroundBounds];
    [self.view addSubview:drawingUtensilsBackground];
    [self.view sendSubviewToBack:drawingUtensilsBackground];
    
    // Add a shadow behind the drawing board
    CGRect drawingBoardShadowBounds = CGRectMake(112, 65, 800, 600);
    DrawingBoardShadowView *drawingBoardShadow = [[DrawingBoardShadowView alloc] initWithFrame:drawingBoardShadowBounds];
    drawingBoardShadow.backgroundColor= [UIColor clearColor];
    [self.view addSubview:drawingBoardShadow];
    [self.view sendSubviewToBack:drawingBoardShadow];
    
    // Init brush size
    self.brushSize = 40.0;
    self.brushOpacity = 1.0;
    
    // Init play button
    self.playButtonPressed = true;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
