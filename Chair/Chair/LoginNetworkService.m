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
 *  로그인을 위한 HTTP 요청 (비동기)
 */
- (void)sendLoginAsynchronousRequest:(NSString*)uid{
    
    NSLog(@"LoginNetworkService의 비동기 요청으로 들어옴");
    
    //받은 uid를 인스턴스 변수와 연결한다.
    _uid = uid;
    
    //URL String을 토대로 URL 객체를 만든 뒤, 이를 토대로 Request 객체를 생성한다.
    _aURLString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"UrlInfoByYoung"];
    _aURLString = [_aURLString stringByAppendingString:@"/customer/selectone"];
    _aURL = [NSURL URLWithString:_aURLString];
    _aRequest = [NSMutableURLRequest requestWithURL:_aURL];
    
    //Request 객체를 Setting한다.
    [_aRequest setHTTPMethod:@"POST"];
    [_aRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [_aRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    //body에 전송할 변수를 넣는다.
    NSDictionary* bodyObject = @{
                                 @"uid": _uid
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
    
    //받은 값이 없으면 그냥 리턴한다(원래는 애러 코드에 맞는 다이얼로그를 보여줄 것)
    if(dataDictionary == nil) return;
    
    
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
