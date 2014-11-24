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

// Edit Cell
@property (nonatomic) BOOL editMode;

// Segmented Control
@property (weak, nonatomic) IBOutlet UISegmentedControl *editModeSegmentControl;

@end

@implementation MyDrawingsVC  {
    dispatch_queue_t saveDataQueue;
}

#pragma mark - Initialization

- (NSMutableArray *)myDrawingTitles {
    if (!_myDrawingTitles) _myDrawingTitles = [[NSMutableArray alloc] init];
    return _myDrawingTitles;
}

- (NSMutableArray *)myDrawingImages {
    if (!_myDrawingImages) _myDrawingImages = [[NSMutableArray alloc] init];
    return _myDrawingImages;
}

#pragma mark - Add Image

- (void)addImage:(UIImage *)image {
    [self.myDrawingImages addObject:image];
}

#pragma mark - Segmented Control

- (IBAction)chooseEditModeSegementControll:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        self.editMode = false;
        [self.collectionView reloadData];
    }
    if (sender.selectedSegmentIndex == 1) {
        self.editMode = true;
        [self.collectionView reloadData];
    }
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"UploadOldDrawing"]){
        if ([segue.destinationViewController isKindOfClass:[GigilFacesDrawingVC class]]) {
            GigilFacesDrawingVC *newDrawingBoard = (GigilFacesDrawingVC *)segue.destinationViewController;
            [newDrawingBoard setSavedDataIndex:self.cellIndex];
        }
    }
}

#pragma mark - Edit Button

- (IBAction)editDrawingsButton:(UIBarButtonItem *)sender {
    
    self.editMode = !self.editMode;
    [self.collectionView reloadData];
}


#pragma mark - UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.myDrawingImages count];
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
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
    
    if (self.editMode) {
        [myCell deleteMode:true];
    }
    else {
        [myCell deleteMode:false];
    }
    
    return myCell;
}

#pragma mark -  UICollectionView Flow Layout Delegate

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize cellSize = CGSizeMake(231, 207);
    
    return cellSize;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    self.cellIndex = (int)[indexPath row];

    // If in edit mode, go to the drawing that was clicked
    if (!self.editMode) {
        [self performSegueWithIdentifier:@"UploadOldDrawing" sender:self];
    }
    
    // If in delete mode: ask the user first if they want to delete the drawing, then delete the drawing that was clicked
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


-(void)deleteItemsFromDataSourceAtIndexPaths:(NSArray  *)itemPaths
{
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
    for (NSIndexPath *itemPath in itemPaths) {
        [indexSet addIndex:itemPath.row];
    }
    [self.myDrawingImages removeObjectsAtIndexes:indexSet];
    [self deleteData:[indexSet firstIndex]];
}

#pragma mark - Save Data

#define FILE_NAME   @"Saved Final Image"


- (void)deleteData:(NSUInteger)index {
        
    // Allows user to switch views quickly while the data is saved
     dispatch_async(saveDataQueue, ^{
        
        NSFileManager *fm = [NSFileManager defaultManager];
        
        // Get datapath for the file
        self.dataFilePath = [[self getPathToDocumentsDir] stringByAppendingPathComponent:FILE_NAME];
        BOOL fileExists = [fm fileExistsAtPath:self.dataFilePath];
        
        // Save the image if the file exists
        if (fileExists == YES) {
            
            NSMutableArray *temp = [[NSMutableArray alloc] initWithArray:self.savedImages];
            
            [temp removeObjectAtIndex:index];
            
            [NSKeyedArchiver archiveRootObject:temp toFile:self.dataFilePath];
            
            // Update savedImages
            self.savedImages = [[NSArray alloc] initWithArray:temp];
        }
    });
}

#pragma mark - NSCoding

- (NSString *)getPathToDocumentsDir
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    
    // Return the full path to sandbox's Documents directory
    return documentsDir;
}

#pragma mark - View did appear / disappear


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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setup

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    // Initialize queue for saving data
    saveDataQueue = dispatch_queue_create("saveDataQueue", NULL);
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(handleThisNotification:)
//                                                 name:WhateverYouDecideToNameYourNotification
//                                               object:nil];
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
