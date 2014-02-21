//
//  Cell.h
//  Squares
//
//  Created by William Bowers on 6/12/13.
//  Copyright (c) 2013 William Bowers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Range.h"

@interface Cell : NSObject {
    NSRect rect;
    Range timeBetweenUpdatesRange;
    Range transitionTimeRange;
    NSBezierPath *path;
    NSColor *currentColor;
    NSColor *nextColor;
    float timeUntilUpdate;
    float transitionTime;
    float timeLeftInTransition;
    BOOL isTransitioning;
}

- (id)initWithRect:(NSRect)rect_
timeBetweenUpdates:(Range)timeBetweenUpdates_
    transitionTime:(Range)transitionTime_;

- (void)updateWithElapsedTime:(float)seconds;
- (void)draw;

@end
