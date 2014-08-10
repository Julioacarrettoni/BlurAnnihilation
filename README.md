BlurAnnihilation
================

A practical demostration of a bug found on the current (beta 5 iOS8) implementation of UIVisualEffectView + UIBlurEffect

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
 
 