//
//  GraphView.h
//  Calculator
//
//  Created by Ravi Alla on 7/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GraphView : UIView

@property (nonatomic) CGFloat scale;
@property (nonatomic) CGPoint origin;
- (void) pinch:(UIPinchGestureRecognizer *)gesture;
- (void) pan:(UIPanGestureRecognizer *)gesture;
- (void) tripleTap:(UITapGestureRecognizer *)gesture;


@end
