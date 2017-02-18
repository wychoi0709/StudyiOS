//
//  IsTempLocation.m
//  Chair
//
//  Created by 최원영 on 2017. 2. 16..
//  Copyright © 2017년 최원영. All rights reserved.
//

#import "IsTempLocation.h"

@implementation IsTempLocation

+(IsTempLocation *) getIsTempLocationObject {
    
    static IsTempLocation * sharedSingletonStateInstance;
    
    @synchronized (self){       // @synchronized를 통해 객체를 획득하는 부분의 상호배제
        if (!sharedSingletonStateInstance){
            sharedSingletonStateInstance = [[IsTempLocation alloc] initPrivate];
        }
    }
    
    return sharedSingletonStateInstance;
}

-(instancetype) init {
    @throw [NSException exceptionWithName:@"IsTempLocation is Singleton" reason:@"" userInfo:nil];
}

-(instancetype) initPrivate {
    self = [super init];
    if (self){
        _isTempLocation = false;
    }
    return self;
}

@end
