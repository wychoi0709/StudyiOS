//
//  Location.h
//  Chair
//
//  Created by 최원영 on 2017. 1. 1..
//  Copyright © 2017년 최원영. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Location : NSObject

@property NSInteger id;
@property NSString *city;           //서울
@property NSString *cityDetail;     //서울 강남
@property NSString *location;       //서울 강남 홍대, 신촌
@property NSString *locationDetail; //홍대

-(id)initWithLocationInfo:(NSInteger)id withCity:(NSString*)city withCityDetail:(NSString*)cityDetail withLocation:(NSString*)location withLocationDetail:(NSString*)locationDetail;

@end
