//
//  Location.h
//  Chair
//
//  Created by 최원영 on 2016. 12. 10..
//  Copyright © 2016년 최원영. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Location : NSObject

@property int id;
@property NSString *city;           //서울
@property NSString *cityDetail;     //서울 강남
@property NSString *location;       //서울 강남 홍대, 신촌
@property NSString *locationDetail; //홍대

@end
