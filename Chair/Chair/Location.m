//
//  Location.m
//  Chair
//
//  Created by 최원영 on 2017. 1. 1..
//  Copyright © 2017년 최원영. All rights reserved.
//

#import "Location.h"

@implementation Location

-(id)initWithLocationInfo:(NSInteger)id withCity:(NSString*)city withCityDetail:(NSString*)cityDetail withLocation:(NSString*)location withLocationDetail:(NSString*)locationDetail {
    
    self = [super init];
    if (self) {
        
        _id = id;
        _city = city;
        _cityDetail = cityDetail;
        _location = location;
        _locationDetail = locationDetail;
        
    }
    return self;
}

@end
