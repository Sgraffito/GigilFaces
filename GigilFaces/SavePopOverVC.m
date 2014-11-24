//
//  SavePopOverVC.m
//  GigilFaces
//
//  Created by Nicole on 8/29/14.
//  Copyright (c) 2014 nicole. All rights reserved.
//

#import "SavePopOverVC.h"

@interface SavePopOverVC () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *drawingTitleTextField;
@end

@implementation SavePopOverVC

#pragma mark - Camera Roll

- (IBAction)savePictureToCameraRoll:(UIButton *)sender {
    [self.delegate savePictureToCameraRoll];
}

/*  Dismiss the popover when the user clicks on the done button */
- (IBAction)doneButtonClicked:(UIButton *)sender {
    [self.delegate doneButton];
}

#pragma mark - New Drawing

- (IBAction)newDrawing:(UIButton *)sender {
    [self.delegate makeNewDrawing];
}

#pragma mark - Delete Drawing

- (IBAction)deleteDrawing:(UIButton *)sender {
    [self.delegate deleteDrawing];
}

#pragma mark - Dismiss Keyboard

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

#pragma mark - Text Fields

- (IBAction)titleTextFieldChanged:(UITextField *)sender {
    [self.delegate savedTitle:sender.text];
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
    // Do any additional setup after loading the view from its nib.
    
    self.drawingTitleTextField.delegate = self; // Lets you dismiss keyboard when ENTER is pressed
    self.drawingTitleTextField.placeholder = self.drawingTitle;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
