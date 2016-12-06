//
//  LoginNetworkService.h
//  Chair
//
//  Created by 최원영 on 2016. 11. 23..
//  Copyright © 2016년 최원영. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginNetworkService : NSObject<NSURLConnectionDelegate>

//ConnectionDelegate에서 쓸 변수(응답받은 변수인듯)
@property NSMutableData *responseData;

//로그인 네트워크 통신에 필요한 변수들
@property NSString *aURLString;
@property NSString *aFormData;
@property NSURL *aURL;
@property NSMutableURLRequest *aRequest;

//email, password 인스턴스 변수
@property NSString *email;
@property NSString *password;

- (NSDictionary*)sendLoginRequest:(NSString*)email withPassword:(NSString*)password;
- (void)sendLoginAsynchronousRequest:(NSString*)email withPassword:(NSString*)password;


@end
