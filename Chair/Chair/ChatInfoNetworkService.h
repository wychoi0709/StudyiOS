//
//  ChatInfoNetworkService.h
//  Chair
//
//  Created by 최원영 on 2017. 3. 26..
//  Copyright © 2017년 최원영. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatInfoNetworkService : NSObject<NSURLConnectionDelegate>

//네트워크 통신에 필요한 변수들
@property NSString *aURLString;
@property NSString *aFormData;
@property NSURL *aURL;
@property NSMutableURLRequest *aRequest;

//읽었다고 통보하는 메소드
- (void)messageReadingWithSender:(NSString*)senderId withTaker:(NSString*)takerId;

//보냈다고 통보하는 메소드
- (void)messageSendingWithSender:(NSString*)senderId withTaker:(NSString*)takerId;

@end
