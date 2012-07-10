//
//  CalculatorBrains.m
//  Calculator
//
//  Created by Ravi Alla on 6/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorBrains.h"

@interface CalculatorBrains()
@property (strong, nonatomic) NSMutableArray * programStack;
@end

@implementation CalculatorBrains

@synthesize programStack = _programStack;
- (NSMutableArray *)programStack
{ 
    if (_programStack == nil ){_programStack = [[NSMutableArray alloc] init];
    }
    return _programStack;
}


- (void) pushOperand: (NSString *) operand{
    if ([operand doubleValue])
    {
    [self.programStack addObject:[NSNumber numberWithDouble:[operand doubleValue]]];
    }
    else 
    {
        [self.programStack addObject:operand];
    }
}


-(id)program
{
    return [self.programStack copy];
}


+ (NSString *)singleOrDoubleOperandOperations:(NSString *)operation{
    NSSet * singleOperandOperations = [[NSSet alloc] initWithObjects:@"sqrt",@"cos",@"sin", nil];
    NSSet * doubleOperandOperations = [[NSSet alloc] initWithObjects:@"+",@"-",@"*",@"/", nil];
    if ([singleOperandOperations containsObject:operation]) 
    {
        return @"single";
    }
    else if ([doubleOperandOperations containsObject:operation])
    {
        return @"double";
    }
    else 
    {
        return @"π";
    }
}

+ (BOOL)isAnOperation:(NSString *)operation{
    NSSet *Operations = [[NSSet alloc] initWithObjects:@"sqrt",@"cos",@"sin",@"+",@"-",@"*",@"/", nil];
    if ([Operations containsObject:operation]) 
    {
        return YES;
    }
    else 
    {
        return NO;
    }
}

+ (NSString *) descriptionOfProgram:(id)program:(NSMutableArray*)operationArray{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]){
        stack = [program mutableCopy];
    }
    return [self descriptionOfTopOfStack:stack:operationArray];
}

+ (NSString *) descriptionOfTopOfStack: (NSMutableArray*)stack:(NSMutableArray *)operationArray{
   
    NSArray *originalStack = [stack copy];
    NSLog(@"stack is %@",stack);
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    NSString * description =[[NSString alloc]initWithFormat:@""];
    
    if ([topOfStack isKindOfClass:[NSNumber class]]){
        description = [NSString stringWithFormat:@"%@",topOfStack];
    }
    
    else if ([topOfStack isKindOfClass:[NSString class]]){
            NSString* operationOrVariable = topOfStack;
        
            if ([CalculatorBrains isAnOperation:operationOrVariable] && [[CalculatorBrains singleOrDoubleOperandOperations:operationOrVariable] isEqualToString:@"double"]){
                NSString *operand1=[self descriptionOfTopOfStack:stack:operationArray];
                NSString *operand2=[self descriptionOfTopOfStack:stack:operationArray];
                NSString *previousOperation = [CalculatorBrains returnPreviousOperation:operationArray];
                
                      
                if ([CalculatorBrains precedenceOfOperations:previousOperation]<[CalculatorBrains precedenceOfOperations:operationOrVariable]) 
                {
                    description = [NSString stringWithFormat:@"%@%@(%@)", operand2,operationOrVariable, operand1];
                }
                else 
                {
                    description = [NSString stringWithFormat:@"%@%@%@", operand2,operationOrVariable, operand1];
                }
                
            }
        
            else if ([CalculatorBrains isAnOperation:operationOrVariable] && [[CalculatorBrains singleOrDoubleOperandOperations:operationOrVariable] isEqualToString:@"single"]) 
            {
                
                description = [NSString stringWithFormat:@"%@(%@)",operationOrVariable,[self descriptionOfTopOfStack:stack:operationArray]];
            }
        
            else if ([[CalculatorBrains variablesUsedInProgram:originalStack] containsObject:operationOrVariable])
            {
                description = [NSString stringWithFormat:@"%@",operationOrVariable];
            }
        
            else if([operationOrVariable isEqualToString:@"π"])
            {
                description = [NSString stringWithFormat:@"%@",operationOrVariable];
            }

}

    return description;
    
}

+ (NSString *) returnPreviousOperation: (NSArray *) stack{
    NSString * previousOperation;
    
    if([stack count]>1)
    {
    previousOperation = [stack objectAtIndex:[stack count]-2];
    }
    
    else 
    {
        previousOperation = [stack lastObject];
    }
    return previousOperation;
}

