//
//  LoginNetworkService.m
//  Chair
//
//  Created by 최원영 on 2016. 11. 23..
//  Copyright © 2016년 최원영. All rights reserved.
//

#import "LoginNetworkService.h"

@implementation LoginNetworkService

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
- (NSDictionary*)sendLoginRequest:(NSString*)email withPassword:(NSString*)password
{
    //받은 email과 password를 인스턴스 변수와 연결한다.
    _email = email;
    _password = password;
    
    //URL String을 토대로 URL 객체를 만든 뒤, 이를 토대로 Request 객체를 생성한다.
    _aURLString = @"http://192.168.1.238:3000/customer/selectone";
    _aURL = [NSURL URLWithString:_aURLString];
    _aRequest = [NSMutableURLRequest requestWithURL:_aURL];
    
    //Request 객체를 Setting한다.
    [_aRequest setHTTPMethod:@"POST"];
    [_aRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [_aRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    //body에 전송할 변수를 넣는다.
    NSDictionary* bodyObject = @{
                                 @"email": _email,
                                 @"password": _password
                                 };
    _aRequest.HTTPBody = [NSJSONSerialization dataWithJSONObject:bodyObject options:kNilOptions error:nil];
    
    //Response에 필요한 객체들을 생성한다.
    NSHTTPURLResponse *aResponse;
    NSError *aError;
    
    //요청을 보내고, 결과를 받는다.
    NSData *aResultData = [NSURLConnection sendSynchronousRequest:_aRequest returningResponse:&aResponse error:&aError];    //sendSychronousRequest는 동기화 방식이어서 갔다 올 때까지 기다린다. 네트워크 단에서 타이머가 결정되어 있기 때문에, 클라이언트에서 로직을 넣어줘야한다.
    
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


@end
