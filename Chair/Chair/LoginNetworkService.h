//
//  LoginNetworkService.h
//  Chair
//
//  Created by 최원영 on 2016. 11. 23..
//  Copyright © 2016년 최원영. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginNetworkService : NSObject<NSURLConnectionDelegate>

//응답받을 변수
@property NSMutableData *responseData;

//로그인 네트워크 통신에 필요한 변수들
@property NSString *aURLString;
@property NSString *aFormData;
@property NSURL *aURL;
@property NSMutableURLRequest *aRequest;

//로그인을 위한 firebase uid 변수
@property NSString *uid;

//로그인하는 메소드
- (void)sendLoginAsynchronousRequest:(NSString*)uid;

@end
