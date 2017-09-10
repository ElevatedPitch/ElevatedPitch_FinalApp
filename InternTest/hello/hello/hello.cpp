//
//  hello.cpp
//  hello
//
//  Created by Rahul Sheth on 4/7/17.
//  Copyright © 2017 Rahul Sheth. All rights reserved.
//

#include <stdio.h>
#include <limits.h> 
#include <iostream> 


int saturating_add(int x, int y) {
    int w = sizeof(int) << 3;
    int result;
    bool value = __builtin_add_overflow(x, y, &result);
    int someOverflow = value;
    //If an overflow occurred, someOverflow is equivalent to 1 and if it isn't then someOverflow is equivalent to 0.
    int signResult = 1 & (result >> (w-1));
    
    int extendedOverflowHappened = ~someOverflow + 1;
    int extendedSignResult = ~signResult + 1;
    
    int overflow = INT_MIN ^ (~extendedOverflowHappened ^ extendedSignResult);
    
    overflow = extendedOverflowHappened & overflow;
    result = ~extendedOverflowHappened & result;
    
    return overflow | result;
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

int main() {
    std::cout << saturating_add(99, 99) << std::endl;
    std::cout << saturating_add(2000000000, 2000000000) << std::endl;
    std::cout << saturating_add(-2000000000, -2000000000) << std::endl;
}
