//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Ravi Alla on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrains.h"

@interface CalculatorViewController ()
@property (nonatomic) BOOL ifUserInTheMiddleOfTyping;
@property (nonatomic, strong) CalculatorBrains * brain;
@property (nonatomic, strong) NSDictionary *testVariableValues;
@property (nonatomic) BOOL doesProgramHaveVariables;
@property (nonatomic,strong) NSMutableArray *operationArray;
@end
@implementation CalculatorViewController

@synthesize brain = _brain;
@synthesize display = _display;
@synthesize variableDisplay = _variableDisplay;
@synthesize descriptionDisplay = _descriptionDisplay;
@synthesize ifUserInTheMiddleOfTyping = _ifUserInTheMiddleOfTyping;
@synthesize testVariableValues = _testVariableValues;
@synthesize doesProgramHaveVariables;
@synthesize operationArray = _operationArray;
- (NSMutableArray *)operationArray
{ 
    if (_operationArray == nil ){_operationArray = [[NSMutableArray alloc] init];
    }
    return _operationArray;
}


- (CalculatorBrains *) brain {
    if (!_brain) _brain = [[CalculatorBrains alloc] init];
    return _brain;
}


- (IBAction)digitPressed:(UIButton *)sender 
{
    NSString *digit = sender.currentTitle;
    if (self.ifUserInTheMiddleOfTyping)
    {
        self.display.text = [self.display.text stringByAppendingFormat:digit];
    }
    else 
    {
        self.display.text = digit;
        self.ifUserInTheMiddleOfTyping = YES;
        
    }
}


- (IBAction)variablePressed:(UIButton *)sender {
    NSString *variable = sender.currentTitle;
    [self.brain pushOperand:variable];
    id program = [self.brain program];
    self.descriptionDisplay.text=[self.descriptionDisplay.text stringByAppendingFormat:[CalculatorBrains descriptionOfProgram:program:self.operationArray]];
    self.descriptionDisplay.text = [self.descriptionDisplay.text stringByAppendingFormat:@","];
    
    if ([self.descriptionDisplay.text length] > 35)
    {
        self.descriptionDisplay.text = [self.descriptionDisplay.text substringFromIndex:([self.descriptionDisplay.text length]-35)];
    }
    self.doesProgramHaveVariables = YES;
}


- (IBAction)decimalPressed:(UIButton *)sender {
    NSString *decimal = sender.currentTitle;
    if (!self.ifUserInTheMiddleOfTyping){self.display.text = @"0";} //this sets the display to zero after enterPressed and if decimal is pressed(so that NSRange doesn't pick up decimals from the typed decimal #s in display)
    NSRange decimalPoint = [self.display.text rangeOfString:decimal];
    if (decimalPoint.length == 0)
    {//getting the length of decimal point
    self.display.text = [self.display.text stringByAppendingFormat:@"."];
    self.ifUserInTheMiddleOfTyping = YES;
    }    

}


- (IBAction)clear:(id)sender {
    self.display.text = @"0"; //set display to 0
    self.variableDisplay.text=@"";
    self.descriptionDisplay.text=@"";
    self.ifUserInTheMiddleOfTyping=NO;//if clearing user is not in the middle of typing
    [self.brain performClear];// call the perform clear method from brain
    self.doesProgramHaveVariables = NO;
    [self.operationArray removeAllObjects];

}


- (IBAction)undo {
    if (self.ifUserInTheMiddleOfTyping) 
    {
        
        if([self.display.text length]>1)
        self.display.text = [self.brain performBackSpace:self.display.text];
       else {
         self.display.text = [NSString stringWithFormat:@"%g",[CalculatorBrains runprogram:[self.brain program]]];  
           self.ifUserInTheMiddleOfTyping = NO;
       }
    }
    
    else 
    {
        NSArray * newstack = [self.brain performUndo];
        self.display.text = [NSString stringWithFormat:@"%g",[CalculatorBrains runprogram:newstack]];
        self.descriptionDisplay.text = [CalculatorBrains descriptionOfProgram:newstack:self.operationArray];
    }
}

