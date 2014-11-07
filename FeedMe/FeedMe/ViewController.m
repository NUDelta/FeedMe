//
//  ViewController.m
//  FeedMe
//
//  Created by Nicole Zhu on 10/29/14.
//  Copyright (c) 2014 Delta Hackers. All rights reserved.
//

#import "ViewController.h"
#import <Parse/Parse.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController ()
@property (strong, nonatomic) CLLocationManager *locationManager;
@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^(void){}];
    [self initLocationListener];

    //self.foodReports = [[NSArray alloc] initWithObjects: @"Food 1", @"Food 2", @"Food 3", nil];
}

- (void) initLocationListener {
    NSLog(@"made it to starti");
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
   
//    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
//        [self.locationManager requestAlwaysAuthorization];
//        NSLog(@"made it here");
//    }
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager requestWhenInUseAuthorization];
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];

    NSLog(@"made it to end");
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^(void){}];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    NSLog(@"Test %@", [locations lastObject]);
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedAlways) {
        [self.locationManager startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    // Delegate of the location manager, when you have an error
    NSLog(@"didFailWithError: %@", error);
    
    UIAlertView *errorAlert = [[UIAlertView alloc]     initWithTitle:NSLocalizedString(@"application_name", nil) message:NSLocalizedString(@"location_error", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles:nil];
    
    [errorAlert show];
}

- (void) initUI {
    // format times
    /*NSDate *localDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"YYYY-MM-dd hh:mm";
    // [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss Z"];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    NSLog(@"The Current Time is the following %@",[dateFormatter stringFromDate:localDate]);
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:localDate];
    NSInteger day = [components day];
    NSLog(@"component day %d", day);*/
    // [dateFormatter release];
    // NSLog(@"date is %@", localDate);
    // table view
    self.reportTableView.delegate = self;
    self.reportTableView.dataSource = self;
    PFQuery *query = [PFQuery queryWithClassName:@"FoodReport"];
    [query setLimit:1000];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            _foodReports = [[NSArray alloc]initWithArray:objects];
            // find succeeded, first 100 objects available in objects
            NSLog(@"Success %d", self.foodReports.count);
            for (PFObject *object in self.foodReports) {
                NSLog(@"%@", object.createdAt);
//                NSLog(@"formatted time is %@", [dateFormatter stringFromDate:object.createdAt]);
//                NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:object.createdAt];
//                NSInteger day = [components day];
//                NSLog(@"component day of object %d", day);
//                //NSString *location = object[@"location"];
//                //NSLog(@"%@", location);
//                NSTimeInterval secondsBetween = [object.createdAt timeIntervalSinceDate:localDate];
//                
//                int numberOfDays = (secondsBetween / 86400) * -1;
//                
//                NSLog(@"Food was reported %d days ago.", numberOfDays);
            }
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        [self.reportTableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.foodReports count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    /*static NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.timeStyle = NSDateFormatterMediumStyle;
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    }*/
    
    static NSNumberFormatter *numberFormatter = nil;
    if (numberFormatter == nil) {
        numberFormatter = [[NSNumberFormatter alloc] init];
        numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        numberFormatter.maximumFractionDigits = 3;
    }
    
    static NSString *CellIdentifier = @"Cell";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    //PFObject *tempObject = [self.foodReports objectAtIndex:indexPath.row];
    //cell.textLabel.text = [tempObject objectForKey:@"event"];
    PFObject *tempObject = [self.foodReports objectAtIndex:indexPath.row];
    PFGeoPoint *geoPoint = [tempObject objectForKey:@"location"];
    double lat = geoPoint.latitude;
    //NSLog(@"%@", tempObject);
    //NSLog(@"Geopoint: %@", geoPoint);
    //NSLog(@"Latitude: %f", lat);
    NSDate *localDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"YYYY-MM-dd hh:mm";
    // [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss Z"];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    NSLog(@"The Current Time is the following %@",[dateFormatter stringFromDate:localDate]);
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:localDate];
    NSInteger day = [components day];
    //NSString *location = object[@"location"];
    //NSLog(@"%@", location);
    NSTimeInterval secondsBetween = [tempObject.createdAt timeIntervalSinceDate:localDate];
    int numberOfMinutes = (secondsBetween / 60) * -1;
    int numberOfHours = (secondsBetween / 3600) * -1;
    int numberOfDays = (secondsBetween / 86400) * -1;
    
    NSLog(@"Food was reported %d days, %d hours ago.", numberOfDays, numberOfHours);
    
    // conditional cell formatting
    cell.textLabel.text = [dateFormatter stringFromDate:tempObject.updatedAt];
    if (numberOfMinutes > 60 && numberOfHours < 24) {
        NSString *string = [NSString stringWithFormat:@"Food was reported %d hours ago.", numberOfHours];
        cell.detailTextLabel.text = string;
    } else if (numberOfHours > 24) {
        NSString *string = [NSString stringWithFormat:@"Food was reported %d days ago.", numberOfDays];
        cell.detailTextLabel.text = string;
    } else {
        NSString *string = [NSString stringWithFormat:@"Food was reported %d minutes ago.", numberOfMinutes];
        cell.detailTextLabel.text = string;
    }
//    NSString *string = [NSString stringWithFormat:@"Food was reported %d days ago, %d hours, %d minutes ago.", numberOfDays, numberOfHours, numberOfMinutes];
//    NSString *string = [NSString stringWithFormat:@"%@, %@",
//                        [numberFormatter stringFromNumber:[NSNumber numberWithDouble:geoPoint.latitude]],
//                        [numberFormatter stringFromNumber:[NSNumber numberWithDouble:geoPoint.longitude]]];
    
    //cell.textLabel.text = [self.foodReports objectAtIndex:indexPath.row];
    return cell;
}

@end