+ (double) precedenceOfOperations: (NSString *)operation {
    double precedence = 0;
    
    if ([[CalculatorBrains singleOrDoubleOperandOperations:operation] isEqualToString:@"single"]) 
    {
        precedence = 2;
    }
    
    else if ([operation isEqualToString:@"*"] || [operation isEqualToString:@"/"]) 
    {
        precedence = 1;
    } 
    
    return precedence;
}


+ (double) popOperandOffStack: (NSMutableArray *)stack
{
    double result = 0;
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]])
    {
        result = [topOfStack doubleValue];
    }
    
    else if ([topOfStack isKindOfClass:[NSString class]])
    {
        NSString* operation = topOfStack;
        if ([operation isEqualToString:@"+"])
        {
            result = [self popOperandOffStack:stack] + [self popOperandOffStack:stack];
        } 
        
        else if ([operation isEqualToString:@"*"])
        {
            result = [self popOperandOffStack:stack] * [self popOperandOffStack:stack];
        } 
        
        else if ([operation isEqualToString:@"-"])
        {
            double subtrahend = [self popOperandOffStack:stack];
            result = [self popOperandOffStack:stack] - subtrahend;
        } 
        
        else if ([operation isEqualToString:@"/"])
        {
            double divisor = [self popOperandOffStack:stack];
            if (divisor) result = [self popOperandOffStack:stack] / divisor;
        }
        
        else if ([operation isEqualToString:@"cos"])
        {
            result = cos([self popOperandOffStack:stack]);
        }
        
        else if ([operation isEqualToString:@"sin"])
        {
            result = sin([self popOperandOffStack:stack]);
        }
        
        else if ([operation isEqualToString:@"sqrt"])
        {
            result = sqrt([self popOperandOffStack:stack]);
        }
        
        else if ([operation isEqualToString:@"π"])
        {
            result = M_PI;
        }

    }
    return result;
    
}

+ (double) runprogram:(id)program 
{
    NSMutableArray *stack;
    
    if ([program isKindOfClass:[NSArray class]])
    {
        stack = [program mutableCopy];
    }
    
    return [self popOperandOffStack:stack];
}



+ (double) runprogram:(id)programusingVariableValues :(NSDictionary *)variableValues
{
    NSMutableArray *variableStack = [[NSMutableArray alloc] init];
    NSSet *variables = [[NSSet alloc]init];
    
    if ([programusingVariableValues isKindOfClass:[NSArray class]])
    {
        variableStack=[programusingVariableValues mutableCopy];
        variables = [CalculatorBrains variablesUsedInProgram:programusingVariableValues];
    }
    
    NSUInteger index = 0;
    
    for (id elementsOfStack in programusingVariableValues){
    
    if ([variables containsObject:elementsOfStack]){
        
        if ([variableValues valueForKey:elementsOfStack])
        {
        [variableStack replaceObjectAtIndex:index withObject:[variableValues valueForKey:elementsOfStack]];
        }
        
        else 
        {
            [variableStack replaceObjectAtIndex:index withObject:[NSNumber numberWithDouble:0]];
        }    
    }
        
        index++;
    }
    return [self popOperandOffStack:variableStack];

}

+ (NSSet*) variablesUsedInProgram:(id)program 
{
    NSMutableArray *variables = [[NSMutableArray alloc] init];
    
    if ([program isKindOfClass:[NSArray class]]) {
        
        for (NSString * operand in program){
            
            if ([operand isKindOfClass:[NSString class]] && [operand isEqualToString: @"x"])
            {
                [variables addObject:@"x"];
            }
            
            else if ([operand isKindOfClass:[NSString class]] && [operand isEqualToString: @"y"])
            {
            [variables addObject:operand];
            }
            
            else if ([operand isKindOfClass:[NSString class]] && [operand isEqualToString: @"foo"])
            {
            [variables addObject:operand];
            }
        
        } 
    }
    NSSet * variableSet = [[NSSet alloc]initWithArray:variables];
    return variableSet;
}

-(double) performOperation: (NSString*) operation{
    [self.programStack addObject:operation];
    return [CalculatorBrains runprogram:self.program];
}

-(void) performClear{
    [self.programStack removeAllObjects];
}

-(NSString *) performBackSpace: (NSString *) display {
    
    NSString * newdisplay = [display substringToIndex:[display length]-1];    
    return newdisplay;

}
-(NSArray *) performUndo{
   [self.programStack removeLastObject];
    return [self.programStack copy];
}


    
@end

