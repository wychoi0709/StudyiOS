//
//  EditMyPageNetworkService.m
//  Chair
//
//  Created by 최원영 on 2017. 2. 16..
//  Copyright © 2017년 최원영. All rights reserved.
//

#import "EditMyPageNetworkService.h"

@implementation EditMyPageNetworkService

- (void)editMyInfo:(NSInteger)customerId withLocationId:(NSInteger)locationId withGender:(NSString*)gender withName:(NSString*)name withPicture:(NSData*)picture withIsFilenameInUserInfo:(NSNumber*)isFilenameInUserInfo withUid:(NSString*)uid {
    
    //URL String을 토대로 URL 객체를 만든 뒤, 이를 토대로 Request 객체를 생성한다.
    _aURLString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"UrlInfoByYoung"];
    _aURLString = [_aURLString stringByAppendingString:@"/customer/updatemyinfo"];
    _aURL = [NSURL URLWithString:_aURLString];
    _aRequest = [NSMutableURLRequest requestWithURL:_aURL];
    
    //URL String을 토대로 URL 객체를 만든 뒤, 이를 토대로 Request 객체를 생성한다.
    NSString *boundary = [NSString stringWithFormat:@"Boundary-%@", [[NSUUID UUID] UUIDString]];;
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    
    NSDictionary *params;
    
    //파일 정보가 userInfo에 있다면,
    if (isFilenameInUserInfo) {
        
        //userInfo에서 꺼내서 담는다.
        NSMutableDictionary *_userInfo = [[NSMutableDictionary alloc] init];
        NSUserDefaults *_standardDefault = [NSUserDefaults standardUserDefaults];
        _userInfo = [[_standardDefault objectForKey:@"userInfo"] mutableCopy];
        
        NSString *filename = [_userInfo objectForKey:@"filename"];
        
        params = @{@"id" : [NSNumber numberWithInteger:customerId],
                   @"location_id"    : [NSNumber numberWithInteger:locationId],
                   @"sex" : gender,
                   @"name" : name,
                   @"filename" :  filename,
                   @"uid" : uid,
                   @"isFilenameInUserinfo" :  isFilenameInUserInfo};

        //파일 정보가 없다면..
    } else {
        params = @{@"id" : [NSNumber numberWithInteger:customerId],
                   @"location_id"    : [NSNumber numberWithInteger:locationId],
                   @"sex" : gender,
                   @"name" : name,
                   @"uid" : uid,
                   @"isFilenameInUserinfo" :  isFilenameInUserInfo};
    }
    
    //Request 객체를 Setting한다.
    [_aRequest setHTTPMethod:@"POST"];
    [_aRequest setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSData *httpBody = [self createBodyWithBoundary:boundary parameters:params imageFile:picture fieldName:@"updateinfo"];
    
    [_aRequest setHTTPBody:httpBody];
    
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
 *  [NSURLConnectionDelegate]Response에서 데이터를 받은 뒤 메소드
 */
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"통신은 잘 됨. 결과를 노티로 모두 쏠 것");
    
    //결과를 파싱한다.
    NSDictionary *dataDictionary = [NSJSONSerialization
                                    JSONObjectWithData:_responseData
                                    options:NSJSONReadingMutableContainers
                                    error:nil];
    
    //받은 값이 없으면 그냥 리턴한다(원래는 애러 코드에 맞는 다이얼로그를 보여줄 것)
    if(dataDictionary == nil) return;
    
    //결과를 userInfo에 넣는다.
    NSLog(@"내 정보 수정 네트워크 완료 이후, userInfo: %@", dataDictionary);
    NSUserDefaults *standardDefault = [NSUserDefaults standardUserDefaults];
    [standardDefault setObject:dataDictionary forKey:@"userInfo"];
    [standardDefault synchronize];
    
    //결과를 NSNotificationCenter로 보낸다.
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateMyInfoResult" object:self userInfo:nil];
}


/**
 *  [NSURLConnectionDelegate]애러나면 실행되는 코드
 */
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
}

- (NSData *)createBodyWithBoundary:(NSString *)boundary
                        parameters:(NSDictionary *)parameters
                         imageFile:(NSData*)image
                         fieldName:(NSString *)fieldName
{
    NSMutableData *httpBody = [NSMutableData data];
    
    // add params (all params are strings)
    [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *parameterKey, NSString *parameterValue, BOOL *stop) {
        [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", parameterKey] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"%@\r\n", parameterValue] dataUsingEncoding:NSUTF8StringEncoding]];
    }];
    
    // add image data
    
    NSString *filename  = @"tempfile";
    NSData   *data      = image;
    NSString *mimetype  = @"multipart/form-data;";
    
    [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", fieldName, filename] dataUsingEncoding:NSUTF8StringEncoding]];
    [httpBody appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", mimetype] dataUsingEncoding:NSUTF8StringEncoding]];
    [httpBody appendData:data];
    [httpBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [httpBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    return httpBody;
}


@end
