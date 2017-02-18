//
//  EditMyPageNetworkService.h
//  Chair
//
//  Created by 최원영 on 2017. 2. 16..
//  Copyright © 2017년 최원영. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EditMyPageNetworkService : NSObject

//네트워크 통신에 필요한 변수들
@property NSString *aURLString;
@property NSString *aFormData;
@property NSURL *aURL;
@property NSMutableURLRequest *aRequest;

//내 정보를 수정하는 메소드
- (void)editMyInfo:(NSInteger)customerId withLocationId:(NSInteger)locationId withGender:(NSString*)gender withName:(NSString*)name withPicture:(NSData*)picture;

@end
