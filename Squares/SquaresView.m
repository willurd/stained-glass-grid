//
//  SquaresView.m
//  Squares
//
//  Created by William Bowers on 6/12/13.
//  Copyright (c) 2013 William Bowers. All rights reserved.
//

#import "SquaresView.h"
#import "Range.h"

@implementation SquaresView

static NSString * const ModuleName = @"net.williambowers.Squares";

- (id)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
    self = [super initWithFrame:frame isPreview:isPreview];
    
    if (self) {
        [self setAnimationTimeInterval:1/30.0];
        
        [self.settings registerDefaults:self.defaults];
        
        NSUInteger padding = [self.settings integerForKey:@"padding"];
        NSUInteger cols = [self.settings integerForKey:@"columns"];
        NSUInteger rows = [self.settings integerForKey:@"rows"];
        float minTimeBetweenUpdates = [self.settings floatForKey:@"minTimeBetweenUpdates"];
        float maxTimeBetweenUpdates = [self.settings floatForKey:@"maxTimeBetweenUpdates"];
        float minTransitionTime = [self.settings floatForKey:@"minTransitionTime"];
        float maxTransitionTime = [self.settings floatForKey:@"maxTransitionTime"];
        
        formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [formatter setFormat:@"##0.0"];
        
        // Add the cells
        cells = [[NSMutableArray alloc] init];
        
        NSSize size = self.bounds.size;
        NSSize bounds = NSMakeSize(size.width - padding, size.height - padding);
        NSUInteger width  = floor((bounds.width  - (padding * cols)) / cols);
        NSUInteger height = floor((bounds.height - (padding * rows)) / rows);
        NSUInteger extraY = 0;
        
        NSUInteger leftoverWidth = bounds.width - (padding + (cols * width));
        NSUInteger leftoverHeight = bounds.height - (padding + (rows * height));
        
        for (int row = 0; row < rows; row++) {
            NSUInteger extraX = 0;
            NSUInteger extraHeight = (row < leftoverHeight) ? 1 : 0;
            
            for (int col = 0; col < cols; col++) {
                NSUInteger x = col * width  + (padding * (col + 1)) + extraX;
                NSUInteger y = row * height + (padding * (row + 1)) + extraY;
                NSUInteger extraWidth = (col < leftoverWidth) ? 1 : 0;
                
                [cells addObject:[[Cell alloc] initWithRect:NSMakeRect(x, y, width + extraWidth, height + extraHeight)
                                         timeBetweenUpdates:MakeRange(minTimeBetweenUpdates, maxTimeBetweenUpdates)
                                             transitionTime:MakeRange(minTransitionTime, maxTransitionTime)]];
                
                extraX += extraWidth;
            }
            
            extraY += extraHeight;
        }
        
        lastUpdate = [NSDate date];
    }
    
    return self;
}


- (ScreenSaverDefaults*)settings
{
    return [ScreenSaverDefaults defaultsForModuleWithName:ModuleName];;
}

- (NSDictionary*)defaults
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"default", @"preset",
            @"1", @"padding",
            @"30", @"columns",
            @"30", @"rows",
            @"1", @"minTimeBetweenUpdates",
            @"4", @"maxTimeBetweenUpdates",
            @"2", @"minTransitionTime",
            @"5", @"maxTransitionTime",
            nil];
}

- (void)startAnimation
{
    [super startAnimation];
}

- (void)stopAnimation
{
    [super stopAnimation];
}

- (void)drawRect:(NSRect)rect
{
    [super drawRect:rect];
    
    for (Cell *cell in cells) {
        [cell draw];
    }
}

- (void)animateOneFrame
{
    float seconds = fabs([lastUpdate timeIntervalSinceNow]);
    
    for (Cell *cell in cells) {
        [cell updateWithElapsedTime:seconds];
    }
    
    lastUpdate = [NSDate date];
    
    [self setNeedsDisplay:YES];
}

- (BOOL)hasConfigureSheet
{
    return YES;
}

