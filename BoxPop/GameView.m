//
//  GameView.m
//  BoxPop
//
//  Created by Stephanie Shupe on 9/5/12.
//  Copyright (c) 2012 burnOffBabes. All rights reserved.
//

#import "GameView.h"
#import <QuartzCore/QuartzCore.h>
#import "Box.h"

@interface GameView()

@property (nonatomic) double boxDimension;

@end


@implementation GameView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setColumnCount:(int)columnCount
{
    _columnCount = columnCount;
    self.boxDimension = self.layer.frame.size.width / self.columnCount;
}

-(void)makeBoxLayersWithColumnIndex: (int)i withBoxIndex: (int)j andBoxColor: (UIColor *)boxColor
{
    CALayer *boxLayer = [[CALayer alloc] init];
    
    boxLayer.position = CGPointMake((0.5 + i) * self.boxDimension, (0.5 + j) * self.boxDimension);
    boxLayer.bounds = CGRectMake(0, 0, self.boxDimension, self.boxDimension);
    boxLayer.backgroundColor = [boxColor CGColor];
    
    boxLayer.shadowColor = [[UIColor blackColor] CGColor];
    boxLayer.shadowOffset = CGSizeMake(0, 0);
    boxLayer.shadowOpacity = 1.0;
    boxLayer.shadowRadius = 4.0;
    
    [self.layer addSublayer:boxLayer];

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    int columnIndex =  touchPoint.x / self.boxDimension;
    int rowIndex = touchPoint.y / self.boxDimension;
    
    // pass to VC method
    // VC to lookup box from boxArray
    
}

@end
