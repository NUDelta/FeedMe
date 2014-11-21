//
//  KnockViewController.m
//  FeedMe
//
//  Created by Nicole Zhu on 10/29/14.
//  Copyright (c) 2014 Delta Hackers. All rights reserved.
//

#import "KnockViewController.h"

@interface KnockViewController ()
@property (weak, nonatomic) IBOutlet UIButton *foodButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *notificationSegmentControl;
@property (strong, nonatomic) knockDetector *detector;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation KnockViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewDidAppear:(BOOL)animated {
    /*self.theDetector = [[knockDetector alloc] init];
    self.theDetector.delegate = self;
    [self.theDetector.listener collectMotionInformationWithInterval:(10)];
    NSLog(@"started knock detection");*/
    [super viewDidAppear:animated];
}

/*- (void)stopTrackingLocation
{
    [locationManager stopUpdatingLocation];
}*/

- (void)viewDidLoad {
    /*[super viewDidLoad];
    // Do any additional setup after loading the view.
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^(void){}];
    [locationManager startUpdatingLocation];
    
    foodReport = [NSString stringWithFormat:@"Food"];*/
    [super viewDidLoad];
    [self initDetector];
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^(void){}];
    [self initLocationListener];
    [self initSegmentedControl];
    [self initUI];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)initSegmentedControl
{
    [self.notificationSegmentControl addTarget:self action:@selector(segmentedControlValueChanged) forControlEvents:UIControlEventValueChanged];
}

- (void)segmentedControlValueChanged
{
    [[PFUser currentUser] setObject:[self.notificationSegmentControl titleForSegmentAtIndex:[self.notificationSegmentControl selectedSegmentIndex]] forKey:@"notificationSelection"];
    [[PFUser currentUser] saveInBackground];
}

- (void)initLocationListener
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if ([self.locationManager respondsToSelector:@selector (requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    }
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^(void){}];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *) locations
{
    PFGeoPoint *currentGeoPoint = [PFGeoPoint geoPointWithLocation:[locations lastObject]];
    [[PFUser currentUser] setObject:currentGeoPoint forKey:@"currentLocation"];
    [[PFUser currentUser] setObject:[NSDate date] forKey:@"locationUpdateDate"];
    [[PFUser currentUser] saveInBackground];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusAuthorizedAlways) {
        [self.locationManager startUpdatingLocation];
    }
}

- (void)initDetector
{
    self.detector = [[knockDetector alloc] init];
    self.detector.delegate = self;
}

- (IBAction)trackButtonPressed:(id)sender
{
    UIButton *pressedButton = (UIButton *)sender;
    if (pressedButton.selected) {
        pressedButton.selected = NO;
        [self.detector.listener stopCollectingMotionInformation];
    } else {
        [self.detector.listener collectMotionInformationWithInterval:10];
        self.foodButton.selected = NO;
        pressedButton.selected = YES;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.foodButton.layer.backgroundColor = [[UIColor clearColor] CGColor];
}

-(void)detectorDidDetectKnock:(knockDetector *)detector
{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertBody = [NSString stringWithFormat:@"You reported free food!"];
    notification.soundName = @"short_double_low.wav";
    if ([notification respondsToSelector:@selector(alertAction)]) {
        //[notification setCategory:@"PICTURE_CATEGORY"];
    }
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    //[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Tapped"];
    // [self messageNearbyUsers];
    GazeTask *task = [[GazeTask alloc] init];
    task.question = @"Food in Ford?";
    task.lat = [NSNumber numberWithDouble:42.0549];
    task.lon = [NSNumber numberWithDouble:-87.6739];
    [task postTask];
    [self saveReport];
}

-(void)messageNearbyUsers
{
    CLLocation *currentLocation = self.locationManager.location;
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        NSString *placemarkString = [placemarks firstObject];
        /* sending out a push notification to nearby users */
        PFQuery *userQuery = [PFUser query];
        [userQuery whereKey:@"currentLocation"
               nearGeoPoint:[PFGeoPoint geoPointWithLocation:currentLocation]
           withinKilometers:1];
        /* when the user has been nearby within the last two minutes */
        [userQuery whereKey:@"locationUpdateDate" greaterThan:[NSDate dateWithTimeIntervalSinceNow:-120]];
        
        PFQuery *pushQuery = [PFInstallation query];
        [pushQuery whereKey:@"user" matchesQuery:userQuery];
        
        PFPush *push = [[PFPush alloc] init];
        [push setMessage:[NSString stringWithFormat:@"Someone reported free food at %@! Check it out.", placemarkString]];
        //[push setQuery:pushQuery];
        [push setChannel:@"global"];
        [push sendPushInBackground];
    }];
    PFPush *push = [[PFPush alloc] init];
    [push setMessage:@"Someone reported free food! Check it out."];
    //[push setQuery:pushQuery];
    [push setChannel:@"global"];
    [push sendPushInBackground];
}

- (void)initUI
{
    self.foodButton.layer.cornerRadius = 10;
    self.foodButton.clipsToBounds = YES;
    [self.foodButton setBackgroundImage:[UIImage imageWithColor:[UIColor lavenderColor]] forState:UIControlStateNormal];
    [self.foodButton setBackgroundImage:[UIImage imageWithColor:[UIColor midLavenderColor]] forState:UIControlStateHighlighted];
    [self.foodButton setBackgroundImage:[UIImage imageWithColor:[UIColor darkLavenderColor]] forState:UIControlStateSelected];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*- (void)detectorDidDetectKnock:(knockDetector*) detector
{
    CLLocation *currentLocation = self.locationManager.location;
    float latitude = currentLocation.coordinate.latitude;
    float longitude = currentLocation.coordinate.longitude;
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
}*/

- (void)saveReport
{
    CLLocation *location = self.locationManager.location;
    CLLocationCoordinate2D coordinate = [location coordinate];
    PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:coordinate.latitude
                                                  longitude:coordinate.longitude];
    PFObject *report = [PFObject objectWithClassName:@"FoodReport"];
    report[@"event"] = [NSString stringWithFormat:@"Food Report"];
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
