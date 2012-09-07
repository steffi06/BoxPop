//
//  GameView.h
//  BoxPop
//
//  Created by Stephanie Shupe on 9/5/12.
//  Copyright (c) 2012 burnOffBabes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameViewController.h"

@interface GameView : UIView

@property (nonatomic) int columnCount;
@property (weak) GameViewController *gameVC;

-(CALayer *)makeBoxLayersWithColumnIndex: (int)i withBoxIndex: (int)j andBoxColor: (UIColor *)boxColor;
-(void)popBoxGivenLayer: (CALayer *)layer;

@end
