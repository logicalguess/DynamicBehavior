//
//  ActivityEnum.m
//  WSEnumExample
//
//  Created by Ray Hilton on 29/11/11.
//  Copyright (c) 2011 Wirestorm Pty Ltd. All rights reserved.
//

#import "ActivityEnum.h"


@interface RunningActivityEnum : ActivityEnum @end
@interface WalkingActivityEnum : ActivityEnum @end
@interface CyclingActivityEnum : ActivityEnum @end

@implementation ActivityEnum
WS_ENUM(CyclingActivityEnum, CYCLING)
WS_ENUM(RunningActivityEnum, RUNNING)
WS_ENUM(WalkingActivityEnum, WALKING)
@end

@implementation CyclingActivityEnum
@end

@implementation WalkingActivityEnum
@end

@implementation RunningActivityEnum
@end