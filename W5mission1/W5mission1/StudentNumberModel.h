//
//  StudentNumberModel.h
//  W5mission1
//
//  Created by 최원영 on 2016. 11. 2..
//  Copyright © 2016년 최원영. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StudentNumberModel : NSObject
{
    //이름, 학번 정보 데이터 선언
    NSArray *_personData;
}

- (NSArray*)getPersonDate;                  //이름, 학번 정보 데이터 getter
- (NSNumber*)findByName:(NSString*)name;    //이름으로 학번 찾는 메소드
- (NSString*)findAllStudent;                //모든 학생의 이름, 학번을 뽑아주는 메소드

@end
