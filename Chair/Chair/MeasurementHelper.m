//
//  MeasurementHelper.m
//  Chair
//
//  Created by 최원영 on 2017. 2. 26..
//  Copyright © 2017년 최원영. All rights reserved.
//

#import "MeasurementHelper.h"
@import Firebase;

@implementation MeasurementHelper

+ (void)sendLoginEvent {
    [FIRAnalytics logEventWithName:kFIREventLogin parameters:nil];
}

+ (void)sendLogoutEvent {
    [FIRAnalytics logEventWithName:@"logout" parameters:nil];
}

+ (void)sendMessageEvent{
    [FIRAnalytics logEventWithName:@"message" parameters:nil];
}

@end
