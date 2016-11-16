//
//  TestNetwork.h
//  W6NetworkTest
//
//  Created by 최원영 on 2016. 11. 16..
//  Copyright © 2016년 최원영. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestNetwork : NSObject

//로그인 네트워크 통신에 필요한 변수들
@property NSString *aURLString;
@property NSString *aFormData;
@property NSURL *aURL;
@property NSMutableURLRequest *aRequest;

- (NSArray*)getTestDataForStudy;

@end
