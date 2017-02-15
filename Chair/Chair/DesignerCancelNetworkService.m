//
//  DesignerCancelNetworkService.m
//  Chair
//
//  Created by 최원영 on 2017. 1. 11..
//  Copyright © 2017년 최원영. All rights reserved.
//

#import "DesignerCancelNetworkService.h"

@implementation DesignerCancelNetworkService
- (void)cancelMyDesignerRequest:(NSInteger)customerId withDesignerId:(NSInteger)designerId{
    NSLog(@"DesignerCancelNetworkService.h의 비동기 요청으로 들어옴");
    
    //URL String을 토대로 URL 객체를 만든 뒤, 이를 토대로 Request 객체를 생성한다.
    _aURLString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"UrlInfoByYoung"];
    _aURLString = [_aURLString stringByAppendingString:@"/designer/cancelmydesigner"];
    _aURL = [NSURL URLWithString:_aURLString];
    _aRequest = [NSMutableURLRequest requestWithURL:_aURL];
    
    //Request 객체를 Setting한다.
    [_aRequest setHTTPMethod:@"POST"];
    [_aRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [_aRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    //body에 전송할 변수를 넣는다.
    NSDictionary* bodyObject = @{
                                 @"customer_id": [NSNumber numberWithInteger:customerId],
                                 @"designer_id": [NSNumber numberWithInteger:designerId]
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
    NSLog(@"DesignerCancelNetworkService의 모든 통신이 완료됨");
    
    //결과를 파싱한다.
    NSDictionary *responseDataDic = [NSJSONSerialization
                                     JSONObjectWithData:_responseData
                                     options:NSJSONReadingMutableContainers
                                     error:nil];
    
    //결과가 있으면 적절한 키로 매핑하고, 없으면 없다는 메시지를 넣는다.
    NSDictionary *resultData;
    if(responseDataDic == nil || [responseDataDic count] == 0) {
        NSString *failString = @"fail";
        resultData = [NSDictionary dictionaryWithObject:failString forKey:@"result"];
    } else {
        //resultData에 결과를 넣는다.
        NSMutableDictionary *tempResultDictionary = [[NSMutableDictionary alloc] init];
        [tempResultDictionary setObject:responseDataDic forKey:@"resultDic"];
        
        resultData = tempResultDictionary;
    }
    
    //결과를 NSNotificationCenter로 보낸다.
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelMyDesignerResult" object:self userInfo:resultData];
    
}


/**
 *  [NSURLConnectionDelegate]애러나면 실행되는 코드
 */
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
}
@end
