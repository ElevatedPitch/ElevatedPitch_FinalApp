//
//  test.cpp
//  
//
//  Created by Rahul Sheth on 4/6/17.
//
//

#include <stdio.h>
#include <limits.h>


int saturating_add(int x, int y) {
    int w = sizeof(int) << 3;
    
    int result = x + y;
    
    x >> w -1;
    y >> w - 1;
    result >> ( w -1);
    int value >> w - 1;
    int signResult = 0x00000001 == result;
    int signX  = 0x00000001 == x;
    int signY  = 0x00000001 == y;
    
    int overflowPossible = signX ^ ~signY;
    
    
    int overflowHappened = ((signResult ^ signX) && overflowPossible);
    
    
    
    
    
    
    
    
    
    
    
    
}
