//
//  GetPriceInfoOfDesigner.h
//  Chair
//
//  Created by 최원영 on 2017. 2. 27..
//  Copyright © 2017년 최원영. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetPriceInfoOfDesigner : NSObject<NSURLConnectionDelegate>

//응답받은 변수
@property NSMutableData *responseData;

//회원가입 네트워크 통신에 필요한 변수들
@property NSString *aURLString;
@property NSString *aFormData;
@property NSURL *aURL;
@property NSMutableURLRequest *aRequest;

//디자이너의 가격 정보 리스트를 불러오는 네트워크 요청(디자이너id / 디자이너가 속한 헤어샵id)
- (void)getPriceInfoOfDesignerRequest:(NSInteger)designerId withHairshopId:(NSInteger)hairshopId;

@end
