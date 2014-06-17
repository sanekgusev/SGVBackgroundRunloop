//
//  SGBackgroundRunloop.h
//  SGUtils
//
//  Created by Alexander Gusev on 5/12/13.
//  Copyright (c) 2013 sanekgusev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SGVBackgroundRunloop : NSObject

- (void)performBlock:(void(^)(void))block;

@end
