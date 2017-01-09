//
//  DesignerRankingNetworkService.h
//  Chair
//
//  Created by 최원영 on 2017. 1. 5..
//  Copyright © 2017년 최원영. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DesignerRankingNetworkService : NSObject<NSURLConnectionDelegate>

//응답받은 변수
@property NSMutableData *responseData;

//회원가입 네트워크 통신에 필요한 변수들
@property NSString *aURLString;
@property NSString *aFormData;
@property NSURL *aURL;
@property NSMutableURLRequest *aRequest;

//디자이너 리스트를 불러오는 네트워크 요청(고객id, 지역id, 성별_F/M)
- (void)callDesignerListByLocationIdRequest:(NSInteger)customerId withLocationId:(NSInteger)locationId withGender:(NSString*)gender;

@end
