//
//  Cell.m
//  Squares
//
//  Created by William Bowers on 6/12/13.
//  Copyright (c) 2013 William Bowers. All rights reserved.
//

#import "Cell.h"
#import <ScreenSaver/ScreenSaver.h>

@implementation Cell

- (id)initWithRect:(NSRect)rect_
timeBetweenUpdates:(Range)timeBetweenUpdates_
    transitionTime:(Range)transitionTime_
{
    if (self = [super init]) {
        rect = rect_;
        timeBetweenUpdatesRange = timeBetweenUpdates_;
        transitionTimeRange = transitionTime_;
        path = [NSBezierPath bezierPathWithRect:rect];
        currentColor = [self randomColor];
        nextColor = nil;
        timeUntilUpdate = [self randomInitialUpdateTime];
        isTransitioning = NO;
    }
    
    return self;
}


- (NSColor*)randomColorBetweenMin:(float)min max:(float)max
{
    return [NSColor colorWithCalibratedRed:SSRandomFloatBetween(min, max) / 255
                                      green:SSRandomFloatBetween(min, max) / 255
                                       blue:SSRandomFloatBetween(min, max) / 255
                                      alpha:1];
}

- (NSColor*)randomColor
{
    return [self randomColorBetweenMin:60 max:220];
}

- (NSColor*)randomDarkColor
{
    return [self randomColorBetweenMin:10 max:100];
}

- (NSColor*)randomPastelColor
{
    return [self randomColorBetweenMin:120 max:200];
}

- (NSColor*)color
{
    if (nextColor == nil) {
        return currentColor;
    } else {
        float percent = (transitionTime - timeLeftInTransition) / transitionTime;
        
        return [NSColor colorWithCalibratedRed:currentColor.redComponent   + ((nextColor.redComponent   - currentColor.redComponent)   * percent)
                                         green:currentColor.greenComponent + ((nextColor.greenComponent - currentColor.greenComponent) * percent)
                                          blue:currentColor.blueComponent  + ((nextColor.blueComponent  - currentColor.blueComponent)  * percent)
                                         alpha:1];
    }
}

- (float)randomUpdateTime
{
    return SSRandomFloatBetween(timeBetweenUpdatesRange.min, timeBetweenUpdatesRange.max);
}

- (float)randomInitialUpdateTime
{
    return SSRandomFloatBetween(timeBetweenUpdatesRange.min, timeBetweenUpdatesRange.max) - timeBetweenUpdatesRange.min;
}

- (float)randomTransitionTime
{
    return SSRandomFloatBetween(transitionTimeRange.min, transitionTimeRange.max);
}

- (void)updateWithElapsedTime:(float)seconds
{
    if (isTransitioning) {
        timeLeftInTransition -= seconds;
        
        if (timeLeftInTransition <= 0) {
            isTransitioning = NO;
            
            
            currentColor = nextColor;
            nextColor = nil;
        }
    } else {
        timeUntilUpdate -= seconds;
        
        if (timeUntilUpdate <= 0) {
            isTransitioning = YES;
            
            nextColor = [self randomColor];
            
            transitionTime = [self randomTransitionTime];
            timeLeftInTransition = transitionTime;
            timeUntilUpdate = [self randomUpdateTime];
        }
    }
}

- (void)draw
{
    [[self color] set];
    [path fill];
}

@end
