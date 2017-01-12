//
//  DesignerAddNetworkService.h
//  Chair
//
//  Created by 최원영 on 2017. 1. 11..
//  Copyright © 2017년 최원영. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DesignerAddNetworkService : NSObject<NSURLConnectionDelegate>

//indexPath
@property NSIndexPath *indexPath;

//응답받은 변수
@property NSMutableData *responseData;

//디자이너 추가에 필요한 변수들
@property NSString *aURLString;
@property NSString *aFormData;
@property NSURL *aURL;
@property NSMutableURLRequest *aRequest;

//내 디자이너를 추가하는 네트워크 요청(고객id, 디자이너id)
- (void)addMyDesignerRequest:(NSInteger)customerId withDesignerId:(NSInteger)designerId withIndexPath:(NSIndexPath*)indexPath;

@end
