//
//  GigilFacesDrawingVC.m
//  GigilFaces
//
//  Created by Nicole on 8/22/14.
//  Copyright (c) 2014 nicole. All rights reserved.
//

#import "GigilFacesDrawingVC.h"
#import "DrawingUtensilsTrayView.h"
#import "DrawingBoardView.h"
#import "DrawingBoardShadowView.h"
#import "BrushSizePopOverVC.h"
#import "BrushOpacityPopOverVC.h"
#import "FaceAnimationsPopOverVC.h"
#import "NoAnimatedImagesPopOverVC.h"
#import "MyDrawingsVC.h"
#import "SavePopOverVC.h"

@interface GigilFacesDrawingVC() <BrushSizePopOverViewControllerDelegate, BrushOpacityPopOverViewControllerDelegate, FaceAnimationPopOverViewControllerDelegate, SavePopOverViewControllerDelegate>

//UI Navigational Controller
@property (weak, nonatomic) IBOutlet UIBarButtonItem *myDrawingsButton;

// Colors
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *colorButtons;
@property (strong, nonatomic) NSArray *colorChoices; // Of UIColor
@property (strong, nonatomic) UIColor *selectedColor;
@property (weak, nonatomic) IBOutlet UIButton *selectedColorButton;

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
@property (nonatomic, strong) UIPopoverController *saveImagesPopover;

// Play Animation Button
@property (weak, nonatomic) IBOutlet UIButton *playAnimationButton;
@property (nonatomic) BOOL playButtonPressed;

// Clear Screen Button
@property (weak, nonatomic) IBOutlet UIButton *clearScreenButton;

// Add Face Animations Button
@property (weak, nonatomic) IBOutlet UIButton *addFaceAnimationsButton;

// Grey background (when user clicks play button)
@property (strong, nonatomic) UIView *greyBackground;

// Undo & Redo Mistakes Button
@property (weak, nonatomic) IBOutlet UIButton *undoMistakesButton;
@property (weak, nonatomic) IBOutlet UIButton *redoMistakesButton;

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

- (IBAction)saveImage:(UIButton *)sender {
    SavePopOverVC *saveImagesVC = [[SavePopOverVC alloc]
                                                   initWithNibName:@"SavePopOverVC" bundle:nil];
    saveImagesVC.drawingTitle = self.drawingBoard.drawingTitle;
    saveImagesVC.delegate = self;
    
    self.saveImagesPopover = [[UIPopoverController alloc] initWithContentViewController:saveImagesVC];
    self.saveImagesPopover.popoverContentSize = CGSizeMake(250, 244);
    [self.saveImagesPopover presentPopoverFromRect:[(UIButton *)sender frame]
                                              inView:self.view
                            permittedArrowDirections:UIPopoverArrowDirectionAny
                                            animated:YES];
}

- (IBAction)redoMistakesButton:(UIButton *)sender {
    [self.drawingBoard redoPaintingMistakes];
}

- (IBAction)undoMistakesButton:(UIButton *)sender {
    [self.drawingBoard undoPaintingMistakes];
}

