//
//  KnockViewController.m
//  FeedMe
//
//  Created by Nicole Zhu on 10/29/14.
//  Copyright (c) 2014 Delta Hackers. All rights reserved.
//

#import "KnockViewController.h"

@interface KnockViewController ()

@end

@implementation KnockViewController {
    CLLocationManager *locationManager;
    NSString *clickedEvent;
}
@synthesize foodReport;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewDidAppear:(BOOL)animated {
    self.theDetector = [[knockDetector alloc] init];
    self.theDetector.delegate = self;
    [self.theDetector.listener collectMotionInformationWithInterval:(10)];
    NSLog(@"started knock detection");
}

- (void)stopTrackingLocation
{
    [locationManager stopUpdatingLocation];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^(void){}];
    [locationManager startUpdatingLocation];
    
    foodReport = [NSString stringWithFormat:@"Food"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)detectorDidDetectKnock:(knockDetector*) detector
{
    float latitude = locationManager.location.coordinate.latitude;
    float longitude = locationManager.location.coordinate.longitude;
    NSLog(@"Did detect knock");
    
    
    //[self performSegueWithIdentifier:@"reportSuccess" sender:self];
    [self saveReport];
    
    NSLog(@"Latitude: %f", latitude);
    NSLog(@"Longitude: %f", longitude);
    NSLog(@"Event: food");
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertBody = [NSString stringWithFormat:@"You reported some food"];
    notification.soundName = @"short_double_low.wav";
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
}

- (void)saveReport
{
    CLLocation *location = [locationManager location];
    CLLocationCoordinate2D coordinate = [location coordinate];
    PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:coordinate.latitude
                                                  longitude:coordinate.longitude];
    PFObject *report = [PFObject objectWithClassName:@"FoodReport"];
    report[@"event"] = [NSString stringWithFormat:@"%@", foodReport];
    report[@"location"] = geoPoint;
    NSLog(@"%@", report);
    [report saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSLog(@"saved successfully");
            //NSLog(@"%@", report);
        } else {
            NSLog(@"error: didn't save");
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
