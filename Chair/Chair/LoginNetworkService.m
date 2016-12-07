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
 */
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


/**
 *  로그인을 위한 HTTP 요청 (동기): 동기 방식은 쓰지 않음
 */
- (NSDictionary*)sendLoginRequest:(NSString*)email withPassword:(NSString*)password
{
    //받은 email과 password를 인스턴스 변수와 연결한다.
    _email = email;
    _password = password;
    
    //URL String을 토대로 URL 객체를 만든 뒤, 이를 토대로 Request 객체를 생성한다.
    _aURLString = @"http://10.73.43.40:3000/customer/selectone";
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
    
    //결과를 로그로 보여준다(JSON에서 한글이 깨지는게 아니라 주소값이 보여지는 것 뿐이다)
    NSLog(@"login response = %ld", (long)aResponse.statusCode);
    NSLog(@"login result = %@", dataDictionary );
    NSDictionary *loctaion = dataDictionary[@"location"];
    NSLog(@"login result -> location -> city= %@", loctaion[@"city"] );

    
    //결과를 리턴한다.
    return dataDictionary;
    
}


/**
 *  로그인을 위한 HTTP 요청 (비동기)
 */
- (void)sendLoginAsynchronousRequest:(NSString*)email withPassword:(NSString*)password{
    
    //받은 email과 password를 인스턴스 변수와 연결한다.
    _email = email;
    _password = password;
    
    //URL String을 토대로 URL 객체를 만든 뒤, 이를 토대로 Request 객체를 생성한다.
    _aURLString = @"http://10.73.43.40:3000/customer/selectone";
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
    
    // Create url connection and fire request
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:_aRequest delegate:self];
    
    [conn start];
    
}


/**
 *  [NSURLConnectionDelegate]Response에서 Header부분을 받고 호출되는 메소드
 */
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    //응답받을 데이터 변수를 초기화한다.
    _responseData = [[NSMutableData alloc] init];
    
}


/**
 *  [NSURLConnectionDelegate]Response에서 데이터를 받는 메소드
 */
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {

    //응답받은 데이터를 붙인다(데이터가 크면 여러번 실행될 수 있다)
    [_responseData appendData:data];
    
}


/**
 *  [NSURLConnectionDelegate]
 */
- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}


/**
 *  [NSURLConnectionDelegate] 모든 통신이 완료된 후 실행되는 메소드
 */
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    
    //결과를 파싱한다.
    NSDictionary *dataDictionary = [NSJSONSerialization
                                    JSONObjectWithData:_responseData
                                    options:NSJSONReadingMutableContainers
                                    error:nil];
    
    //결과를 적절한 키로 매핑한다.
    NSDictionary *resultData = [NSDictionary dictionaryWithObject:dataDictionary forKey:@"loginResult"];
    
    //결과를 NSNotificationCenter로 보낸다.
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loginResult" object:self userInfo:resultData];
    
}


/**
 *  [NSURLConnectionDelegate]애러나면 실행되는 코드
 */
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
}

@end
