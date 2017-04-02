//
//  CustomerListNetworkService.h
//  Chair
//
//  Created by 최원영 on 2017. 3. 30..
//  Copyright © 2017년 최원영. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomerListNetworkService : NSObject<NSURLConnectionDelegate>

//응답받은 변수
@property NSMutableData *responseData;

//네트워크 통신에 필요한 변수들
@property NSString *aURLString;
@property NSString *aFormData;
@property NSURL *aURL;
@property NSMutableURLRequest *aRequest;

//고객 정보 리스트를 호출하는 메소드
- (void)getCustomerListWithDesignerId:(NSString*)designerId;


@end
