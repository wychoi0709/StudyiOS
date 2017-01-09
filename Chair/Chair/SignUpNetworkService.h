//
//  SignUpNetworkService.h
//  Chair
//
//  Created by 최원영 on 2017. 1. 1..
//  Copyright © 2017년 최원영. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SignUpNetworkService : NSObject<NSURLConnectionDelegate>

//ConnectionDelegate에서 쓸 변수(응답받은 변수인듯)
@property NSMutableData *responseData;

//회원가입 네트워크 통신에 필요한 변수들
@property NSString *aURLString;
@property NSString *aFormData;
@property NSURL *aURL;
@property NSMutableURLRequest *aRequest;

//name, email, password, location 인스턴스 변수
@property NSString *name;
@property NSString *email;
@property NSString *password;
@property NSInteger locationId;

//회원가입하는 메소드
- (void)sendSignUpAsynchronousRequest:(NSString*)name withEmail:(NSString*)email withPassword:(NSString*)password withLocationId:(NSInteger)locationId;

@end
