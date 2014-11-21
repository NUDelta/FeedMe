//
//  RestKitManager.h
//  FeedMe
//
//  Created by Nicole Zhu on 11/21/14.
//  Copyright (c) 2014 Delta Hackers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit.h>
#import "GazeTask.h"

@interface RestKitManager : NSObject

+(RestKitManager *)sharedManager;

@end
