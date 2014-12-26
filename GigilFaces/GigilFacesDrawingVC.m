//
//  GigilFacesDrawingVC.m
//  GigilFaces
//
//  Created by Nicole on 8/22/14.
//  Copyright (c) 2014 nicole. All rights reserved.
//

#import "GigilFacesDrawingVC.h"
#import "ColorSelectedView.h"
#import "ColorTrayView.h"
#import "DrawingUtensilsTrayView.h"
#import "DrawingBoardView.h"
#import "DrawingBoardShadowView.h"
#import "BrushSizePopOverVC.h"
#import "BrushOpacityPopOverVC.h"
#import "FaceAnimationsPopOverVC.h"
#import "NoAnimatedImagesPopOverVC.h"
#import "StaticImagesPopOverVCViewController.h"
#import "MyDrawingsVC.h"
#import "SavePopOverVC.h"

/* THIS IS A TEST FOR THE COMMENT BRANCH */

@interface GigilFacesDrawingVC() <BrushSizePopOverViewControllerDelegate, BrushOpacityPopOverViewControllerDelegate, FaceAnimationPopOverViewControllerDelegate, SavePopOverViewControllerDelegate, StaticImagesPopOverViewControllerDelegate>

// UI Navigational Controller Button
@property (weak, nonatomic) IBOutlet UIBarButtonItem *myDrawingsButton;

// Color Selected
@property (strong, nonatomic) ColorSelectedView *selectedColorView;

// Colors
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *colorButtons;
@property (strong, nonatomic) NSArray *colorChoices; // Of UIColor
@property (strong, nonatomic) UIColor *selectedColor;

// Color Tray (Located Under color buttons)
@property (weak, nonatomic) IBOutlet ColorTrayView *colorTrayView;

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
// All popovers are created in separate XIB files (NOT in the main storyboard)
@property (nonatomic, strong) UIPopoverController *brushSizePopover;
@property (nonatomic, strong) UIPopoverController *brushOpacityPopover;
@property (nonatomic, strong) UIPopoverController *faceAnimationsPopover;
@property (nonatomic, strong) UIPopoverController *noAnimatedImagesPopover;
@property (nonatomic, strong) UIPopoverController *saveImagesPopover;
@property (nonatomic, strong) UIPopoverController *staticImagesPopover;

// Play Animation Button
@property (weak, nonatomic) IBOutlet UIButton *playAnimationButton;
@property (nonatomic) BOOL playButtonPressed;

// Add Face Animations Button
@property (weak, nonatomic) IBOutlet UIButton *addFaceAnimationsButton;

// Grey background (when user clicks play button)
@property (strong, nonatomic) UIView *greyBackground;

// Undo and Redo Mistakes Buttons
@property (weak, nonatomic) IBOutlet UIButton *undoMistakesButton;
@property (weak, nonatomic) IBOutlet UIButton *redoMistakesButton;

@end

/****************************************************************************************************/

@implementation GigilFacesDrawingVC

#pragma mark - Initialization

/**
 *  Initializes the selected color to violet (when the program first opens).
 *
 *  @return UIColor of violet.
 */
- (UIColor *)selectedColor {
    if (!_selectedColor) {
        UIColor * violet = [UIColor colorWithRed:102 / 255.0 green:44 / 255.0 blue:144 / 255.0 alpha:1.0];
        _selectedColor = violet;
    }
    return _selectedColor;
}

/**
 *  Initializes all the colors in the palette.
 *
 *  @return An NSArray of all the colors in the palette.
 */
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

/**
 *  Initializes the selected state of each brush in the palette when the program starts.
 *  Only one brush can be selected at a time. The first brush selected is the top brush 
 *  on the palette (the marker).
 *
 *  @return An NSMutableArray of the selected state of all the brushes in the palette.
 */
- (NSMutableArray *)brushSelected {
    if (!_brushSelected) {
        // The top brush on the palette is always selected when the program starts
        _brushSelected = [[NSMutableArray alloc] initWithArray:@[@YES, @NO, @NO, @NO, @NO]];
    }
    return _brushSelected;
}

#pragma mark - Buttons

/**
 *  Saves the current drawing and then provides a blank piece of paper for a new drawing.
 */
- (void)createNewDrawing {
    [self.drawingBoard createNewDrawing];
}

