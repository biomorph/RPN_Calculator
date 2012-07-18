//
//  GraphView.m
//  Calculator
//
//  Created by Ravi Alla on 7/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GraphView.h"
#import "AxesDrawer.h"

@implementation GraphView
@synthesize scale = _scale;
@synthesize origin = _origin;
@synthesize dataSource = _dataSource;
@synthesize dotOrLine = _dotOrLine;
#define DEFAULT_SCALE 1.0;

- (CGFloat) scale
{
    if (!_scale){
        return DEFAULT_SCALE;
    }
    else return _scale;
}

- (void) setScale:(CGFloat)scale
{
    if (scale != _scale){
        _scale = scale;
        [self setNeedsDisplay];

    }
    
}

- (CGPoint) origin
{
    if((_origin.x == 0.0) && (_origin.y == 0.0)) {
      _origin = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);  
        return _origin;
    }
    return _origin;
}

- (void) setOrigin:(CGPoint)origin
{
    if (CGPointEqualToPoint(origin, _origin) == NO) {
        _origin = origin;
        [self setNeedsDisplay];
    }
}

- (void) pinch:(UIPinchGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged)||(gesture.state == UIGestureRecognizerStateEnded)){
        self.scale *= gesture.scale;
        gesture.scale = 1;
    }
}

- (void) pan:(UIPanGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged)||(gesture.state == UIGestureRecognizerStateEnded)){
        CGPoint translation = [gesture translationInView:self];
        self.origin =CGPointMake(self.origin.x+translation.x, self.origin.y+translation.y);
        [gesture setTranslation:CGPointZero inView:self];

    }
}

- (void) tripleTap:(UITapGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateEnded) && (gesture.numberOfTapsRequired == 3)) {
        CGPoint translation = [gesture locationInView:self];
        //self.origin = CGPointMake(10, 10);
        self.origin = CGPointMake(translation.x,translation.y);
    
    }
}

- (void) setup
{
    self.contentMode = UIViewContentModeRedraw;
}

- (void)awakeFromNib
{
    [self setup];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}


- (void)drawGraph:(CGPoint)origin atPoint:(CGPoint)coordinates inContext:(CGContextRef) context
{
    
}

- (void)drawRect:(CGRect)rect
{
    //Make a context
    CGContextRef context = UIGraphicsGetCurrentContext();
    //Make a CGRect to pass to make axes
    CGContextSetLineWidth(context, 2.0);
    [[UIColor blueColor] setStroke];
    [AxesDrawer drawAxesInRect:rect originAtPoint:self.origin scale:self.scale];
    CGFloat pixelNumber = [self contentScaleFactor]*self.bounds.size.width;
    CGContextMoveToPoint(context, 0, 0);
    for (float xValue = 0; xValue <= pixelNumber; xValue++) {
        UIGraphicsPushContext(context);
        CGPoint point = CGPointZero;
        point.x = self.scale*xValue;
        point.y = (self.origin.y - [self.dataSource graphPoints:self:self.scale*(xValue-self.origin.x)]);
        if(!self.dotOrLine) CGContextAddLineToPoint(context, point.x, point.y);
        else if (self.dotOrLine) {
         CGContextAddArc(context, point.x, point.y, 0.05, 0, 2*M_PI, YES);
            [[UIColor blueColor]setFill];
        }
        UIGraphicsPopContext();

    } 
    CGContextStrokePath(context);

}

@end
