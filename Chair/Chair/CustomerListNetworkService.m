//
//  CustomerListNetworkService.m
//  Chair
//
//  Created by 최원영 on 2017. 3. 30..
//  Copyright © 2017년 최원영. All rights reserved.
//

#import "CustomerListNetworkService.h"

@implementation CustomerListNetworkService

/*****************************************************************
 *   << 초기화 및 네트워크 요청 메소드 >>
 *****************************************************************/
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        //URL String을 토대로 URL 객체를 만든 뒤, 이를 토대로 Request 객체를 생성한다.
        _aURLString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"UrlInfoByYoung"];
        
    }
    return self;
}

- (void)getCustomerListWithDesignerId:(NSString*)designerId{
    
    NSString* readingURLString = [_aURLString stringByAppendingString:@"/permitted/customers"];
    _aURL = [NSURL URLWithString:readingURLString];
    _aRequest = [NSMutableURLRequest requestWithURL:_aURL];
    
    [self basicRequestObjectSetting];
    
    //body에 전송할 변수를 넣고 전송한다.
    NSDictionary* bodyObject = @{ @"designerId": designerId };
    _aRequest.HTTPBody = [NSJSONSerialization dataWithJSONObject:bodyObject options:kNilOptions error:nil];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:_aRequest delegate:self];
    [conn start];
    
}

/*****************************************************************
 *   << 콜백 메소드 >>
 *****************************************************************/
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
    NSLog(@"고객 리스트 네트워크 요청이 끝나고 결과를 보낸다.");
    
    //결과를 파싱한다.
    NSMutableArray *dataArray = [NSJSONSerialization
                                    JSONObjectWithData:_responseData
                                    options:NSJSONReadingMutableContainers
                                    error:nil];
    
    
    NSDictionary *resultData;
    //받은 값이 없으면 그냥 리턴한다(원래는 애러 코드에 맞는 다이얼로그를 보여줄 것)
    if(dataArray == nil) {
        //결과를 NSNotificationCenter로 보낸다.
        [[NSNotificationCenter defaultCenter] postNotificationName:@"noCustomerListResult" object:self userInfo:nil];
        
    } else {
    
        //결과를 적절한 키로 매핑한다.
        resultData = [NSDictionary dictionaryWithObject:dataArray forKey:@"customerListResult"];
        //결과를 NSNotificationCenter로 보낸다.
        [[NSNotificationCenter defaultCenter] postNotificationName:@"customerListResult" object:self userInfo:resultData];

    }
    
}


/**
 *  [NSURLConnectionDelegate]애러나면 실행되는 코드
 */
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
}


/*****************************************************************
 *   << 내가 만든 메소드 >>
 *****************************************************************/
- (void)basicRequestObjectSetting {
    
    //Request 객체를 Setting한다.
    [_aRequest setHTTPMethod:@"POST"];
    [_aRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [_aRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
}
@end
