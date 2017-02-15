//
//  MyDesignerList.m
//  Chair
//
//  Created by 최원영 on 2017. 1. 12..
//  Copyright © 2017년 최원영. All rights reserved.
//

#import "MyDesignerList.h"
#import "DesignerAddNetworkService.h"
#import "DesignerCancelNetworkService.h"

@implementation MyDesignerList

+(MyDesignerList *) getMyDesignerListObject {
    
    static MyDesignerList * sharedMyDesignerListInstance;
        
    @synchronized (self){       // @synchronized를 통해 객체를 획득하는 부분의 상호배제
        if (!sharedMyDesignerListInstance){
            sharedMyDesignerListInstance = [[MyDesignerList alloc] initPrivate];
        }
    }
    
    return sharedMyDesignerListInstance;
}

/**
 *  하면 안되는 초기화
 */
-(instancetype) init {
    @throw [NSException exceptionWithName:@"ColorValue is Singleton" reason:@"" userInfo:nil];
}

/**
 *  초기화 코드
 */
-(instancetype) initPrivate {
    self = [super init];
    if (self){
        _myDesignerList = [[NSMutableArray alloc] init];
        
        //userInfo를 가져온다(customerId는 안변할 테니깐)
        _userInfo = [[NSMutableDictionary alloc] init];
        _standardDefault = [NSUserDefaults standardUserDefaults];
        _userInfo = [[_standardDefault objectForKey:@"userInfo"] mutableCopy];
        _customerId = [[_userInfo objectForKey:@"id"] integerValue];
    }
    return self;
}


/**
 *  << 내 디자이너 관리 메소드 >>
 *  내 디자이너로 추가한다.
 */
-(void) addMyDesigner:(NSDictionary*)designer {
    
    //들어온 디자이너의 정보를 변경한다.
    NSMutableDictionary *tempDic = [designer mutableCopy];
    [tempDic setObject:@"true" forKey:@"isMyDesigner"];
    designer = tempDic;
    
    //추가한다.
    [_myDesignerList addObject:designer];
    
    //네트워크로 추가했다는 정보를 보낸다.
    NSInteger designerId = [[designer objectForKey:@"id"] integerValue];
    [[[DesignerAddNetworkService alloc] init] addMyDesignerRequest:_customerId withDesignerId:designerId];
    
    //정렬한다.
    [self sortMyDesignerList];
}

/**
 *  해당 디자이너를 제외한다.
 */
-(void) removeMyDesigner:(NSDictionary*)designer {
    //삭제한다.
    for(int i = 0; i < _myDesignerList.count; i++) {
        if([_myDesignerList[i] objectForKey:@"id"] == [designer objectForKey:@"id"]) {
            [_myDesignerList removeObjectAtIndex:i];
        }
    }
    
    //네트워크로 취소했다는 정보를 보낸다.
    NSInteger designerId = [[designer objectForKey:@"id"] integerValue];
    [[[DesignerCancelNetworkService alloc] init] cancelMyDesignerRequest:_customerId withDesignerId:designerId];
    
    //정렬한다.
    [self sortMyDesignerList];
}

/**
 *  해당 디자이너가 내 디자이너로 등록되었는지 검사한다.
 */
- (Boolean)isMyDeisnger:(NSDictionary*)designer {
    
    for(int i = 0; i < _myDesignerList.count; i++) {
        if([_myDesignerList[i] objectForKey:@"id"] == [designer objectForKey:@"id"]) {
            return true;
        }
    }
    return false;
    
}


/**
 *  고객 순(남?, 여? 미정)으로 정렬한다 (나중에)
 */
-(void) sortMyDesignerList {
}
    

@end
