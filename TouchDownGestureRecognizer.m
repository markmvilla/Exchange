//
//  TouchDownGestureRecognizer.m
//  TCUExchange
//
//  Created by Mark Villa on 5/30/16.
//  Copyright © 2016 Exchange. All rights reserved.
//

#import "TouchDownGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

//NSLog(@"%ld %ld %ld %ld %ld", (long)UIGestureRecognizerStatePossible, (long)UIGestureRecognizerStateBegan, (long)UIGestureRecognizerStateChanged, (long)UIGestureRecognizerStateEnded, (long)UIGestureRecognizerStateRecognized);

@implementation TouchDownGestureRecognizer

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    if ([touches count] != 1) {
        self.state = UIGestureRecognizerStateFailed;
        return;
    }
    self.state = UIGestureRecognizerStateBegan;
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
    self.state = UIGestureRecognizerStateChanged;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    if (self.state == UIGestureRecognizerStateChanged || self.state == UIGestureRecognizerStateBegan) {
        self.state = UIGestureRecognizerStateRecognized;
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    self.state = UIGestureRecognizerStateFailed;
}

@end
