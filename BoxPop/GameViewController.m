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

@end

@implementation GameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.boxArray = [NSMutableArray new];
        self.colors = @[ [UIColor redColor], [UIColor blueColor], [UIColor yellowColor], [UIColor greenColor] ];
        
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
    self.view = [[GameView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    ((GameView *)self.view).columnCount = self.boxArray.count;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    for (int i = 0; i < self.boxArray.count; i++) {
        NSMutableArray *columnArray = [self.boxArray objectAtIndex: i];
        
        for (int j = 0; j < columnArray.count ; j++) {
            Box *box = [columnArray objectAtIndex: j];
            [(GameView *)self.view makeBoxLayersWithColumnIndex:i withBoxIndex:j andBoxColor:box.color];
        }
    }
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
