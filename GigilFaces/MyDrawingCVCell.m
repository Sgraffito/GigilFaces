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

// Selected cell color
@property (strong, nonatomic) UIColor *greenColor;

@end

@implementation MyDrawingCVCell

#pragma mark - Initialization

/**
 *  Initialize the selected cell color.
 *
 *  @return UIColor of the selected cell
 */
- (UIColor *)greenColor {
    if (!_greenColor) _greenColor = [UIColor colorWithRed:0 / 255.0 green:166 / 255.0 blue:80 / 255.0 alpha:1.0];
    return _greenColor;
}

#pragma mark - Reuse Cell

/**
 *  When user scrolls, clear the cancel button. 
 *  If this is not done, the button will be redrawn repeatedly, which causes
 *  visible overlap in the transparent parts of the button.
 */
- (void)prepareForReuse {
    [super prepareForReuse];
    // Clear the delete button so it can be redrawn again
    if (self.inDeleteMode) {
        [self.cancelButton removeFromSuperview];
        self.cancelButton = nil;
    }
}

#pragma mark - Delete Button

/**
 *  Add a delete button to each cell if the user enters delete mode.
 *  When the user exits delete mode, remove the delete button from
 *  each cell.
 *
 *  @param mode
 *      If mode is true, then add a delete button to each cell
 *      If mode is false, then remove the delete buttons from the cells
 */
- (void)deleteMode:(BOOL)mode {
    
    // Set the delete mode
    self.inDeleteMode = mode;
    
    // Add the delete button to each cell if user selects delete mode
    if (self.inDeleteMode) {
        
        // Size of delete button
        float deleteButtonSize = 25;
        
        // Location of the delete button
        CGRect deleteButtonFrame = CGRectMake((self.frame.size.width / 6) * 5.24,
                                              (self.frame.size.width / 49),
                                              deleteButtonSize,
                                              deleteButtonSize);
        
        // Add a delete button to the view
        self.cancelButton = [[CancelButtonView alloc] initWithFrame:deleteButtonFrame];
        [self addSubview:self.cancelButton];
        self.cancelButton.backgroundColor = [UIColor clearColor];
    }
    
    // If the user selectes edit mode, remove the delete button from the cell
    else {
        [self.cancelButton removeFromSuperview];
        self.cancelButton = nil;
    }
}

#pragma mark - Selected Cell

/**
 *  Override the selected method
 *
 *  @param selected 
 *      If the cell is selected, change the border color to the selected cell color.
 */
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