/**
 *  When user clicks the settings button, a popup will appear with the following options: 
 *  give a title to the image, save the image to their camera roll, create a new drawing, or
 *  to delete the current drawing.
 *
 *  @param sender The settings button.
 */
- (IBAction)settingsButtonClicked:(UIButton *)sender {
    
    // The popover is created in a separate XIB file (NOT in the main storyboard)
    SavePopOverVC *saveImagesVC = [[SavePopOverVC alloc]
                                                   initWithNibName:@"SavePopOverVC" bundle:nil];
    
    /* If the image has already been titled, the textfield placeholder will show the title, otherwise
     * the word 'Untitled' will show up in the textfield placeholder */
    saveImagesVC.drawingTitle = self.drawingBoard.drawingTitle;
    saveImagesVC.delegate = self;
    
    self.saveImagesPopover = [[UIPopoverController alloc] initWithContentViewController:saveImagesVC];
    self.saveImagesPopover.popoverContentSize = CGSizeMake(250, 286);
    [self.saveImagesPopover presentPopoverFromRect:[(UIButton *)sender frame]
                                              inView:self.view
                            permittedArrowDirections:UIPopoverArrowDirectionAny
                                            animated:YES];
}

/**
 *  If the user clicked the undo mistakes button too many times, they can click the redo mistakes
 *  button to get the drawing back.
 *
 *  @param sender The redo button.
 */
- (IBAction)redoMistakesButton:(UIButton *)sender {
    [self.drawingBoard redoPaintingMistakes];
}

/**
 *  If the user does not like a stroke they made with a brush, they can delete it using this button.
 *  Can only delete up to 9 drawing strokes. The undo mistakes button will NOT delete images (e.g.
 *  animated or static images that users add from the menu).
 *
 *  @param sender The undo mistakes button.
 */
- (IBAction)undoMistakesButton:(UIButton *)sender {
    [self.drawingBoard undoPaintingMistakes];
}

/**
 *  Will 'play' the animations when the play button is clicked. Clicking the play button will change
 *  it to the pause button, and vice-versa. The background will be greyed out and all buttons will
 *  be disabled except for the pause button. Animations will start playing when the play button is clicked.
 *  Clicking on the pause button will stop animations and allow the user to return to the drawing board.
 *
 *  If there are no animations on the drawing board, a popover will appear alerting the user that they
 *  need to add animated images before they can click the play button.
 *
 *  @param sender The play button.
 */
