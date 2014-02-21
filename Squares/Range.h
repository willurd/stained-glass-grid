//
//  Range.h
//  Squares
//
//  Created by William Bowers on 6/13/13.
//  Copyright (c) 2013 William Bowers. All rights reserved.
//

typedef struct _Range {
    float min;
    float max;
} Range;

NS_INLINE Range MakeRange(float min, float max) {
    Range r;
    r.min = min;
    r.max = max;
    return r;
}
