//
//  CalculatorBrains.m
//  Calculator
//
//  Created by Ravi Alla on 6/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorBrains.h"

@interface CalculatorBrains()
@property (strong, nonatomic) NSMutableArray * operandStack;
@end

@implementation CalculatorBrains

@synthesize operandStack = _operandStack;
- (NSMutableArray *)operandStack
{ 
    if (_operandStack == nil ){_operandStack = [[NSMutableArray alloc] init];
    }
    return _operandStack;
}

- (double) popOperand {
    NSNumber* operandObject = [self.operandStack lastObject];
    NSLog (@"last object is %g",[operandObject doubleValue]);
    if (operandObject) [self.operandStack removeLastObject];
    return [operandObject doubleValue];
}
- (void) pushOperand: (double) operand{
    [self.operandStack addObject:[NSNumber numberWithDouble:operand]];
}

-(double) performOperation: (NSString*) operation{
    double result =0;
    if ([operation isEqualToString:@"+"]){
        result = self.popOperand + self.popOperand;
    } else if ([operation isEqualToString:@"*"]){
        result = self.popOperand * self.popOperand;
    } else if ([operation isEqualToString:@"-"]){
        result = self.popOperand - self.popOperand;
    } else if ([operation isEqualToString:@"/"]){
        result = self.popOperand / self.popOperand;
    }
    else if ([operation isEqualToString:@"cos"]){
        result = cos(self.popOperand);
    }
    else if ([operation isEqualToString:@"sin"]){
        result = sin(self.popOperand);
    }
    else if ([operation isEqualToString:@"sqrt"]){
        result = sqrt(self.popOperand);
    }
    else if ([operation isEqualToString:@"π"]){
        result = M_PI;
    }
[self pushOperand:result];
return result;
}

-(void) performClear{
    [self.operandStack removeAllObjects];
}

-(NSString *) performBackSpace: (NSString *) display {
    
    NSString * newdisplay = [display substringToIndex:[display length]-1];    
    return newdisplay;

}
    
@end