- (IBAction)playAnimationButtonClicked:(UIButton *)sender {

    // Get the number of animated images that are currently on the drawing board.
    int numberOfAnimationViews = [self.drawingBoard getAnimatedViewCount];
    
    // Check to make sure there is at least 1 animated image on the drawing board or that
    // the user clicked on the play button (not the pause button)
    if (numberOfAnimationViews > 0 || self.playButtonPressed) {
       
        // Switch play button to pause button or pause button to play button
        self.playButtonPressed = !self.playButtonPressed;

        // If the button was a play button, change it to a pause button
        if (self.playButtonPressed) {
            
            // Change button background to the pause image
            UIImage *pauseButton = [UIImage imageNamed:@"pauseButton.png"];
            [self.playAnimationButton setBackgroundImage:pauseButton forState:UIControlStateNormal];
            
            // Grey out the background by creating a new UIView
            self.greyBackground = [[UIView alloc] initWithFrame:self.view.bounds];
            [self.view addSubview:self.greyBackground];
            UIColor *greyedBackgroundColor = [UIColor colorWithRed:48 / 255.0 green:46 / 255.0 blue:48 / 255.0 alpha:0.95];
            self.greyBackground.backgroundColor = greyedBackgroundColor;
            
            // Grey out the navigational controller
            [self.navigationController.navigationBar setBarTintColor:greyedBackgroundColor];
            
            // Disable the back button and myDrawings button in the navigational controller
            [self.navigationItem setHidesBackButton:YES animated:YES];
            self.myDrawingsButton.tintColor = [UIColor clearColor];
            self.myDrawingsButton.enabled = NO;
            
            // Bring the drawing board view and pause button in front of the greyed-out view
            [self.view bringSubviewToFront:self.drawingBoard];
            [self.view bringSubviewToFront:self.playAnimationButton];
            
            // Disable all drawing
            self.drawingBoard.brushSelected = -1;
        }
        
        // If the button was a pause button, change it to a play button
        else {
            
            // Change button background to the play image
            UIImage *playButton = [UIImage imageNamed:@"playButton.png"];
            [self.playAnimationButton setBackgroundImage:playButton forState:UIControlStateNormal];
            
            // Remove the greyed-out background view
            [self.greyBackground removeFromSuperview];
            
            // Reactivate the navigational controller
            [self.navigationController.navigationBar setBarTintColor:[self.colorChoices objectAtIndex:11]];
            
            // Enable the back button and myDrawings button in the navigational controller
            [self.navigationItem setHidesBackButton:NO animated:YES];
            self.myDrawingsButton.tintColor = [self.view tintColor];
            self.myDrawingsButton.enabled = YES;

            // Re-enable drawing
            self.drawingBoard.brushSelected = self.currentBrushSelected;
        }
        
        // Notify the drawing board that animation is starting or stopping
        [self.drawingBoard playAnimationButtonClicked];
    }
    
    // If no animations have been added to the drawingboard yet, a pop-over will alert the user to the fact that
    // they must have animated images on the board before they click the play button
    else {
        // All popovers are created in a separate XIB file (not on the main storyboard)
        NoAnimatedImagesPopOverVC *warningVC = [[NoAnimatedImagesPopOverVC alloc]
                                                       initWithNibName:@"NoAnimatedImagesPopOverVC" bundle:nil];
        
        self.noAnimatedImagesPopover = [[UIPopoverController alloc] initWithContentViewController:warningVC];
        self.noAnimatedImagesPopover.popoverContentSize = CGSizeMake(180, 90);
        [self.noAnimatedImagesPopover presentPopoverFromRect:[(UIButton *)sender frame]
                                                  inView:self.view
                                permittedArrowDirections:UIPopoverArrowDirectionAny
                                                animated:YES];
    }
}

/**
 *  When the animations button is clicked, a pop-over will appear with a list of of animated images to choose from.
 *  Clicking on an image in the pop-over will add it to the drawing board.
 *
 *  @param sender Face Animation Button.
 */
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

- (IBAction)staticImageSelected:(UIButton *)sender {
    StaticImagesPopOverVCViewController *collectionViewController = [[StaticImagesPopOverVCViewController alloc]
                                                                     initWithNibName:@"StaticImagesPopOverVCViewController" bundle:nil];
    collectionViewController.delegate = self;
    
    self.staticImagesPopover = [[UIPopoverController alloc] initWithContentViewController:collectionViewController];
    self.staticImagesPopover.popoverContentSize = CGSizeMake(265, 470);
    [self.staticImagesPopover presentPopoverFromRect:[(UIButton *) sender frame]
                                              inView:self.view
                            permittedArrowDirections:UIPopoverArrowDirectionAny
                                            animated:YES];
}


/**
 *  When the brush opacity button is clicked, a pop-over appears allowing the user to change the brush opacity.
 *  The user can change the brush opacity (otherwise known as transparency) by dragging on a slider.
 *  The slider scale opacity levels vary from almost transparent to completely opaqe.
 *  User can see the different levels of transparency when they drag the slider by looking at a
 *  circle that changes to the opacity represented by the slider position as the slider is moved.
 *
 *  @param sender The brush opacity button.
 */
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

/**
 *  When the brush size button is clicked, a pop-over appears allowing the user to change the brush size.
 *  The user change change the brush size by dragging on a slider. The slider scale size levels vary from 
 *  approximately 5 pixels diameter to 200 pixels diameter. 
 *  Users can see the different brush sizes when they drag the slider by looking at a circle that changes
 *  size to represent the slider position as the slider is moved
 *
 *  @param sender The brush size button.
 */
- (IBAction)brushSizeSelected:(UIButton *)sender {
    BrushSizePopOverVC *sliderViewController = [[BrushSizePopOverVC alloc]
                                                  initWithNibName:@"BrushSizePopOverVC"
                                                  bundle:nil];
    sliderViewController.brushSize = self.brushSize;
    sliderViewController.brushColor = self.selectedColor;
    sliderViewController.delegate = self;
    
    self.brushSizePopover = [[UIPopoverController alloc] initWithContentViewController:sliderViewController];
    self.brushSizePopover.popoverContentSize = CGSizeMake(265, 362);
    [self.brushSizePopover presentPopoverFromRect:[(UIButton *)sender frame]
                                           inView:self.view
                         permittedArrowDirections:UIPopoverArrowDirectionAny
                                         animated:YES];
}

