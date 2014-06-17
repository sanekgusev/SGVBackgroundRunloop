//
//  SGBackgroundRunloop.m
//  SGUtils
//
//  Created by Alexander Gusev on 5/12/13.
//  Copyright (c) 2013 sanekgusev. All rights reserved.
//

#import "SGVBackgroundRunloop.h"
#import "SGVBackgroundRunloopThreadHelper.h"

@interface SGVBackgroundRunloop () {
    NSThread *_backgroundThread;
    SGVBackgroundRunloopThreadHelper *_helper;
}

@end

@implementation SGVBackgroundRunloop

#pragma mark - init/dealloc

- (id)init {
    if (self = [super init]) {
        _helper = [SGVBackgroundRunloopThreadHelper new];
        _backgroundThread = [[NSThread alloc] initWithTarget:_helper
                                                    selector:@selector(backgroundThreadFunction:)
                                                      object:nil];
        [_backgroundThread setName:[NSString stringWithFormat:@"com.sanekgusev.SGVBackroundRunloop.thread-%p", self]];
        [_backgroundThread start];
    }
    return self;
}

- (void)dealloc {
    [self stopRunloop];
}

#pragma mark - Public

- (void)performBlock:(void(^)(void))block {
    [self performBlock:block waitUntilDone:NO];
}

#pragma mark - Private

- (void)performBlock:(void(^)(void))block waitUntilDone:(BOOL)wait {
    if (block) {
        [self performSelector:@selector(workerMethod:)
                     onThread:_backgroundThread
                   withObject:block
                waitUntilDone:wait];
    }
}

- (void)workerMethod:(id)object {
    NSCParameterAssert(object);
    void (^block)(void) = (void(^)(void))object;
    block();
}

- (void)stopRunloop {
    [self performBlock:^{
        CFRunLoopStop(CFRunLoopGetCurrent());
    } waitUntilDone:YES];
}

@end
