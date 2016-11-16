//
//  LoginNextwork.m
//  W6NetworkTest
//
//  Created by 최원영 on 2016. 11. 9..
//  Copyright © 2016년 최원영. All rights reserved.
//

#import "LoginNextwork.h"

@implementation LoginNextwork

/**
 *  초기화 함수(아직 초기화할게 없음)
 **/
- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}


/**
 *  로그인을 위한 HTTP 요청
 **/
- (NSDictionary*)sendLoginRequest
{
    
    //URL String을 토대로 URL 객체를 만든 뒤, 이를 토대로 Request 객체를 생성한다.
    _aURLString = @"http://125.209.195.85:8080/api/user/login";
    _aURL = [NSURL URLWithString:_aURLString];
    _aRequest = [NSMutableURLRequest requestWithURL:_aURL];
    
    //Request 객체를 Setting한다.
    [_aRequest setHTTPMethod:@"POST"];
    [_aRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [_aRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    //body에 전송할 변수를 넣는다.
    NSDictionary* bodyObject = @{
                                 @"userEmail": @"ljyhanll@gmail.com",
                                 @"userPassword": @"woduq"
                                 };
    _aRequest.HTTPBody = [NSJSONSerialization dataWithJSONObject:bodyObject options:kNilOptions error:nil];

    //Response에 필요한 객체들을 생성한다.
    NSHTTPURLResponse *aResponse;
    NSError *aError;
    
    //요청을 보내고, 결과를 받는다.
    NSData *aResultData = [NSURLConnection sendSynchronousRequest:_aRequest returningResponse:&aResponse error:&aError];
    
    //결과를 파싱한다.
    NSDictionary *dataDictionary = [NSJSONSerialization
                                    JSONObjectWithData:aResultData
                                    options:NSJSONReadingMutableContainers
                                    error:nil];
    
    //결과를 로그로 보여준다.
    NSLog(@"login response = %ld", (long)aResponse.statusCode);
    NSLog(@"login result = %@", dataDictionary );
    
    //결과를 리턴한다.
    return dataDictionary;
    
}


/**
 *  회원가입을 위한 HTTP 요청
 **/
- (void)sendSignupRequest
{
    
    //URL 및 들어갈 변수를 선언한다.
    _aURLString = @"http://125.209.195.85:8080/api/user/signup";
    _aFormData = @"id=ios&passwd=ios";
    
    //URL String을 토대로 URL 객체를 만든다.
    _aURL = [NSURL URLWithString:_aURLString];
    _aRequest = [NSMutableURLRequest requestWithURL:_aURL];

    //Request 객체를 생성한다.
    [_aRequest setHTTPMethod:@"POST"];
    [_aRequest setHTTPBody: [_aFormData dataUsingEncoding:NSUTF8StringEncoding]];
    
}


/**
 *  교수님 샘플
 */

@end
