//
//  ChatInfoNetworkService.m
//  Chair
//
//  Created by 최원영 on 2017. 3. 26..
//  Copyright © 2017년 최원영. All rights reserved.
//

#import "ChatInfoNetworkService.h"

@implementation ChatInfoNetworkService

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        //URL String을 토대로 URL 객체를 만든 뒤, 이를 토대로 Request 객체를 생성한다.
        _aURLString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"UrlInfoByYoung"];
        
    }
    return self;
}

//읽었다고 통보하는 메소드
- (void)messageReadingWithSender:(NSString*)senderId withTaker:(NSString*)takerId{
    
    NSString* readingURLString = [_aURLString stringByAppendingString:@"/chat/reading"];
    _aURL = [NSURL URLWithString:readingURLString];
    _aRequest = [NSMutableURLRequest requestWithURL:_aURL];
    
    [self basicRequestObjectSetting];
    
    //body에 전송할 변수를 넣는다.
    NSDictionary* bodyObject = @{
                                 @"senderId": senderId,
                                 @"takerId": takerId
                                 };
    _aRequest.HTTPBody = [NSJSONSerialization dataWithJSONObject:bodyObject options:kNilOptions error:nil];
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:_aRequest delegate:self];
    [conn start];
    
}

//보냈다고 통보하는 메소드
- (void)messageSendingWithSender:(NSString*)senderId withTaker:(NSString*)takerId{

    NSString* sendingURLString = [_aURLString stringByAppendingString:@"/chat/sending"];
    _aURL = [NSURL URLWithString:sendingURLString];
    _aRequest = [NSMutableURLRequest requestWithURL:_aURL];
    
    [self basicRequestObjectSetting];
    
    //body에 전송할 변수를 넣는다.
    NSDictionary* bodyObject = @{
                                 @"senderId": senderId,
                                 @"takerId": takerId
                                 };
    _aRequest.HTTPBody = [NSJSONSerialization dataWithJSONObject:bodyObject options:kNilOptions error:nil];
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:_aRequest delegate:self];
    [conn start];
}


- (void)basicRequestObjectSetting {

    //Request 객체를 Setting한다.
    [_aRequest setHTTPMethod:@"POST"];
    [_aRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [_aRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
}

@end