- (NSWindow*)configureSheet
{
    if (!configSheet &&
        ![NSBundle loadNibNamed:@"ConfigureSheet" owner:self]) {
        NSLog(@"Failed to load configure sheet.");
        NSBeep();
        return nil;
    }
    
    [minTimeBetweenUpdatesLabel setFormatter:formatter];
    [maxTimeBetweenUpdatesLabel setFormatter:formatter];
    [minTransitionTimeLabel setFormatter:formatter];
    [maxTransitionTimeLabel setFormatter:formatter];
    
    ScreenSaverDefaults *settings = self.settings;
    
    [self resetSheetWithPadding:[settings integerForKey:@"padding"]
                        columns:[settings integerForKey:@"columns"]
                           rows:[settings integerForKey:@"rows"]
          minTimeBetweenUpdates:[settings floatForKey:@"minTimeBetweenUpdates"]
          maxTimeBetweenUpdates:[settings floatForKey:@"maxTimeBetweenUpdates"]
              minTransitionTime:[settings floatForKey:@"minTransitionTime"]
              maxTransitionTime:[settings floatForKey:@"maxTransitionTime"]];
    
    return configSheet;
}

- (void)resetSheetWithPadding:(NSUInteger)padding
                      columns:(NSUInteger)columns
                         rows:(NSUInteger)rows
        minTimeBetweenUpdates:(float)minTimeBetweenUpdates
        maxTimeBetweenUpdates:(float)maxTimeBetweenUpdates
            minTransitionTime:(float)minTransitionTime
            maxTransitionTime:(float)maxTransitionTime
{
    // Fields.
    [paddingOption setIntegerValue:padding];
    [columnsOption setIntegerValue:columns];
    [rowsOption setIntegerValue:rows];
    [minTimeBetweenUpdatesOption setFloatValue:minTimeBetweenUpdates];
    [maxTimeBetweenUpdatesOption setFloatValue:maxTimeBetweenUpdates];
    [minTransitionTimeOption setFloatValue:minTransitionTime];
    [maxTransitionTimeOption setFloatValue:maxTransitionTime];
    
    // Labels.
    [paddingLabel setIntegerValue:padding];
    [columnsLabel setIntegerValue:columns];
    [rowsLabel setIntegerValue:rows];
    [minTimeBetweenUpdatesLabel setFloatValue:minTimeBetweenUpdates];
    [maxTimeBetweenUpdatesLabel setFloatValue:maxTimeBetweenUpdates];
    [minTransitionTimeLabel setFloatValue:minTransitionTime];
    [maxTransitionTimeLabel setFloatValue:maxTransitionTime];
}

- (IBAction)okClick:(id)sender
{
    ScreenSaverDefaults *settings = self.settings;
    
    [settings setInteger:[paddingOption integerValue] forKey:@"padding"];
    [settings setInteger:[columnsOption integerValue] forKey:@"columns"];
    [settings setInteger:[rowsOption integerValue] forKey:@"rows"];
    [settings setFloat:[minTimeBetweenUpdatesOption floatValue] forKey:@"minTimeBetweenUpdates"];
    [settings setFloat:[maxTimeBetweenUpdatesOption floatValue] forKey:@"maxTimeBetweenUpdates"];
    [settings setFloat:[minTransitionTimeOption floatValue] forKey:@"minTransitionTime"];
    [settings setFloat:[maxTransitionTimeOption floatValue] forKey:@"maxTransitionTime"];
    
    [settings synchronize];
    
    [[NSApplication sharedApplication] endSheet:configSheet];
}

- (IBAction)cancelClick:(id)sender
{
    [[NSApplication sharedApplication] endSheet:configSheet];
}

- (IBAction)defaultsClick:(id)sender
{
    NSDictionary *defaults = self.defaults;
    
    [self resetSheetWithPadding:[[defaults valueForKey:@"padding"] integerValue]
                        columns:[[defaults valueForKey:@"columns"] integerValue]
                           rows:[[defaults valueForKey:@"rows"] integerValue]
          minTimeBetweenUpdates:[[defaults valueForKey:@"minTimeBetweenUpdates"] floatValue]
          maxTimeBetweenUpdates:[[defaults valueForKey:@"maxTimeBetweenUpdates"] floatValue]
              minTransitionTime:[[defaults valueForKey:@"minTransitionTime"] floatValue]
              maxTransitionTime:[[defaults valueForKey:@"maxTransitionTime"] floatValue]];
}

@end
