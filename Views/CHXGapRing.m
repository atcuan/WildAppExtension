//
//  CHXGapRing.m
//  GettingStarted
//
//  Created by Moch Xiao on 2014-11-18.
//  Copyright (c) 2014 Moch Xiao (https://github.com/cuzv).
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "CHXGapRing.h"
#import "CHXGlobalServices.h"

@interface CHXGapRing ()

@property (nonatomic, assign) BOOL resetAnimation;
@property (nonatomic, readwrite, getter = isAnimating) BOOL animating;
@property (nonatomic, assign, getter = isInitializeTime) BOOL initializeTime;

@end

@implementation CHXGapRing

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    if (!newSuperview) {
        self.resetAnimation = NO;
        [self pr_stopRotateAnimation];
    }
}

- (void)willMoveToWindow:(UIWindow *)newWindow {
    [super willMoveToWindow:newWindow];
    
    if (self.isInitializeTime) {
        self.initializeTime = NO;
        return;
    }
    
    if (newWindow) {
        [self startAnimation];
    } else {
        self.resetAnimation = NO;
        [self stopAnimation];
    }
}

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    CGFloat lengthOfSide = MIN(width, height);
    CGRect newFrame = CGRectMake(frame.origin.x, frame.origin.y, lengthOfSide, lengthOfSide);
    self = [super initWithFrame:newFrame];
    if (self) {
        self.layer.cornerRadius = lengthOfSide / 2;
        self.backgroundColor = [UIColor clearColor];
        self.layer.masksToBounds = YES;
        self.layer.shouldRasterize = YES;
        self.layer.rasterizationScale = [UIScreen mainScreen].scale;
        
        self.resetAnimation = YES;
        self.initializeTime = YES;
    }
    return self;
}

- (void)setBounds:(CGRect)bounds {
    CGFloat width = CGRectGetWidth(bounds);
    CGFloat height = CGRectGetHeight(bounds);
    CGFloat lengthOfSide = MIN(width, height);
    CGRect newBounds = CGRectMake(0, 0, lengthOfSide, lengthOfSide);
    self.layer.cornerRadius = lengthOfSide / 2;
    self.layer.masksToBounds = YES;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    [super setBounds:newBounds];
}

- (void)drawRect:(CGRect)rect {
    CGFloat lineWidth = 1.0f;
    UIColor *lineColor = [UIColor lightGrayColor];
    if (self.lineWidth) {
        lineWidth = self.lineWidth;
    }
    if (self.lineColor) {
        lineColor = self.lineColor;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextRetain(context);
    CGContextSetLineWidth(context, lineWidth);
    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
    CGContextAddArc(context,
                    CGRectGetMidX(self.bounds),
                    CGRectGetMidY(self.bounds),
                    CGRectGetWidth(self.bounds) / 2 - lineWidth,
                    chx_angleToRadian(260),
                    chx_angleToRadian(-80),
                    YES);
    CGContextStrokePath(context);
    CGContextRelease(context);
}

- (void)startAnimation {
    if (self.isAnimating) {
        return;
    }
    
    [self pr_startRotateAnimation];
    
    self.animating = YES;
}

- (void)pr_startRotateAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = @(0);
    animation.toValue = @(2 * M_PI);
    animation.duration = 0.8f;
    animation.repeatCount = HUGE_VAL;
    animation.removedOnCompletion = YES;
    animation.delegate = self;
    [self.layer addAnimation:animation forKey:@"RotateAnimation"];
}

- (void)stopAnimation {
    if (!self.animating) {
        return;
    }
    
    [self pr_stopRotateAnimation];
    
    self.animating = NO;
}

- (void)pr_stopRotateAnimation {
    [UIView animateWithDuration:0.3f animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self.layer removeAllAnimations];
        self.alpha = 1;
    }];
}

// animation delegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (!self.animating) {
        return;
    }
    
    if (!flag && self.resetAnimation) {
        [self pr_startRotateAnimation];
    }
}


@end
