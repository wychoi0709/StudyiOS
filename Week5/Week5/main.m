//
//  main.m
//  Week5
//
//  Created by 최원영 on 2016. 10. 26..
//  Copyright © 2016년 최원영. All rights reserved.
//

#import <Foundation/Foundation.h>   //Foundation -> 폴더명 /폴더 구분한거니깐 주의!
#import "Fraction.h"    
        // < >는 시스템 폴더에 정의된 헤더를 뒤져서 찾는다.
        // ""는 프로젝트 파일에 붙어있는 파일을 뒤짐. 즉, 찾는 경로가 다름!!!


//아래를 모조리 파일로 뺐음

///**
// *  이게 선언부
// **/
//@interface Fraction : NSObject //최상위 Object가 NSObject임. 이걸 상속받음
//
//@end
//
//
///**
// *  이게 구현부
// **/
//@implementation Fraction
//
//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        //여기에 선언을 해. 이건 오른쪽 아래에 템플릿 같이 코드도 있음
//    }
//    return self;
//}
//
//- (void)helloWorld{
//    NSLog(@"Hello, World!");
//}
//
//@end




/**
 *  main 함수
 **/
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        Fraction *fraction;
        fraction = [[Fraction alloc] init];
        [fraction helloWorld];
        
        NSFileManager *fm = [NSFileManager defaultManager];
        if ([fm fileExistsAtPath:@"data"]) {    //alt 눌러서 문서보는 연습을 좀 할 것
            NSLog(@"File exists at path");
        } else {
            NSLog(@"File not found");
        }
    }
    return 0;
}
