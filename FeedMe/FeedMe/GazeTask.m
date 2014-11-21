//
//  GazeTask.m
//  FeedMe
//
//  Created by Nicole Zhu on 11/21/14.
//  Copyright (c) 2014 Delta Hackers. All rights reserved.
//

#import "GazeTask.h"

@implementation GazeTask

-(void)postTask
{
    [[RKObjectManager sharedManager] postObject:self path:nil parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"success");
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"failed");
    }];
}

@end
