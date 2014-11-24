//
//  FrontPageVC.m
//  GigilFaces
//
//  Created by Nicole on 8/28/14.
//  Copyright (c) 2014 nicole. All rights reserved.
//

#import "FrontPageVC.h"
#import "GigilFacesDrawingVC.h"

@interface FrontPageVC ()
@property (weak, nonatomic) IBOutlet UILabel *GigilFacesFont;
@end

@implementation FrontPageVC

#pragma mark - Segues

/**
 *  Create a new, empty drawing board
 *
 *  @param segue  Push segue to the drawing board
 *  @param sender New drawing button
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Create a new drawing
    // Setting setSavedDataIndex to -1 means to start new drawing
    if ([segue.identifier isEqualToString:@"New Drawing Segue"]){
        if ([segue.destinationViewController isKindOfClass:[GigilFacesDrawingVC class]]) {
            GigilFacesDrawingVC *newDrawingBoard = (GigilFacesDrawingVC *)segue.destinationViewController;
            [newDrawingBoard setSavedDataIndex:-1];
        }
    }
}


#pragma mark - Setup

/**
 *  When view first appears load the font
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Set the speciality font
    // [self setFont];
}

/**
 *  Memory Warning - Default
 */
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Speciality Font
/**
 *  Set the font of the app's Title
 */
//- (void)setFont {
//    UIFont *NanumPen = [UIFont fontWithName:@"NanumPen" size:240];
//    [self.GigilFacesFont setFont:NanumPen];
//    self.GigilFacesFont.textColor = [UIColor whiteColor];
//}


#pragma mark - Navigation
/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
