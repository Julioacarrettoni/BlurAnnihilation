//
//  ViewController.m
//  BlurAnnihilation
//
//  Created by Julio Carrettoni on 8/10/14.
//  Copyright (c) 2014 Julio Carrettoni. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController {
    UIVisualEffectView* blurViewToBeDeactivated;
    UIView* viewThatProvidesTheMasking;
    __weak IBOutlet UISegmentedControl *segmentedControl;
}

- (UIVisualEffectView*) blurViewWithFrame:(CGRect) frame {
    UIVisualEffectView* visualEffect = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    visualEffect.frame = frame;
    return visualEffect;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //You start by creating a normal UIVisualEffectView + UIBlurEffect
    blurViewToBeDeactivated = [self blurViewWithFrame:CGRectMake(0, 0, 319, 568)];
    
    //Then you create a small view that is contained inside the bounds of the blur you want to bug
    viewThatProvidesTheMasking = [[UIView alloc] initWithFrame:CGRectMake(319, 0, 320, 568)];
    viewThatProvidesTheMasking.clipsToBounds = YES;
    
    //Now you create another blur to insert inside the previous view and you place it in a way
    //so it "theoretically" covers the previous blur (if the view wasn't clipping it's content)
    UIVisualEffectView* blurViewUsedToDeactivate = [self blurViewWithFrame:CGRectMake(-319, 0, 320, 568)];
    [viewThatProvidesTheMasking addSubview:blurViewUsedToDeactivate];
    
    //Finally you add everything to the view in the propper order:
    //0=sad_puppy, 1=lorem ipsum text, 2=blur to bug and 3=blur that bugs the other blur
    [self.view insertSubview:blurViewToBeDeactivated atIndex:2];
    [self.view insertSubview:viewThatProvidesTheMasking atIndex:3];
    
    segmentedControl.selectedSegmentIndex = 0;
    [self onSegmentedButtonValueChanged:segmentedControl];
}

- (IBAction)onSegmentedButtonValueChanged:(UISegmentedControl *)sender {
    //If I use "hidden" instead of adding and removing subviews it gets "extra" bugged
//    if (sender.selectedSegmentIndex == 0) {
//        blurViewToBeDeactivated.hidden = NO;
//        viewThatProvidesTheMasking.hidden = YES;
//    }
//    else if (sender.selectedSegmentIndex == 1) {
//        blurViewToBeDeactivated.hidden = YES;
//        viewThatProvidesTheMasking.hidden = YES;
//    }
//    else {
//        blurViewToBeDeactivated.hidden = NO;
//        viewThatProvidesTheMasking.hidden = NO;
//    }
    if (sender.selectedSegmentIndex == 0) {
        [self.view insertSubview:blurViewToBeDeactivated atIndex:2];
        [viewThatProvidesTheMasking removeFromSuperview];
    }
    else if (sender.selectedSegmentIndex == 1) {
        [blurViewToBeDeactivated removeFromSuperview];
        [viewThatProvidesTheMasking removeFromSuperview];
    }
    else {
        [self.view insertSubview:blurViewToBeDeactivated atIndex:2];
        [self.view insertSubview:viewThatProvidesTheMasking atIndex:3];
    }
}

@end
