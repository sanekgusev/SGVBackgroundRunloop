//
//  SGBackgroundRunloop.h
//  SGUtils
//
//  Created by Alexander Gusev on 5/12/13.
//  Copyright (c) 2013 sanekgusev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SGBackgroundRunloop : NSObject

+ (instancetype)runloop;

- (void)performBlock:(void(^)())block;

@end
