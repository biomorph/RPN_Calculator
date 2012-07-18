//
//  GraphViewController.m
//  Calculator
//
//  Created by Ravi Alla on 7/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GraphViewController.h"
#import "GraphView.h"
#import "CalculatorViewController.h"

@interface GraphViewController () <GraphViewDataSource>
@property (nonatomic, weak) IBOutlet GraphView * graphView;
@property (nonatomic, strong) CalculatorViewController *calculator;
@end

@implementation GraphViewController

@synthesize graphView = _graphView;
@synthesize dataPoints = _dataPoints;
@synthesize calculator = _calculator;


- (CalculatorViewController *) calculator
{
    if (!_calculator){
       _calculator = [[CalculatorViewController alloc] init];
    }
        return _calculator;
}

-(NSArray *) graphPoints:(GraphView *)sender{
    double scaleFactor = [sender contentScaleFactor];
    NSArray* array;
    return array;
}

-(void) setGraphView:(GraphView *)graphView{
    _graphView = graphView;
    
    [self.graphView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pinch:)]];
    
    [self.graphView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pan:)]];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(tripleTap:)];
    tap.numberOfTapsRequired = 3;
    
    [self.graphView addGestureRecognizer:tap];
    
    [self.graphView setNeedsDisplay];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return YES;
}
@end
