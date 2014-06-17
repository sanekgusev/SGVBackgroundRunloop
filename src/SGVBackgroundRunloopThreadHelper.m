//
//  SGVBackgroundRunloopThreadHelper.m
//  SGVBackgroundRunloop
//
//  Created by Alexander Gusev on 17/06/14.
//  Copyright (c) 2014 sanekgusev. All rights reserved.
//

#import "SGVBackgroundRunloopThreadHelper.h"

@implementation SGVBackgroundRunloopThreadHelper

#pragma mark - Public

- (void)backgroundThreadFunction:(id) __unused argument {
    @autoreleasepool {
        NSTimer *fakeTimer = [NSTimer scheduledTimerWithTimeInterval:[[NSDate distantFuture] timeIntervalSinceNow]
                                                              target:self
                                                            selector:@selector(fakeTimerCallback:)
                                                            userInfo:nil
                                                             repeats:NO];
        CFRunLoopRun();
        [fakeTimer invalidate];
    }
}

#pragma mark - Private

- (void)fakeTimerCallback:(NSTimer *) __unused timer {
    NSCAssert(NO, @"This method should never be called");
}

@end