- (IBAction)backSpace:(id)sender {
    if ([self.display.text length]>1)
    { //backspace goes through till there is one character left
    self.display.text =[self.brain performBackSpace:self.display.text];// call the performBackSpace method
    }
    else 
    { //when one character is left change that character to 0 when backspace is pressed
        self.display.text = @"0";
    }
}


- (IBAction)changeSign:(id)sender {
        self.display.text = [NSString stringWithFormat:@"%g",-[self.display.text doubleValue]];//take the display text and convert it to a double and change sign and cast it as a string and put back in display
}



- (IBAction)enterPressed {
    [self.brain pushOperand:self.display.text];
    id program = [self.brain program];
    self.descriptionDisplay.text=[self.descriptionDisplay.text stringByAppendingFormat:[CalculatorBrains descriptionOfProgram:program:self.operationArray]];
    self.descriptionDisplay.text = [self.descriptionDisplay.text stringByAppendingFormat:@","];
    
    if ([self.descriptionDisplay.text length] > 35)
    {
        self.descriptionDisplay.text = [self.descriptionDisplay.text substringFromIndex:([self.descriptionDisplay.text length]-35)];
    }
    self.ifUserInTheMiddleOfTyping = NO;
}



- (IBAction)operationPressed:(UIButton *)sender {
    if (self.ifUserInTheMiddleOfTyping) [self enterPressed];
    [self.operationArray addObject:sender.currentTitle];
    
    if (!self.doesProgramHaveVariables) 
    {
    double result = [self.brain performOperation:sender.currentTitle];
        id program = [self.brain program];
        self.descriptionDisplay.text=[self.descriptionDisplay.text stringByAppendingFormat:[CalculatorBrains descriptionOfProgram:program:self.operationArray]];
        self.descriptionDisplay.text = [self.descriptionDisplay.text stringByAppendingFormat:@","];
        
        if ([self.descriptionDisplay.text length] > 35)
        {
            self.descriptionDisplay.text = [self.descriptionDisplay.text substringFromIndex:([self.descriptionDisplay.text length]-35)];
        }

    NSString *resultString = [NSString stringWithFormat:@"%g", result];
    self.display.text = resultString;
    }
    
    else 
    {
        [self.brain pushOperand:sender.currentTitle];
        id program = [self.brain program];
        self.descriptionDisplay.text=[self.descriptionDisplay.text stringByAppendingFormat:[CalculatorBrains descriptionOfProgram:program:self.operationArray]];
        self.descriptionDisplay.text = [self.descriptionDisplay.text stringByAppendingFormat:@","];
        
        if ([self.descriptionDisplay.text length] > 35)
        {
            self.descriptionDisplay.text = [self.descriptionDisplay.text substringFromIndex:([self.descriptionDisplay.text length]-35)];
        }
    }
}


- (IBAction)test:(UIButton *)sender {
    if([sender.currentTitle isEqualToString:@"Test1"])
    {
        self.testVariableValues = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:4.2],@"x",[NSNumber numberWithDouble:2.6],@"y", nil];
    }
    
    else if ([sender.currentTitle isEqualToString:@"Test2"])
    {
        self.testVariableValues = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:-32.8],@"x",[NSNumber numberWithDouble:29.2],@"foo", nil];
    }
    
    else if ([sender.currentTitle isEqualToString:@"Test3"])
    {
        self.testVariableValues = [NSDictionary dictionaryWithObjectsAndKeys:nil,@"x",nil,@"y",nil,@"foo", nil];
    }
    
    id program = [self.brain program];
    
    if (self.doesProgramHaveVariables) {
        double result = [CalculatorBrains runprogram:program :self.testVariableValues];
        self.display.text=[NSString stringWithFormat:@"%g",result];
        for (NSString *key in self.testVariableValues) {
            NSNumber *value = [self.testVariableValues objectForKey:key];
            self.variableDisplay.text = [self.variableDisplay.text stringByAppendingFormat:key];
            NSString *ofTheValue = [NSString stringWithFormat:@" = %@   ",value];
            self.variableDisplay.text = [self.variableDisplay.text stringByAppendingFormat:ofTheValue];
        }
        self.ifUserInTheMiddleOfTyping = NO;
        self.doesProgramHaveVariables = NO;
    }
}


@end