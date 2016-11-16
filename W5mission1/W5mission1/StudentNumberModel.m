//
//  StudentNumberModel.m
//  W5mission1
//
//  Created by 최원영 on 2016. 11. 2..
//  Copyright © 2016년 최원영. All rights reserved.
//

#import "StudentNumberModel.h"

@implementation StudentNumberModel

- (instancetype)init
{
    /**
     * 초기화 함수 선언
     **/
    self = [super init];
    if (self) {
        
        //샘플 데이터 입력
        _personData = @[  @{@"name":@"김정", @"number":@141067},
                          @{@"name":@"싸이", @"number":@141069},
                          @{@"name":@"최원영",@"number":@141091},
                          @{@"name":@"한재엽",@"number":@141096},
                          @{@"name":@"권용재",@"number":@141006},
                          @{@"name":@"임은주",@"number":@141072},
                          @{@"name":@"순Siri",@"number":@141049} ];

    }
    return self;
}


/**
 * 학생, 학번 데이터에 대한 getter 함수
 **/
- (NSArray*)getPersonDate {
    return _personData;
}


/**
 * 이름으로 학번을 찾아주는 함수
 **/
- (NSNumber*)findByName:(NSString*)name {
    
    //배열을 돌면서 이름이 같은 놈을 찾음. 결과 학번을 반환
    for ( NSDictionary* item in _personData ) {
        if ( [item[@"name"] isEqualToString:name] ) {
            return item[@"number"];
        }
    }
    
    //매칭되는게 없으면 nil 반환
    return nil;
}


/**
 * 모든 학생들의 정보를 빼주는 함수
 **/
- (NSString*)findAllStudent {
    
    //필요한 변수 선언
    NSString* resultStrings = nil;
    
    //String들을 특정한 포멧으로 묶어주기 위한 MutableArray 생성
    NSMutableArray* newArray = [[NSMutableArray alloc] init];

    
    //학생 데이터를 돌면서 적절한 포멧으로 데이터를 담음
    for ( NSDictionary* item in _personData ) {
        
        //For Each문 안에서만 필요한 변수 선언
        NSString* name = nil;
        NSString* number = nil;
        
        //변수에 값을 할당
        name = item[@"name"];
        number = item[@"number"];
        
        //특정한 포멧으로 값을 넣음
        NSString *newOutput = [NSString stringWithFormat:@"\"%@\"의 학번은 \"%@\"입니다. \n",name,number];
        
        //생성한 MutableArray에 값을 담음
        [newArray addObject:newOutput];
    }
    
    //MutableArray에 있는 모든 값을 가져온 뒤 반환
    resultStrings = [newArray componentsJoinedByString:@""];
    return resultStrings;
}

@end


