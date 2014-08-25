//
//  BrushSizePopOverVC.m
//  GigilFaces
//
//  Created by Nicole on 8/22/14.
//  Copyright (c) 2014 nicole. All rights reserved.
//

#import "BrushSizePopOverVC.h"
#import "BrushSizeView.h"

@interface BrushSizePopOverVC ()
@property (weak, nonatomic) IBOutlet UISlider *brushSizeSlider;
@property (weak, nonatomic) IBOutlet BrushSizeView *brushSizePicture;
@end

@implementation BrushSizePopOverVC

#pragma mark - Buttons

- (IBAction)sliderPositionChanged:(UISlider *)sender {
    self.brushSizePicture.brushSize = sender.value;
    [self.delegate sliderValueChanged:sender.value];
}

#pragma mark - Set Up

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
    
    self.brushSizeSlider.value = self.brushSize;
    self.brushSizeSlider.maximumValue = 200;
    self.brushSizeSlider.minimumValue = 3;
    
    self.brushSizePicture.brushSize = self.brushSize;
    self.brushSizePicture.brushColor = self.brushColor;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
