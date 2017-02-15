//
//  DesignerList.m
//  Chair
//
//  Created by 최원영 on 2017. 1. 13..
//  Copyright © 2017년 최원영. All rights reserved.
//

#import "DesignerListInALocation.h"
#import "MyDesignerList.h"

@implementation DesignerListInALocation

+(DesignerListInALocation *) getDesignerListObject {
    
    static DesignerListInALocation * sharedDesignerListInstance;
    
    @synchronized (self){       // @synchronized를 통해 객체를 획득하는 부분의 상호배제
        if (!sharedDesignerListInstance){
            sharedDesignerListInstance = [[DesignerListInALocation alloc] initPrivate];
        }
    }
    
    return sharedDesignerListInstance;
}

-(instancetype) init {
    @throw [NSException exceptionWithName:@"DesignerList is Singleton" reason:@"" userInfo:nil];
}

-(instancetype) initPrivate {
    self = [super init];
    if (self){
        _designerList = [[NSMutableArray alloc] init];
    }
    return self;
}

/**
 *  해당 디자이너가 해당 지역의 디자이너로 속해있다면, 내 디자이너로 등록한다.
 */
-(void) addMyDesignerInThisLocation:(NSDictionary*)designer {

    for(int i = 0; i < _designerList.count; i++) {
        if([_designerList[i] objectForKey:@"id"] == [designer objectForKey:@"id"]) {
            
            //지금 지역의 디자이너 정보를 변경한다.
            NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] init];
            NSDictionary *oldDict = (NSDictionary *)[_designerList objectAtIndex:i];
            [tempDic addEntriesFromDictionary:oldDict];
            [tempDic setObject:@"true" forKey:@"isMyDesigner"];
            [_designerList replaceObjectAtIndex:i withObject:tempDic];
            
            //토탈 내 디자이너 리스트에 디자이너를 추가한다.
            [[MyDesignerList getMyDesignerListObject] addMyDesigner:designer];
        }
    }
}

/**
 *  해당 지역의 내 디자이너 등록을 취소한다.
 */
-(void) removeMyDesignerInThisLocation:(NSDictionary*)designer {
    for(int i = 0; i < _designerList.count; i++) {
        if([_designerList[i] objectForKey:@"id"] == [designer objectForKey:@"id"]) {
            
            //지금 지역의 디자이너 정보를 변경한다.
            NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] init];
            NSDictionary *oldDict = (NSDictionary *)[_designerList objectAtIndex:i];
            [tempDic addEntriesFromDictionary:oldDict];
            [tempDic setObject:@"false" forKey:@"isMyDesigner"];
            [_designerList replaceObjectAtIndex:i withObject:tempDic];
            
            //토탈 내 디자이너 리스트에서 지운다.
            [[MyDesignerList getMyDesignerListObject] removeMyDesigner:designer];
        }
    }
}

/**
 *  해당 지역에 등록된 내 디자이너가 몇 명인지 알려준다.
 */
- (NSInteger) getMyDesignerCountInThisLocation {
    NSInteger count;
    
    for(int i = 0; i < _designerList.count; i++) {
        if([[_designerList[i] objectForKey:@"isMyDesigner"] boolValue]) {
            count++;
        }
    }
    
    return count;
}

/**
 *  해당 디자이너가 선택된 지역에 속한 디자이너인지 알려준다.
 */
- (Boolean) isMyDesignerInThisLocation:(NSDictionary*)designer {
    
    for(int i = 0; i < _designerList.count; i++) {
        if([_designerList[i] objectForKey:@"id"] == [designer objectForKey:@"id"]) {
            return true;
        }
    }
    return false;
}

@end