- (IBAction)playAnimationButtonClicked:(UIButton *)sender {

    int numberOfAnimationViews = [self.drawingBoard getAnimatedViewCount];
    
    // Check to make sure there are animated images on the drawing board
    if (numberOfAnimationViews > 0 || self.playButtonPressed) {
       
        self.playButtonPressed = !self.playButtonPressed;

        // Changed the title of the button when animation starts
        if (self.playButtonPressed) {
            
            //[self.playAnimationButton setTitle:@"Stop Animation" forState:UIControlStateNormal];
            UIImage *pauseButton = [UIImage imageNamed:@"pauseButton.png"];
            [self.playAnimationButton setBackgroundImage:pauseButton forState:UIControlStateNormal];
            
            // Grey out the background
            self.greyBackground = [[UIView alloc] initWithFrame:self.view.bounds];
            [self.view addSubview:self.greyBackground];
            UIColor *greyedBackgroundColor = [UIColor colorWithRed:48 / 255.0 green:46 / 255.0 blue:48 / 255.0 alpha:0.95];
            self.greyBackground.backgroundColor = greyedBackgroundColor;
            
            // Grey out the navigational controller
            [self.navigationController.navigationBar setBarTintColor:greyedBackgroundColor];
            
            // Disable the back button and My Drawings button in the navigational controller
            [self.navigationItem setHidesBackButton:YES animated:YES];
            self.myDrawingsButton.tintColor = [UIColor clearColor];
            self.myDrawingsButton.enabled = NO;
            
            
            // Bring the drawingBoard and pause button in front of the greyed out view
            [self.view bringSubviewToFront:self.drawingBoard];
            [self.view bringSubviewToFront:self.playAnimationButton];
            
            // Disable drawing
            self.drawingBoard.brushSelected = -1;
        }
        
        // Change the title of the button when animation stops
        else {
            
            // Change button background to the play button
            UIImage *playButton = [UIImage imageNamed:@"playButton.png"];
            [self.playAnimationButton setBackgroundImage:playButton forState:UIControlStateNormal];
            
            // Remove the grey background view
            [self.greyBackground removeFromSuperview];
            
            // Reactivate the navigational controller
            [self.navigationController.navigationBar setBarTintColor:[self.colorChoices objectAtIndex:11]];
            
            // Enable the back button in the navigational controller
            [self.navigationItem setHidesBackButton:NO animated:YES];
            self.myDrawingsButton.tintColor = [self.view tintColor];
            self.myDrawingsButton.enabled = YES;

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

- (IBAction)clearScreenSelected:(UIButton *)sender {
    
    // Warn the user that their drawing will disappear forever
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"The Slate is Being Wiped"
                                                    message:@"Your whole drawing will disappear forever. Do you want to continue?"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Yes", nil];
    [alert show];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    // If user clicked yes in alert pop-up, wipe the drawing from the canvas
    if (buttonIndex == 1) {
        
        // Clear the drawing board of painting strokes
        self.drawingBoard.clearCanvas = YES;
        
        // Clear the drawing board of animated images
        [self.drawingBoard clearAnimatedArray];
        
        // Reset play button presssed
        self.playButtonPressed = false;
    }
}

/*  When the user changes the color, update the color selected view with the color */
- (IBAction)colorSelected:(UIButton *)sender {
    UIColor *colorPicked = [self.colorChoices objectAtIndex:sender.tag];
    self.selectedColor = colorPicked;
    self.drawingBoard.brushColor = colorPicked;
    self.selectedColorButton.backgroundColor = colorPicked;
}

/* When the user changes the brush, update the brush background image */
- (IBAction)brushSelected:(UIButton *)sender {
    
    // Get the button that was selected
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
    // Pen brush opacity and size CAN NOT be changed when the pen is selected
    if ([[self.brushSelected objectAtIndex:2] boolValue]) {
        self.chageBrushSizeButton.enabled = NO;
        self.changeBrushOpacityButton.enabled = NO;
    }
    else {
        self.chageBrushSizeButton.enabled = YES;
        self.changeBrushOpacityButton.enabled = YES;
    }
    
    // Disable the size button if the vine brush is enabled. Enable if another brush is selected
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
    
    // Tell the drawing board to add the image
    [self.drawingBoard addFaceAnimation:tag category:category];
}

- (void)savedTitle:(NSString *)drawingTitle {
    
    // Set the title of the navigational controller
    self.navigationController.topViewController.title = drawingTitle;
    self.drawingBoard.drawingTitle = drawingTitle;
}

- (void)doneButton {
    [self.saveImagesPopover dismissPopoverAnimated:YES];
}

- (void)savePictureToCameraRoll {
    [self.drawingBoard saveImageToCameraRoll];
    [self.saveImagesPopover dismissPopoverAnimated:YES];
}

#pragma mark - View Will Disappear / Appear

/*  Save the drawing board image when the user exits the view */
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.drawingBoard saveImage];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - NSNotifications

/*  Save the drawing board image when user clicks home button */
-(void)appWillResignActive:(NSNotification*)note {
    [self.drawingBoard saveImage];
}

/* Save the drawing board image when the app terminates */
-(void)appWillTerminate:(NSNotification*)note {
    [self.drawingBoard saveImage];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillTerminateNotification object:nil];
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
        
    // Add a white rectangle behind the drawing utensils
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
    
    // Init brush size
    self.brushSize = 40.0;
    self.brushOpacity = 1.0;
    
    // Init play button
    self.playButtonPressed = false;
    
    // Register for notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillTerminate:) name:UIApplicationWillTerminateNotification object:nil];
    
    // Init the drawing board
    self.drawingBoard.savedDataIndex = self.savedDataIndex;
    self.drawingBoard.brushSize = self.brushSize;
    self.drawingBoard.brushOpacity = self.brushOpacity;
    
    // Set title of navigational view
    self.navigationController.topViewController.title = self.drawingBoard.drawingTitle;
    
    //Selected Color button gets outline
    UIColor *dkGray = [UIColor colorWithRed:28 / 255.0 green:28 / 255.0 blue:28 / 255.0 alpha:1.0];
    [[self.selectedColorButton layer] setBorderWidth:5.0];
    [[self.selectedColorButton layer] setBorderColor:[dkGray CGColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
