//
//  SquaresView.h
//  Squares
//
//  Created by William Bowers on 6/12/13.
//  Copyright (c) 2013 William Bowers. All rights reserved.
//

#import <ScreenSaver/ScreenSaver.h>
#import "Cell.h"

@interface SquaresView : ScreenSaverView <NSMenuDelegate> {
    IBOutlet NSPanel *configSheet;
    IBOutlet NSSlider *paddingOption;
    IBOutlet NSSlider *columnsOption;
    IBOutlet NSSlider *rowsOption;
    IBOutlet NSSlider *minTimeBetweenUpdatesOption;
    IBOutlet NSSlider *maxTimeBetweenUpdatesOption;
    IBOutlet NSSlider *minTransitionTimeOption;
    IBOutlet NSSlider *maxTransitionTimeOption;
    
    IBOutlet NSTextField *paddingLabel;
    IBOutlet NSTextField *columnsLabel;
    IBOutlet NSTextField *rowsLabel;
    IBOutlet NSTextField *minTimeBetweenUpdatesLabel;
    IBOutlet NSTextField *maxTimeBetweenUpdatesLabel;
    IBOutlet NSTextField *minTransitionTimeLabel;
    IBOutlet NSTextField *maxTransitionTimeLabel;
    
    NSNumberFormatter *formatter;
    
    NSMutableArray *cells;
    NSDate *lastUpdate;
}

@end
