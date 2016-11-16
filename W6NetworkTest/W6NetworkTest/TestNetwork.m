//
//  TestNetwork.m
//  W6NetworkTest
//
//  Created by 최원영 on 2016. 11. 16..
//  Copyright © 2016년 최원영. All rights reserved.
//
//  과제용 테스트 데이터를 네트워크에서 받아옵니다.
//

#import "TestNetwork.h"

@implementation TestNetwork

/**
*  로그인을 위한 HTTP 요청
**/
- (NSArray*)getTestDataForStudy
{
    
    //URL String을 토대로 URL 객체를 만든 뒤, 이를 토대로 Request 객체를 생성한다.
    _aURLString = @"http://125.209.194.123/list.php";
    _aURL = [NSURL URLWithString:_aURLString];
    _aRequest = [NSMutableURLRequest requestWithURL:_aURL];
    
    //Request 객체를 Setting한다.
    [_aRequest setHTTPMethod:@"GET"];
    
    //Response에 필요한 객체들을 생성한다.
    NSHTTPURLResponse *aResponse;
    NSError *aError;
    
    //요청을 보내고, 결과를 받는다.
    NSData *aResultData = [NSURLConnection sendSynchronousRequest:_aRequest returningResponse:&aResponse error:&aError];
    
    //결과를 파싱한다.
    NSArray *dataArray = [NSJSONSerialization
                                    JSONObjectWithData:aResultData
                                    options:NSJSONReadingMutableContainers
                                    error:nil];
    
    //결과를 로그로 보여준다.
    NSLog(@"login response = %ld", (long)aResponse.statusCode);
    NSLog(@"login result = %@", dataArray );
    
    //결과를 리턴한다.
    return dataArray;
    
}


@end
