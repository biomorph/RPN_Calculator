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
@end
@implementation CalculatorViewController

@synthesize brain = _brain;
@synthesize display = _display;
@synthesize historyDisplay = _historyDisplay;
@synthesize ifUserInTheMiddleOfTyping = _ifUserInTheMiddleOfTyping;

- (CalculatorBrains *) brain {
    if (!_brain) _brain = [[CalculatorBrains alloc] init];
    return _brain;
}
- (IBAction)digitPressed:(UIButton *)sender 
{
    NSString *digit = sender.currentTitle;
    if (self.ifUserInTheMiddleOfTyping){
        self.display.text = [self.display.text stringByAppendingFormat:digit];
    }
    else {
        self.display.text = digit;
        self.ifUserInTheMiddleOfTyping = YES;
        
    }
}
- (IBAction)decimalPressed:(UIButton *)sender {
    NSString *decimal = sender.currentTitle;
    if (!self.ifUserInTheMiddleOfTyping){self.display.text = @"0";} //this sets the display to zero (so that NSRange doesn't pick up the leftovers from the display) after enterPressed and if decimal is pressed
    NSRange decimalPoint = [self.display.text rangeOfString:decimal];
    if (decimalPoint.length == 0){//getting the length of decimal point
    self.display.text = [self.display.text stringByAppendingFormat:@"."];
    self.ifUserInTheMiddleOfTyping = YES;
    }    

}
- (IBAction)clear:(id)sender {
    self.display.text = @"0"; //set display to 0
    self.historyDisplay.text = @""; //clear the history display
    self.ifUserInTheMiddleOfTyping=NO;//if clearing user is not in the middle of typing
    [self.brain performClear];// call the perform clear method from brain
}

- (IBAction)backSpace:(id)sender {
    if ([self.display.text length]>1){ //backspace goes through till there is one character left
    self.display.text =[self.brain performBackSpace:self.display.text];// call the performBackSpace method
    }
    else { //when one character is left change that character to 0 when backspace is pressed
        self.display.text = @"0";
    }
}
- (IBAction)changeSign:(id)sender {
        self.display.text = [NSString stringWithFormat:@"%g",-[self.display.text doubleValue]];//take the display text and convert it to a double and change sign and cast it as a string and put back in display
}

- (IBAction)enterPressed {
    self.historyDisplay.text = [self.historyDisplay.text stringByAppendingFormat:self.display.text];//appending the main display string to history display string and displaying it in history display
    self.historyDisplay.text = [self.historyDisplay.text stringByAppendingFormat:@" "];//space in history when enter is pressed
    [self.brain pushOperand:[self.display.text doubleValue]];
     self.ifUserInTheMiddleOfTyping = NO;
}
- (IBAction)operationPressed:(UIButton *)sender {
    if (self.ifUserInTheMiddleOfTyping) [self enterPressed];
    self.historyDisplay.text = [self.historyDisplay.text stringByAppendingFormat:sender.currentTitle];//appennding operation that is pressed to the history display string and displaying it in history display
    self.historyDisplay.text = [self.historyDisplay.text stringByAppendingFormat:@"="];// also appending = sign to the history display text when an operation button is pressed
    double result = [self.brain performOperation:sender.currentTitle];
    NSString *resultString = [NSString stringWithFormat:@"%g", result];
    self.display.text = resultString;
}


@end