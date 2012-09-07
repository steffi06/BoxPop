//
//  GameViewController.m
//  BoxPop
//
//  Created by Stephanie Shupe on 9/5/12.
//  Copyright (c) 2012 burnOffBabes. All rights reserved.
//

#import "GameViewController.h"
#import "GameView.h"
#import "Box.h"
#import <QuartzCore/QuartzCore.h>

@interface GameViewController ()

@property (strong, nonatomic) NSMutableArray *boxArray;
@property (strong, nonatomic) NSArray *colors;
@property (strong, nonatomic)  GameView *gameView;
@property (strong, nonatomic) NSMutableDictionary *layersForBoxes;

@end

@implementation GameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.boxArray = [NSMutableArray new];
        self.layersForBoxes = [NSMutableDictionary new];
        self.colors = @[ [UIColor orangeColor], [UIColor purpleColor], [UIColor yellowColor], [UIColor cyanColor] ];
        
        for ( int i = 0; i < 8 ; i++ ) {
            NSMutableArray *boxColumn = [NSMutableArray new];
            
            for ( int j = 0 ; j < 12 ; j++ ) {
                Box *box = [Box new];
                box.color = [self.colors objectAtIndex: arc4random() % self.colors.count ];
                [boxColumn addObject:box];
            }
            
            [self.boxArray addObject:boxColumn];
        }
    }
    return self;
}

- (void)loadView
{
    self.gameView = [[GameView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view = self.gameView;
    
    self.gameView.columnCount = self.boxArray.count;
    self.gameView.gameVC = self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self generateBoxLayers];

}

- (void)generateBoxLayers
{
    self.view.layer.sublayers = nil;
    for (int i = 0; i < self.boxArray.count; i++) {
        NSMutableArray *columnArray = [self.boxArray objectAtIndex: i];
        
        for (int j = 0; j < columnArray.count ; j++) {
            Box *box = [columnArray objectAtIndex: j];
            CALayer *layer = [self.gameView makeBoxLayersWithColumnIndex:i withBoxIndex:j andBoxColor:box.color];
            [self.layersForBoxes setObject:layer forKey:[NSValue valueWithNonretainedObject: box]];
        }
    }
}

- (void)blockTouchedAtColumnIndex:(int)columnIndex andRowIndex:(int)rowIndex
{
    if (![self boxExistsInColumnIndex:columnIndex andRowIndex:rowIndex]) return;

    Box *selectedBox = [self boxAtColumnIndex:columnIndex andRowIndex:rowIndex];

    NSMutableSet *boxesLocToDelete = [NSMutableSet new];
    [boxesLocToDelete addObject:@[ @(columnIndex), @(rowIndex), selectedBox ]];
    
    while (YES) {
        NSMutableArray *addBoxesToSet = [self findBoxesToDelete:boxesLocToDelete];
        if (addBoxesToSet.count == 0) {
            break;
        }
        
        [boxesLocToDelete addObjectsFromArray:addBoxesToSet];
    }
    
    if (boxesLocToDelete.count > 1) {
        for (NSArray *boxLocation in boxesLocToDelete) {
            int columnIndex = [[boxLocation objectAtIndex:0] intValue];
            int rowIndex = [[boxLocation objectAtIndex:1] intValue];
            Box *boxToDelete = [boxLocation objectAtIndex:2];

            [[self.boxArray objectAtIndex:columnIndex] removeObject:boxToDelete];
            [self.gameView popBoxGivenLayer: [self.layersForBoxes objectForKey:
                                              [NSValue valueWithNonretainedObject: boxToDelete]]];
        }
    }
    [self generateBoxLayers];
    
    
}

- (NSMutableArray *)findBoxesToDelete: (NSMutableSet *)boxesToDelete
{
    NSMutableArray *addBoxesToSet = [NSMutableArray new];
    for (NSArray *boxLocation in boxesToDelete) {
        int columnIndex = [[boxLocation objectAtIndex:0] intValue];
        int rowIndex = [[boxLocation objectAtIndex:1] intValue];
        Box *boxToDelete = [boxLocation objectAtIndex:2];
    

        NSArray *relativePosToCheck = @[ @[@-1, @0], @[@1, @0], @[@0, @-1], @[@0, @1] ];
        
        for (NSArray *posArray in relativePosToCheck ) {
            int columnToCheck = columnIndex + [[posArray objectAtIndex:0] intValue];
            int rowToCheck = rowIndex + [[posArray objectAtIndex:1] intValue];
            
            if (![self boxExistsInColumnIndex:columnToCheck andRowIndex:rowToCheck]) continue;
            
            Box *boxToCheck = [self boxAtColumnIndex:columnToCheck andRowIndex:rowToCheck];
            
            if (boxToCheck.color == boxToDelete.color) {
                NSArray *boxEntry = @[ @(columnToCheck), @(rowToCheck), boxToCheck ];
                if(![boxesToDelete containsObject:boxEntry])
                    [addBoxesToSet addObject:boxEntry];
            }
        }
    }
    return addBoxesToSet;
}

- (Box *)boxAtColumnIndex: (int)columnIndex andRowIndex: (int)rowIndex
{
    return [[self.boxArray objectAtIndex:columnIndex] objectAtIndex:rowIndex];
}

- (BOOL)boxExistsInColumnIndex: (int)columnIndex andRowIndex: (int)rowIndex
{
    if (columnIndex < self.boxArray.count && columnIndex >= 0) {
        NSMutableArray *columnArray = [self.boxArray objectAtIndex:columnIndex];
        if (rowIndex < columnArray.count && rowIndex >= 0) return YES;
    }
    return NO;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
