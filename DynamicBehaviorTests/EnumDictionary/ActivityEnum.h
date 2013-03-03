//
//  ActivityEnum.h
//  WSEnumExample
//
//  Created by Ray Hilton on 29/11/11.
//  Copyright (c) 2011 Wirestorm Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WSEnum.h"

@interface ActivityEnum : WSEnum
+ (ActivityEnum*)WALKING;
+ (ActivityEnum*)RUNNING;
+ (ActivityEnum*)CYCLING;
@end
