//
//  GameView.h
//  BoxPop
//
//  Created by Stephanie Shupe on 9/5/12.
//  Copyright (c) 2012 burnOffBabes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameView : UIView

@property (nonatomic) int columnCount;

-(void)makeBoxLayersWithColumnIndex: (int)i withBoxIndex: (int)j andBoxColor: (UIColor *)boxColor;

@end
