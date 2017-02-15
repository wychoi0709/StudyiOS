//
//  ImageSendNetworkService.m
//  CameraPractice
//
//  Created by 최원영 on 2017. 2. 11..
//  Copyright © 2017년 최원영. All rights reserved.
//

#import "ImageSendNetworkService.h"

@implementation ImageSendNetworkService


- (void)sendImage:(NSData*)image{
    NSLog(@"DesignerAddNetworkService의 비동기 요청으로 들어옴");
    
    //URL String을 토대로 URL 객체를 만든 뒤, 이를 토대로 Request 객체를 생성한다.
    _aURLString = @"http://172.30.1.53";
    _aURL = [NSURL URLWithString:_aURLString];
    _aRequest = [NSMutableURLRequest requestWithURL:_aURL];
    
    //Request 객체를 Setting한다.
    [_aRequest setHTTPMethod:@"POST"];
    [_aRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [_aRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    //body에 전송할 변수를 넣는다.
    NSDictionary* bodyObject = @{
                                 @"customer_id":image
                                };
    _aRequest.HTTPBody = [NSJSONSerialization dataWithJSONObject:bodyObject options:kNilOptions error:nil];
    
    // Create url connection and fire request
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:_aRequest delegate:self];
    
    [conn start];
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"");
}

@end
