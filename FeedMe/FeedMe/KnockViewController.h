//
//  KnockViewController.h
//  FeedMe
//
//  Created by Nicole Zhu on 10/29/14.
//  Copyright (c) 2014 Delta Hackers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AudioToolbox/AudioServices.h>
#import <QuartzCore/QuartzCore.h>
#import <Parse/Parse.h>
#import "coreMotionListener.h"
#import "knockDetector.h"
#import "GazeTask.h"

@interface KnockViewController : UIViewController<UIAlertViewDelegate, KnockDetectorDelegate, CLLocationManagerDelegate>

@end

