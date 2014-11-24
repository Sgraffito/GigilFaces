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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    /* Create a new drawing */
    if ([segue.identifier isEqualToString:@"New Drawing Segue"]){
        if ([segue.destinationViewController isKindOfClass:[GigilFacesDrawingVC class]]) {
            GigilFacesDrawingVC *newDrawingBoard = (GigilFacesDrawingVC *)segue.destinationViewController;
            [newDrawingBoard setSavedDataIndex:-1];
        }
    }
    /* Go to the UICollectionView */
    else if ([segue.identifier isEqualToString:@"Last Drawing Segue"]){
        if ([segue.destinationViewController isKindOfClass:[GigilFacesDrawingVC class]]) {
            GigilFacesDrawingVC *lastDrawingBoard = (GigilFacesDrawingVC *)segue.destinationViewController;
            [lastDrawingBoard setSavedDataIndex:0];
        }
    }
}

- (void)setFont {
    UIFont *NanumPen = [UIFont fontWithName:@"NanumPen" size:240];
    [self.GigilFacesFont setFont:NanumPen];
    self.GigilFacesFont.textColor = [UIColor whiteColor];
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
    [self setFont];
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
