//
//  Fraction.m
//  Week5
//
//  Created by 최원영 on 2016. 10. 26..
//  Copyright © 2016년 최원영. All rights reserved.
//

#import "Fraction.h"

//비공개용 인터페이스
@interface Fraction ()
{
    //인스턴스 변수를 선언한다.(객체지향의 캡슐화)
    int _z; //일고 쓰기 가능이라면..
    int _q; //읽기 전용이라면
}
@end

@implementation Fraction

//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        //여기에 선언을 해. 이건 오른쪽 아래에 템플릿 같이 코드도 있음
//    }
//    return self;
//}

////_z의 getter 메소드
//-(int)z {
//    return _z;
//}
//
////_z의 setter 메소드
//-(void)setZ:(int)z {
//    _z = z;
//}
//@synthesize zAuto;

//_q의 getter 메소드
-(int)q {
    return _q;
}

- (void)helloWorld{
    NSLog(@"Hello, World!");
}

@end
