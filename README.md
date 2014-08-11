BlurAnnihilation
================

A practical demostration of a bug found on the current (beta 5 iOS8) implementation of UIVisualEffectView + UIBlurEffect

---
The code that creates the bug is inside viewDidLoad on ViewController, here is the code:

```objective-c
    
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
    
```


---
This bug was already reported to Apple, and here is my explanation, please feel free to make your own report if you feel that you understand it better or that you have a better fix suggestion:

When you place a UIVisualEffectView on top of another, the one below gets it's blur disabled, possible to enhance performance, the problem is that this "check" (a Blur is behind another blur) doesn't consider the case where one is actually not visible because it's container has "clipsToBounds = YES" so when the user is actually just seeing 1 blur the system treat is as 2 and disabled the one that it thinks is below.

The problem is how the blur effect is disabled, instead of disabling everything it just disabled the "blurring" but left the lower resolution content visible.

I only see 3 possible fix for this:

 - (1) The check should consider blurs that might not be actually visible due to it's superview cliping content outside it's bounds.
 - (2) The disabling should be complete, instead of disabling just the blurring it should also disable the lower resolution calculation, I mean, if we are trying to get a boost in performance let's get all the maximun boost out of it.
 - (3) Include this exceptional case in the *warning* list on the UIVisualEffectView documentation.
 
 ---
 
#### Now with out further introduction here is the bug, just compare the following 3 pictures:
![image](https://raw.githubusercontent.com/Julioacarrettoni/BlurAnnihilation/master/Screenshots/blur.png)

![image](https://raw.githubusercontent.com/Julioacarrettoni/BlurAnnihilation/master/Screenshots/no_blur.png)

![image](https://raw.githubusercontent.com/Julioacarrettoni/BlurAnnihilation/master/Screenshots/bugged_blur.png)
 
 