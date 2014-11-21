//
//  GazeTask.h
//  FeedMe
//
//  Created by Nicole Zhu on 11/21/14.
//  Copyright (c) 2014 Delta Hackers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface GazeTask : NSObject

@property (strong, nonatomic) NSString *question;
@property (strong, nonatomic) NSNumber *lat;
@property (strong, nonatomic) NSNumber *lon;

-(void)postTask;

@end
