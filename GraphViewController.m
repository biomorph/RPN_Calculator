//
//  GraphViewController.m
//  Calculator
//
//  Created by Ravi Alla on 7/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GraphViewController.h"
#import "GraphView.h"
#import "CalculatorBrains.h"

@interface GraphViewController () <GraphViewDataSource>

@property (nonatomic, weak) IBOutlet GraphView * graphView;
@end

@implementation GraphViewController
@synthesize graphDescription = _graphDescription;
@synthesize graphView = _graphView;
@synthesize programStack = _programStack;



- (id) programStack {
    if (!_programStack)_programStack=[[NSArray alloc]init];
    return _programStack;
}


-(void) setGraphView:(GraphView *)graphView{
    _graphView = graphView;
    
    [self.graphView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pinch:)]];
    
    [self.graphView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pan:)]];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(tripleTap:)];
    tap.numberOfTapsRequired = 3;
    
    [self.graphView addGestureRecognizer:tap];
    
    [self.graphView setNeedsDisplay];
    self.graphView.dataSource = self;
}


- (void) getProgram : (id)program {
    self.programStack = program;
}

- (double)graphPoints:(GraphView *) sender:(double)xValue {
    
    
    NSDictionary * variableValues= [[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithDouble:xValue],@"x", nil];
    
    double result = [CalculatorBrains runprogram:self.programStack :variableValues];
    return result;
   
    
}

- (void)graphDescription:(NSMutableArray*) operations{
    NSLog(@"operationarray %@",operations);
    NSLog(@"graph description %@",self.graphDescription.text);
    //self.graphDescription.text = @"WTF";
}



-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return YES;
}

-(void) viewDidLoad{
    self.graphDescription.text = @"test";
    [super viewDidLoad];
}
- (void)viewDidUnload {
    [self setGraphDescription:nil];
    [super viewDidUnload];
}
@end