/**
 *  When the user clicks the delete drawing button in the settings pop-over, an alert will pop up asking them
 *  if they really want to delete the drawing. If they press 'cancel,' the popover will be dismissed and nothing
 *  will happen. If they press 'yes,' the canvas will be wiped clean and the user will be given a blank
 *  canvas to draw on.
 */
- (void)clearScreenSelected {
    
    // Warn the user that their drawing will disappear forever
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"The Slate is Being Wiped"
                                                    message:@"Your whole drawing will disappear forever. Do you want to continue?"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Yes", nil];
    [alert show];

}

/**
 *  Alert created when user clicks on the delete button. This alert view warns the user that their drawing is being
 *  deleted. If they click on the 'yes' button in response to the prompt, the drawing will be deleted. If they click
 *  'cancel,' the popover will be dismissed and nothing will happen to the drawing.
 *
 *  @param alertView   An alert view.
 *  @param buttonIndex Index position of the button the user clicked
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if ([alertView.title isEqual:@"The Slate is Being Wiped"]) {
        
        // If user clicked on 'yes' in alert pop-up, wipe the drawing from the canvas
        if (buttonIndex == 1) {
            
            // Clear the drawing board of painting strokes
            self.drawingBoard.clearCanvas = YES;
            
            // Clear the drawing board of animated images
            [self.drawingBoard clearAnimatedArray];
            
            // Reset play button presssed
            self.playButtonPressed = false;
        }
    }
}

/**
 *  When the user changes the color by picking a different color from the palette, update the color selected view
 *  (the larger square on top of the palette) with the new color choice.
 *
 *  @param IBAction An array of UIButtons that depict different colors in the palette
 *
 *  @return void
 */
/*  When the user changes the color, update the drawing board and the color selected view with the new color */
- (IBAction)colorSelected:(UIButton *)sender {
    
    // Get the color of the button that was selected
    UIColor *colorPicked = [self.colorChoices objectAtIndex:sender.tag];
    
    // Update the selected color
    self.selectedColor = colorPicked;
    
    // Tell the drawing board what the selected color is
    self.drawingBoard.brushColor = colorPicked;
    
    // Tell the selected color view what the color is (Large square at top of the color palette)
    self.selectedColorView.selectedColor = colorPicked;
}

/**
 *  When the user changes the brush that they want to draw with, hightlight the selected brush and deselect
 *  the brush that was previously selected. Users can also deselect all brushes so they can't draw at all.
 *
 *  @param IBAction An array of UIButtons that depict different brushes
 *
 *  @return void
 */
