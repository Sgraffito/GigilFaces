//
//  BrushOpacityPopOverVC.m
//  GigilFaces
//
//  Created by Nicole on 8/22/14.
//  Copyright (c) 2014 nicole. All rights reserved.
//

#import "BrushOpacityPopOverVC.h"
#import "BrushOpacityView.h"

@interface BrushOpacityPopOverVC ()
@property (weak, nonatomic) IBOutlet UISlider *brushOpacitySlider;
@property (weak, nonatomic) IBOutlet BrushOpacityView *brushOpacityPicture;
@end

@implementation BrushOpacityPopOverVC

#pragma mark - Buttons

- (IBAction)sliderPositionChanged:(UISlider *)sender {
    self.brushOpacityPicture.opacity = sender.value;
    [self.delegate opacityValueChanged:sender.value];
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

    self.brushOpacitySlider.value = self.brushOpacity;
    
    // Make sure min and max values are set in the storyboard too! (or else problems will occur)
    self.brushOpacitySlider.minimumValue = 0.2;
    
    self.brushOpacitySlider.maximumValue = 1.0;
    self.brushOpacityPicture.opacity = self.brushOpacity;
    self.brushOpacityPicture.brushColor = self.brushColor;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
