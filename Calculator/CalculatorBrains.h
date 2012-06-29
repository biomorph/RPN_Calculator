//
//  CalculatorBrains.h
//  Calculator
//
//  Created by Ravi Alla on 6/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrains : NSObject
-(void) pushOperand: (double) operand;
-(double) performOperation: (NSString*) operation;
-(void) performClear;
-(NSString *) performBackSpace: (NSString *) display;

@end
