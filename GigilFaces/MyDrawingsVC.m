//
//  MyDrawingsVC.m
//  GigilFaces
//
//  Created by Nicole on 8/28/14.
//  Copyright (c) 2014 nicole. All rights reserved.
//

#import "MyDrawingsVC.h"
#import "SaveDrawingBoard.h"
#import "GigilFacesDrawingVC.h"
#import "CancelButtonView.h"

@interface MyDrawingsVC () 

// Save Image
@property (nonatomic, retain) NSString *dataFilePath;
@property (strong, nonatomic) NSArray *savedImages;

// Cells
@property (nonatomic) int cellIndex;

// Edit Cell Mode
@property (nonatomic) BOOL deleteDrawingMode;

// Segmented Control
@property (weak, nonatomic) IBOutlet UISegmentedControl *editModeSegmentControl;

@end

@implementation MyDrawingsVC  {
    // Queue for saving images
    dispatch_queue_t saveDataQueue;
}

#pragma mark - Initialization

/**
 *  Initialize the titles of the images.
 *
 *  @return An array of Strings
 */
- (NSMutableArray *)myDrawingTitles {
    if (!_myDrawingTitles) _myDrawingTitles = [[NSMutableArray alloc] init];
    return _myDrawingTitles;
}

/**
 *  Initialize the images (Drawings are saved as images).
 *
 *  @return An array of UIImages
 */
- (NSMutableArray *)myDrawingImages {
    if (!_myDrawingImages) _myDrawingImages = [[NSMutableArray alloc] init];
    return _myDrawingImages;
}

#pragma mark - Add Image

/**
 *  Add an image to the myDrawingImages array.
 *
 *  @param image
 *      An drawing image.
 */
- (void)addImage:(UIImage *)image {
    [self.myDrawingImages addObject:image];
}

#pragma mark - Segmented Control

/**
 *  The segmented controller allows the user to choose between edit and delete mode.
 *  If delete is selected, each cell gets a red delete button. If edit
 *  mode is selected, the delete buttons are removed from the cells.
 *
 *  @param sender UISegmentedControl
 */
- (IBAction)chooseEditModeSegementControll:(UISegmentedControl *)sender {
    // If user selects edit mode, remove the delete buttons from the cells
    if (sender.selectedSegmentIndex == 0) {
        self.deleteDrawingMode = false;
        [self.collectionView reloadData];
    }
    // If users selects delete mode, add the delete buttons to the cells
    if (sender.selectedSegmentIndex == 1) {
        self.deleteDrawingMode = true;
        [self.collectionView reloadData];
    }
}

#pragma mark - Segue

/**
 *  When user clicks on a cell in edit mode, the drawing board will appear with the selected drawing.
 *
 *  @param segue  UIStoryboardSegue
 *  @param sender
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Segue to the new drawing board
    if ([segue.identifier isEqualToString:@"UploadOldDrawing"]){
        if ([segue.destinationViewController isKindOfClass:[GigilFacesDrawingVC class]]) {
            GigilFacesDrawingVC *newDrawingBoard = (GigilFacesDrawingVC *)segue.destinationViewController;
            
            // Open the selected image in the drawing board
            [newDrawingBoard setSavedDataIndex:self.cellIndex];
        }
    }
}

#pragma mark - UICollectionViewDataSource

/**
 *  Number of sections in the collection view is 1.
 *
 *  @param collectionView
 *
 *  @return The number of sections in the collection view.
 */
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

/**
 *  Number of items in the section.
 *
 *  @param collectionView
 *  @param section
 *
 *  @return The number of drawings saved by the user.
 */
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.myDrawingImages count];
}


/**
 *  Create a cell for each drawing.
 *
 *  @param collectionView
 *  @param indexPath
 *
 *  @return UICollectionViewCell
 */
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // Create a cell with the format of the MyDrawingCVCell (in the storyboard)
    MyDrawingCVCell *myCell = [collectionView
                                    dequeueReusableCellWithReuseIdentifier:@"MyCell"
                                    forIndexPath:indexPath];
    
    // Get the image for the cell
    UIImage *image;
    long row = [indexPath row];
    image = self.myDrawingImages[row];
    myCell.cellImage.image = image;
    
    // Get the label for the cell
    [myCell.cellTitle setText:[self.myDrawingTitles objectAtIndex:row]];
    
    // If in delete mode, add a delete button to each cell
    if (self.deleteDrawingMode) {
        [myCell deleteMode:true];
    }
    // If in edit mode, remove the red delete button from each cell
    else {
        [myCell deleteMode:false];
    }
    
    return myCell;
}

#pragma mark -  UICollectionView Flow Layout Delegate

/**
 *  Determine the size of the cells
 *
 *  @param collectionView
 *  @param collectionViewLayout
 *  @param indexPath
 *
 *  @return <#return value description#>
 */
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize cellSize = CGSizeMake(231, 207);
    return cellSize;
}