/* When the user changes the brush, update the brush background image */
- (IBAction)brushSelected:(UIButton *)sender {
    
    // Get the brush button that was selected
    int index = (int)sender.tag;
    UIButton *selectedButton = [self.brushButtons objectAtIndex:index];

    // If any other button was hightlighted, change image to unselected image
    for (int i = 0; i < [self.brushButtons count]; i += 1) {
        
        BOOL buttonSelected = [[self.brushSelected objectAtIndex:i] boolValue];
        UIButton *button = [self.brushButtons objectAtIndex:i];
        
        // If the same button is clicked on again, don't change image
        if ((button.tag == selectedButton.tag) && buttonSelected) {
            continue;
        }
        
        // If another button was selected, change image to smaller unselected version
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
    
    // If the selected button was unselected, change the background image to the larger highlighted image
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
   
    // If the selected button was selected already, change the background image to the smaller unselected image
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
    if ([[self.brushSelected objectAtIndex:2] boolValue]) {
        self.chageBrushSizeButton.enabled = NO;
        self.changeBrushOpacityButton.enabled = NO;
    }
    else {
        self.chageBrushSizeButton.enabled = YES;
        self.changeBrushOpacityButton.enabled = YES;
    }
    
    // Disable the size button if the fill brush is enabled. Enable it if not
    if ([[self.brushSelected objectAtIndex:4] boolValue]) {
        self.chageBrushSizeButton.enabled = NO;
    }
    else {
        self.chageBrushSizeButton.enabled = YES;
    }
    
    // If any brush has been selected by the user, send the brush selected to the drawing board
    for (NSNumber *selectedBrush in self.brushSelected) {
        if ([selectedBrush boolValue]) {
            self.drawingBoard.brushSelected = index;
            self.currentBrushSelected = index;
            return;
        }
    }

    // Else, if no brush is selected, tell the drawing board that no brush is selected
    self.drawingBoard.brushSelected = -1;
    
    // Keep track of the fact that no brush is currently selected
    self.currentBrushSelected = -1;
}

/**
 *  An array of image names for the highlighted brushes.
 *
 *  @return An array of NSStrings with images names of selected brushes.
 */
+ (NSArray *)validSelectedImageNames {
    return @[@"markerSelected", @"crayonSelected", @"penSelected", @"eraserSelected", @"fillSelected"];
}

/**
 *  An array of image names for the unhightlighted brushes.
 *
 *  @return An array of NSStrings with image names of unselected brushes.
 */
+ (NSArray *)validUnSelectedImageNames {
    return @[@"markerUnSelected", @"crayonUnSelected", @"penUnSelected", @"eraserUnSelected", @"fillUnSelected"];
}

#pragma mark - Adopting the Protocals

/**
 *  Required method to adhere to the BrushSizePopOverViewControllerDelegate. Tells the drawing board what
 *  size to make the brush.
 *
 *  @param brushSize The size of the brush.
 */
-(void)sliderValueChanged:(float)brushSize {
    self.brushSize = brushSize;
    self.drawingBoard.brushSize = brushSize;
}

/**
 *  Required method to adhere to the BrushOpacityPopOverViewControllerDelegate. Tells the drawing board what 
 *  opacity to make the brush.
 *
 *  @param opacity The opacity of the brush.
 */
-(void)opacityValueChanged:(float)opacity {
    self.brushOpacity = opacity;
    self.drawingBoard.brushOpacity = opacity;
}

/**
 *  Require method to adhere to the FaceAnimationPopOverViewControllerDelegate. Tells the drawing board to add
 *  a face animation to the drawing board.
 *
 *  @return void
 */
- (void)faceShapeChanged:(int)tag category:(int)category {
    
    // Tell the drawing board to add the selected image
    // A scale value of 1 applies no scaling
    // A rotate value of 0 applies no rotation
    // Negative x and y locations tell the program to add the image to the drawing board in a random position
    [self.drawingBoard addFirstTimeFaceAnimation:tag category:category xLocation:-1 yLocation:-1 scaleValue:1 rotateValue:0 centerValue:CGPointMake(-100, -100) imageType:@"animated"];
}

- (void)staticImageAdded:(int)tag category:(int)category {
    // Tell the drawing board to add the selected image
    // A scale value of 1 applies no scaling
    // A rotate value of 0 applies no rotation
    // Negative x and y locations tell the program to add the image to the drawing board in a random position
    [self.drawingBoard addFirstTimeFaceAnimation:tag category:category xLocation:-1 yLocation:-1 scaleValue:1 rotateValue:0 centerValue:CGPointMake(-100, -100) imageType:@"static"];
}

/**
 *  Required method to adhere to the SavePopOverViewControllerDelegate. Tells the drawing board what the user
 *  named their drawing, and also changes the title of the navigational controller to the name of the drawing.
 *
 *  @param drawingTitle The name of the drawing
 */
- (void)savedTitle:(NSString *)drawingTitle {
    
    // Set the title of the navigational controller
    self.navigationController.topViewController.title = drawingTitle;
    
    // Tells the drawing board the title of the navigational controller
    self.drawingBoard.drawingTitle = drawingTitle;
}

/**
 *  Required method to adhere to the SavePopOverViewControllerDelegate. If user clicks the done button in the
 *  the Save Pop-over, dismiss the pop over.
 */
- (void)doneButton {
    [self.saveImagesPopover dismissPopoverAnimated:YES];
}

/**
 *  Required method to adhere to the SavePopOverViewControllerDelegate. If user clicks on the save picture to camera
 *  roll button, tell the drawing board to save the image to the camera roll and dismiss the popover.
 */
- (void)savePictureToCameraRoll {
    [self.drawingBoard saveImageToCameraRoll];
    [self.saveImagesPopover dismissPopoverAnimated:YES];
}

/**
 *  Required method to adhere to the SavePopOverViewControllerDelegate. If user clicks on the create new drawing
 *  button in the Save Pop-over, tell the drawing board to create a new drawing and dismiss the popover.
 */
- (void)makeNewDrawing {
    [self createNewDrawing];
    [self drawingTitle];
    [self.saveImagesPopover dismissPopoverAnimated:YES];
}

- (void)drawingTitle {
    // Set title of navigational view
    self.navigationController.topViewController.title = self.drawingBoard.drawingTitle;
}

/**
 *  Required method to adhere to the SavePopOverViewControllerDelegate. If user clicks on the delete drawing button
 *  in the Save Pop-over, tell the drawing board to clear the drawing and dismiss the popover.
 */
- (void)deleteDrawing {
    [self clearScreenSelected];
    [self.saveImagesPopover dismissPopoverAnimated:YES];
}

#pragma mark - View Will Disappear

/**
 *  Save the drawing when the user exits the view
 *
 *  @return void
 */
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.drawingBoard saveImage];
}

