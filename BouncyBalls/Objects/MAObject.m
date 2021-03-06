//
//  MAObject.m
//  BouncyBalls
//
//  Created by Miles Alden on 8/9/12.
//  Copyright (c) 2012 MilesAlden. All rights reserved.
//

#import "MAObject.h"
#import "MAUtils.h"
#import "MAConstants.h"

@implementation MAObject



- (NSString *)description {
    
    NSString *desc = [NSString stringWithFormat:@"\r\n\t %@"
                             @"\n\t shape: %@"
                             @"\n\t frame: (%0.2f,%0.2f %0.2f,%02.f)"
                             @"\n\t center: %0.2f,%0.2f"
                             @"\n\t delta:  %0.2f,%0.2f"
                             @"\n\t velocity: %0.2f,%0.2f",
                             NSStringFromClass([self class]),
                             (self.shape == circle) ? @"circle" : @"square",
                             self.frame.origin.x,self.frame.origin.y,self.frame.size.width,self.frame.size.height,
                             self.center.x, self.center.y,
                             self.deltaPosition.x, self.deltaPosition.y,
                              self.velocity.x, self.velocity.y];
    
    return desc;
}


- (id)initWithShape: (MAShape)theShape frame:(CGRect)theFrame  {
    
    // Create with shape
    if ( self = [super init] ) {
        self.frame = theFrame;
        self.shape = theShape;
        self.center = MAGetCenter(self.frame);
        [self setPathForShape];
        [self setDefaultColor];
        [self setDefaultVelocity];
        [self setDefaultCOR];
        [self setDefaultRadius];
    }
    
    return self;
}

- (void)updateCenter: (CGPoint)newCenter {
    
    self.center = newCenter;
    float halfWidth = self.frame.size.width / 2;
    float halfHeight = self.frame.size.height / 2;
    self.frame = CGRectMake(newCenter.x - halfWidth,
                            newCenter.y - halfHeight,
                            self.frame.size.width,
                            self.frame.size.height);
    
    [self updatePathLocation];
    
}



- (void)updatePathLocation {
        
    [self setPathForShape];
}



- (void)setPathForShape {
    
    // Create the path
    self.path = CGPathCreateMutable();
    
    // Add appropriate shape
    if ( self.shape == circle ) {
        CGPathAddEllipseInRect(self.path, NULL, self.frame);
    } else if ( self.shape == square ) {
        CGPathAddRect(self.path, NULL, self.frame);
    }
    CGPathCloseSubpath(self.path);
        
}

- (void)setDefaultColor {
    
    // Just a random color
    int r = arc4random()%100;
    int g = arc4random()%30;
    int b = arc4random()%30;
        
    UIColor *randColor = [[UIColor alloc] initWithRed:r*0.01
                                                green:g*0.01
                                                 blue:b*0.01
                                                alpha:1.0];
    self.color = [randColor CGColor];
    CFRetain(self.color);
}

- (void)setDefaultVelocity {
    
    self.velocity = (MAVector){0,0};
    return;
    
    int anX = arc4random()%1500;
    int anY = arc4random()%1500;
    
    float x = anX * pixelCompensation;
    float y = anY * pixelCompensation;
    
    
    MAVector newVelocity;
    newVelocity.x = x;//0.110;
    newVelocity.y = y;//0.125;
    self.velocity = newVelocity;
    
}

- (void)setDefaultCOR {
    
    // Coefficient of restitution
    // (elasticity)
    int randCOR = arc4random()%10;
    self.COR = randCOR*0.1;
    
}

- (void)setDefaultRadius {
    
    // Radius
    self.radius = self.frame.size.width;
    
}



@end
