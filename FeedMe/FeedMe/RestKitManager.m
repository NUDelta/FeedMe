//
//  RestKitManager.m
//  FeedMe
//
//  Created by Nicole Zhu on 11/21/14.
//  Copyright (c) 2014 Delta Hackers. All rights reserved.
//

#import "RestKitManager.h"

@implementation RestKitManager

#define BASE_URL (@"http://gaze.ngrok.com/api/v1")

+(RestKitManager *)sharedManager
{
    static RestKitManager *manager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        manager = [[RestKitManager alloc] init];
    });
    return manager;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self initRKObjectManagerAndRouter];
        [self initGazeTaskObjectMapping];
    }
    return self;
}

-(void)initRKObjectManagerAndRouter
{
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:BASE_URL]];
    RKRouter *router = [[RKRouter alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
    objectManager.router = router;
}

-(void)initGazeTaskObjectMapping
{
    RKObjectMapping *taskMapping = [RKObjectMapping mappingForClass:[GazeTask class]];
    [taskMapping addAttributeMappingsFromDictionary:@{
                                                      @"question" : @"question",
                                                      @"lat":@"lat",
                                                      @"lon":@"lon"
                                                      }];
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:taskMapping method:RKRequestMethodAny pathPattern:@"tasks/new" keyPath:@"task" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [[RKObjectManager sharedManager] addResponseDescriptor:responseDescriptor];
}

@end