/**
 *  Decide what to do when the user clicks on a cell.
 *  If in edit mode, open the drawing in the drawing board.
 *  If in delete mode, delete the drawing from the saved data.
 *
 *  @param collectionView
 *  @param indexPath      Index path of the cell that the user clicked.
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // Get the cell that the user clicked on
    self.cellIndex = (int)[indexPath row];

    // If in edit mode, segue to the drawing board.
    if (!self.deleteDrawingMode) {
        [self performSegueWithIdentifier:@"UploadOldDrawing" sender:self];
    }
    
    // If in delete mode: Ask the user first if they want to delete the drawing, then delete the drawing that was clicked
    else {
        
        // Warn the user that their drawing will disappear forever
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Deleting Drawing"
                                                        message:@"Your drawing will disappear forever. Do you want to continue?"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Yes", nil];
        [alert show];
    }
}

/**
 *  Alert that pops up when user clicks on a cell in delete mode. If user decides to delete drawing, the image
 *  is deleted from the saved data.
 *
 *  @param alertView   UIAlertView.
 *  @param buttonIndex Index of the button that the user clicked.
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    // If user clicked yes, delete the drawing from the list
    if (buttonIndex == 1) {
        [self.collectionView performBatchUpdates:^ {
            NSArray *selectedItemIndexPath = [self.collectionView indexPathsForSelectedItems];
            [self deleteItemsFromDataSourceAtIndexPaths:selectedItemIndexPath];
            [self.collectionView deleteItemsAtIndexPaths:selectedItemIndexPath];
        } completion:nil];
    }
}

/**
 *  Delete selected drawing from saved data.
 *
 *  @param itemPaths Index path of the drawing to be deleted.
 */
-(void)deleteItemsFromDataSourceAtIndexPaths:(NSArray *)itemPaths {
    
    // Get the index path of the drawing to be deleted
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
    for (NSIndexPath *itemPath in itemPaths) {
        [indexSet addIndex:itemPath.row];
    }
    
    // Remove the drawing from the saved data
    [self.myDrawingImages removeObjectsAtIndexes:indexSet];
    [self deleteData:[indexSet firstIndex]];
}

#pragma mark - Save Data

#define FILE_NAME   @"Saved Final Image"

/**
 *  Delete the drawing from the saved data.
 *
 *  @param index Index path of the drawing to be deleted.
 */
- (void)deleteData:(NSUInteger)index {
        
    // Queue allows user to switch views quickly while the data is saved
     dispatch_async(saveDataQueue, ^{
        
        NSFileManager *fm = [NSFileManager defaultManager];
        
        // Get datapath for the file
        self.dataFilePath = [[self getPathToDocumentsDir] stringByAppendingPathComponent:FILE_NAME];
        BOOL fileExists = [fm fileExistsAtPath:self.dataFilePath];
        
        // Delete the image if the file exists
        if (fileExists == YES) {
            
            // Delete the image from the saved data
            NSMutableArray *temp = [[NSMutableArray alloc] initWithArray:self.savedImages];
            [temp removeObjectAtIndex:index];
            [NSKeyedArchiver archiveRootObject:temp toFile:self.dataFilePath];
            
            // Update savedImages
            self.savedImages = [[NSArray alloc] initWithArray:temp];
        }
    });
}

#pragma mark - NSCoding

/**
 *  Get the path to where the saved data is stored.
 *
 *  @return The full path to the saved data file.
 */
- (NSString *)getPathToDocumentsDir {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    
    // Return the full path to sandbox's Documents directory
    return documentsDir;
}

#pragma mark - View Did Appear

/**
 *  Load data when the view first appears.
 *
 *  @param animated
 */
- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    // Get the location of the file
    self.dataFilePath = [[self getPathToDocumentsDir] stringByAppendingPathComponent:FILE_NAME];
    
    // Get the stored data
    NSArray *allData = [NSKeyedUnarchiver unarchiveObjectWithFile:self.dataFilePath];
    self.savedImages = [[NSArray alloc] initWithArray:allData];

    // Empty the array of images
    [self.myDrawingImages removeAllObjects];
    
    // Empty the array of titlles
    [self.myDrawingTitles removeAllObjects];
    
    // Add the new images
    for (SaveDrawingBoard *board in allData) {
        if (board != nil) {
            [self.myDrawingImages addObject:board.finalSmallImage];
            [self.myDrawingTitles addObject:board.finalImageTitle];
            [self.collectionView reloadData];
        }
    }
}

/**
 *  Memory Warning - Default
 */
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setup

/**
 *  Call common init when view first loads.
 *
 *  @param aDecoder
 *
 *  @return id
 */
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
        [self commonInit];
    }
    return self;
}

/**
 *  Call common init when view first loads.
 *
 *  @param nibNameOrNil
 *  @param nibBundleOrNil
 *
 *  @return id
 */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self commonInit];
    }
    return self;
}

/**
 *  Initialize the queue for saving data when the view first appears.
 */
- (void)commonInit {
    // Initialize queue for saving data
    saveDataQueue = dispatch_queue_create("saveDataQueue", NULL);
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
