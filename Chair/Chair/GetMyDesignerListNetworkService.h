//
//  GetMyDesignerListNetworkService.h
//  Chair
//
//  Created by 최원영 on 2017. 1. 14..
//  Copyright © 2017년 최원영. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetMyDesignerListNetworkService : NSObject

//응답받은 변수
@property NSMutableData *responseData;

//네트워크에 필요한 변수들
@property NSString *aURLString;
@property NSString *aFormData;
@property NSURL *aURL;
@property NSMutableURLRequest *aRequest;

//내 디자이너 정보를 가져오는 네트워크 요청(고객id)
- (void)getMyDesignerListRequest:(NSInteger)customerId;

@end
