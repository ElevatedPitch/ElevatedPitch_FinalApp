//
//  main.cpp
//  hello
//
//  Created by Rahul Sheth on 4/6/17.
//  Copyright © 2017 Rahul Sheth. All rights reserved.
//


#include <stdio.h>
#include <limits.h>

#include <iostream>
int saturating_add(int x, int y) {
    int w = sizeof(int) << 3;
    int result = x + y;
    
    int signX = 1 & (x >> (w - 1));
    int signY =   1 & (y >> (w - 1));
    int signResult = 1 & (result >> ( w -1));
    
    
    //If sign result is positive, then signResult = 1, else if sign result is negative, signResult = 0
    //Either 000000001 or 000000000
    int overflowPossible = signX ^ ~signY;
    //If overFlowPosible = 1, then they are the same signs.
    // if 0 then overflow is possible but if 1 then overflow is not possible
    //else it will be 0.
    int overflowHappened = ((signResult ^ signX) && overflowPossible);
    //If overflowHappened equals 1, then overflow happened. 00000001
    //Else it will be 0. 00000000
    
    int extendedOverflowHappened = ~overflowHappened + 1;
    int extendedSignX = ~signX + 1;
    int overflow = INT_MAX ^ extendedSignX;
    
    overflow = extendedOverflowHappened & overflow;
    result = ~extendedOverflowHappened & result;
    
    return overflow | result;
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}


