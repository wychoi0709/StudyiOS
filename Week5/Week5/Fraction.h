//
//  Fraction.h
//  Week5
//
//  Created by 최원영 on 2016. 10. 26..
//  Copyright © 2016년 최원영. All rights reserved.
//

#import <Foundation/Foundation.h>

//공개용 인터페이스
@interface Fraction : NSObject
{
    //변수영역(공개용)_때문에 이거 안보이게 하려고 변수선언을 구현부로 옮긴다.
    int _x;
    int _y;
}

//-(int)z;
//-(void)setZ:(int)z;
@property int zAuto;
@property (readonly) int qAuto;
-(int)q;

- (void)helloWorld;

@end
