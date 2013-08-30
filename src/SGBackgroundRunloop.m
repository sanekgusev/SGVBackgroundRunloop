//
//  SGBackgroundRunloop.m
//  SGUtils
//
//  Created by Alexander Gusev on 5/12/13.
//  Copyright (c) 2013 sanekgusev. All rights reserved.
//

#import "SGBackgroundRunloop.h"
#import "SGUnretainedObjectProxy.h"

@interface SGBackgroundRunloop () {
    NSThread *_backgroundThread;
    SGBackgroundRunloop *_selfProxy;
}

@end

@implementation SGBackgroundRunloop

#pragma mark - init/dealloc

- (id)init {
    if (self = [super init]) {
        _selfProxy = (SGBackgroundRunloop *)[SGUnretainedObjectProxy proxyWithNonRetainedObject:self];
        _backgroundThread = [[NSThread alloc] initWithTarget:_selfProxy
                                                    selector:@selector(backgroundThreadFunction:)
                                                      object:nil];
        [_backgroundThread start];
    }
    return self;
}

- (void)dealloc {
    [self stopRunloop];
}

#pragma mark - public

+ (instancetype)runloop {
    return [[self alloc] init];
}

- (void)performBlock:(void(^)())block {
    [self performBlock:block waitUntilDone:NO];
}

#pragma mark - private

- (void)backgroundThreadFunction:(id)unused {
    @autoreleasepool {
        NSTimer *fakeTimer = [NSTimer scheduledTimerWithTimeInterval:[[NSDate distantFuture] timeIntervalSinceNow]
                                                              target:_selfProxy
                                                            selector:@selector(fakeTimerCallback:)
                                                            userInfo:nil
                                                             repeats:NO];
        CFRunLoopRun();
        [fakeTimer invalidate];
    }
}

- (void)fakeTimerCallback:(NSTimer *)timer {
    NSCAssert(NO, @"This method should never be called");
}

- (void)performBlock:(void(^)())block waitUntilDone:(BOOL)wait {
    if (block) {
        // is -performSelector:onThread: thread-safe?
        [_selfProxy performSelector:@selector(workerMethod:)
                           onThread:_backgroundThread
                         withObject:(id)[block copy]
                      waitUntilDone:wait];
    }
}

- (void)workerMethod:(id)object {
    NSCParameterAssert(object);
    void (^block)() = (void(^)())object;
    block();
}

- (void)stopRunloop {
    [self performBlock:^{
        CFRunLoopStop(CFRunLoopGetCurrent());
    }];
}

@end
