//
//  GraphViewController.h
//  Calculator
//
//  Created by Ravi Alla on 7/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphView.h"

@interface GraphViewController : UIViewController

@property (nonatomic, weak) NSArray * dataPoints; //These are points from my 
-(NSArray *) graphPoints:(GraphView *)sender;
@end
