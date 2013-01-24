    //
//  MAControlPanelViewCon.m
//  PhysicsTester
//
//  Created by Miles Alden on 7/25/12.
//  Copyright (c) 2012 Milk Drinking Cow. All rights reserved.
//

#import "MAControlPanelViewCon.h"
#import "MAPlaneManager.h"
#import "MAPlane.h"
#import "MAObjectManager.h"
#import "MAUtils.h"

@implementation MAControlPanelViewCon
@synthesize onScreen;





- (BOOL)canBecomeFirstResponder { return 1; }
- (BOOL)canResignFirstResponder { return 1; }


- (void)getReady {
    
    [self arrangeOnScreen];
    [self doAnySetups];
}


- (void)doAnySetups {
    
    self.lastSliderValue = self.planeSlider.value;
    self.planeSlider.maximumValue = 1.0f;
    self.planeSlider.minimumValue = -1.0f;
    self.degreeLabel0.text = [NSString stringWithFormat:@"(%0.1f°)", [[[MAPlaneManager planeStore] objectAtIndex:0] angleToScreenCenter]];
    
    
    self.view.userInteractionEnabled = 1;
}


- (void)arrangeOnScreen {
    
    self.onScreen = 0;
    
    self.view.frame = [self onScreenPosition];

    [self.view.superview bringSubviewToFront:self.view];
}


- (CGRect)onScreenPosition {
    
    CGRect screen = [[UIScreen mainScreen] bounds];
    return CGRectMake(screen.size.width - self.view.frame.size.width,
                                 0,
                                 self.view.frame.size.width,
                                 self.view.frame.size.height);
}

- (CGRect)offScreenPosition {
    
    CGRect screen = [[UIScreen mainScreen] bounds];
    return CGRectMake(screen.size.width - 15,
                      0,
                      self.view.frame.size.width,
                      self.view.frame.size.height);
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    LogInfo(@"***Mark***");
    
    if  ( !onScreen ) {
                    
        [UIView animateWithDuration:0.25 
                              delay:0 
                            options:UIViewAnimationCurveEaseIn 
                         animations:^{
                             self.view.frame = [self onScreenPosition]; }
                         completion:NULL];
        onScreen = true;
        
    }     
}

- (IBAction)dismissControlPanel:(id)sender {
 
    
    LogDebug(@"***mark***");

        [UIView animateWithDuration:0.25 
                              delay:0 
                            options:UIViewAnimationCurveEaseIn 
                         animations:^{
                             self.view.frame = [self offScreenPosition]; }
                         completion:NULL];
        onScreen = false;
    
}



- (IBAction)planeSliderChanged:(id)sender {
    
    UISlider *_sender = sender;
    float diff = _sender.value - self.lastSliderValue;
    
    LogInfo(@"diff: %f", diff);
    
    
    [MAPlaneManager incrementPlaneStoreVectorsBy:diff];
    [self updatePlaneVectorLabels];
    
    self.lastSliderValue = _sender.value;
    
}


- (void)updatePlaneVectorLabels {
    
    int counter = 0;
    for ( MAPlane *plane in [MAPlaneManager planeStore] ) {
        
        if ( counter == 0 ) {
            self.label0.text = [plane stringFromRaw];
            self.degreeLabel0.text = [NSString stringWithFormat:@"(%0.1f°)", [plane angleToScreenCenter]];
        }
        
        /*else if ( counter == 1 ) {
            self.label1.text = [plane stringFromRaw];
        } else if ( counter == 2 ) {
            self.label2.text = [plane stringFromRaw];
        } else if ( counter == 3 ) {
            self.label3.text = [plane stringFromRaw];
        }
        */
        
        counter++;
    }
    
}

- (IBAction)velocityBurstPressed:(id)sender {
    
    LogDebug(@"***mark***");

    [MAObjectManager createVelocityBurst];
    
}


- (IBAction)playPause:(id)sender {

    LogDebug(@"***mark***");


}


- (IBAction)reset:(id)sender {
    
    
    
}

- (BOOL)shouldAutorotate {
    
    return 0;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    
    return (UIInterfaceOrientationIsPortrait(toInterfaceOrientation));
}



@end
