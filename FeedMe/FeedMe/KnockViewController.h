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
#import <Parse/Parse.h>
#import "coreMotionListener.h"
#import "knockDetector.h"

@interface KnockViewController : UIViewController<KnockDetectorDelegate, CLLocationManagerDelegate>
- (void)detectorDidDetectKnock:(knockDetector*) detector;
@property knockDetector *theDetector;
@property (strong, nonatomic) NSString *foodReport;
- (void)saveReport;
- (void)stopTrackingLocation;
@end

