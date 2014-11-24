 //
//  MyDrawingCVCell.m
//  GigilFaces
//
//  Created by Nicole on 8/28/14.
//  Copyright (c) 2014 nicole. All rights reserved.
//

#import "MyDrawingCVCell.h"

@interface MyDrawingCVCell()

// Cancel button
@property (strong, nonatomic) CancelButtonView *cancelButton;
@property (strong, nonatomic) UIButton *deleteButton;
@property (nonatomic) BOOL inDeleteMode;
@property (nonatomic) int count;

// Select cell color
@property (strong, nonatomic) UIColor *greenColor;

@end

@implementation MyDrawingCVCell

#pragma mark - Initialization

- (UIColor *)greenColor {
    if (!_greenColor) _greenColor = [UIColor colorWithRed:0 / 255.0 green:166 / 255.0 blue:80 / 255.0 alpha:1.0];
    return _greenColor;
}

#pragma mark - Reuse Cell

- (void)prepareForReuse {
    [super prepareForReuse];
    
    // Clear the delete button so it can be redrawn again
    // Prevents layers of buttons being drawn when user is scrolling
    // Causes buildup of transparent shadows
    if (self.inDeleteMode) {
        [self.cancelButton removeFromSuperview];
        self.cancelButton = nil;
        
        //[self.deleteButton removeFromSuperview];
        //self.deleteButton = nil;
    }
}

#pragma mark - Setup

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
           }
    return self;
}

#pragma mark - Gesture

- (void)deleteMode:(BOOL)mode {
    
    self.inDeleteMode = mode;
    
    // Add the delete button if user enters delete mode
    if (self.inDeleteMode) {
        
        const int deleteButtonSize = 25;
        
        // Location of the cancel button
        CGRect deleteButtonFrame = CGRectMake((self.frame.size.width / 6) * 5.25,
                                              (self.frame.size.width / 50),
                                              deleteButtonSize,
                                              deleteButtonSize);
        
        // Add a cancel button to the view
        self.cancelButton = [[CancelButtonView alloc] initWithFrame:deleteButtonFrame];
        [self addSubview:self.cancelButton];
        self.cancelButton.backgroundColor = [UIColor clearColor];
        
        // Delete Button stuff
//        self.deleteButton = [[UIButton alloc] initWithFrame:deleteButtonFrame];
//        self.deleteButton.backgroundColor = [UIColor clearColor];
//        [self.deleteButton setImage:[UIImage imageNamed:@"redoButton.png"] forState:UIControlStateNormal];
//        
//        [self.deleteButton addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:self.deleteButton];
    }
    
    // Remove the delete button if user is in edit mode
    else {
        [self.cancelButton removeFromSuperview];
        self.cancelButton = nil;
        
//        [self.deleteButton removeFromSuperview];
//        self.deleteButton = nil;
    }
}

/* Override the selected method */
- (void)setSelected:(BOOL)selected {
    
    self.backgroundColor = selected ? self.greenColor : [UIColor whiteColor];
    [super setSelected:selected];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
}
*/

@end
