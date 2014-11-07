//
//  ViewController.h
//  FeedMe
//
//  Created by Nicole Zhu on 10/29/14.
//  Copyright (c) 2014 Delta Hackers. All rights reserved.
//

#import "AppDelegate.h"
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) NSArray *foodReports;
@property (weak, nonatomic) IBOutlet UITableView *reportTableView;

@end