#pragma mark - NSNotifications

/**
 *  Save the drawing board image when the user clicks on the iPad's home button to exit the Gigil Faces app.
 *
 *  @param note 
 *      Notification that tells the app that the user is exiting the GigilFaces app
 */
-(void)appWillResignActive:(NSNotification*)note {
    [self.drawingBoard saveImage];
}

/**
 *  Save the drawing board image when the app terminates.
 *
 *  @param note 
 *      Notification that tells the app that the user is terminating the GigilFaces app
 */
-(void)appWillTerminate:(NSNotification*)note {
    [self.drawingBoard saveImage];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillTerminateNotification object:nil];
}

#pragma mark - Setup

/**
 *  Initializes the drawing board.
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Add a white rectangle behind the drawing utensils (located to the left of the drawing board)
    CGRect drawingUtensilsBackgroundBounds = CGRectMake(0, 0, 74, 601);
    DrawingUtensilsTrayView *drawingUtensilsBackground = [[DrawingUtensilsTrayView alloc] initWithFrame:drawingUtensilsBackgroundBounds];
    [self.view addSubview:drawingUtensilsBackground];
    [self.view sendSubviewToBack:drawingUtensilsBackground];
    
    // Add a shadow behind the drawing board
    CGRect drawingBoardShadowBounds = CGRectMake(112, 0, 800, 600);
    DrawingBoardShadowView *drawingBoardShadow = [[DrawingBoardShadowView alloc] initWithFrame:drawingBoardShadowBounds];
    drawingBoardShadow.backgroundColor= [UIColor clearColor];
    [self.view addSubview:drawingBoardShadow];
    [self.view sendSubviewToBack:drawingBoardShadow];
    
    // Initialize brush size and the brush opacity
    self.brushSize = 40.0;
    self.brushOpacity = 1.0;
    
    // Initialize the brush color
    UIColor *violet = [UIColor colorWithRed:102 / 255.0 green:44 / 255.0 blue:144 / 255.0 alpha:1.0];

    // Initialize the play button
    self.playButtonPressed = false;
    
    // Register for notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillTerminate:) name:UIApplicationWillTerminateNotification object:nil];
    
    // Initialize the drawing board
    self.drawingBoard.savedDataIndex = self.savedDataIndex;
    self.drawingBoard.brushSize = self.brushSize;
    self.drawingBoard.brushOpacity = self.brushOpacity;
    self.drawingBoard.brushColor = violet;
    
    // Set title of navigational view
    self.navigationController.topViewController.title = self.drawingBoard.drawingTitle;
    
    // Add the color selected view (large rectangle at the top of the color palette, changes color when user selects new color)
    CGRect colorSelectedBounds = CGRectMake(13, 14, 72, 66);
    self.selectedColorView = [[ColorSelectedView alloc] initWithFrame:colorSelectedBounds];
    self.selectedColorView.backgroundColor = [UIColor clearColor];
    [self.colorTrayView addSubview:self.selectedColorView];
    self.selectedColorView.selectedColor = violet;
}

/**
 *  Memory warning.
 */
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
