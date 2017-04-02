//
//  ColorValue.m
//  Chair
//
//  Created by 최원영 on 2016. 12. 30..
//  Copyright © 2016년 최원영. All rights reserved.
//

#import "ColorValue.h"

@implementation ColorValue

+(ColorValue *) getColorValueObject {
    
    static ColorValue * sharedSingletonStateInstance;
    
    @synchronized (self){       // @synchronized를 통해 객체를 획득하는 부분의 상호배제
        if (!sharedSingletonStateInstance){
            sharedSingletonStateInstance = [[ColorValue alloc] initPrivate];
        }
    }
    
    return sharedSingletonStateInstance;
}

-(instancetype) init {
    @throw [NSException exceptionWithName:@"ColorValue is Singleton" reason:@"" userInfo:nil];
}

-(instancetype) initPrivate {
    self = [super init];
    if (self){

        _blackBlueColorChiar = [UIColor colorWithRed:0.25098039215686 green:0.27843137254902 blue:0.33725490196078 alpha:1];
        _grayColorChair = [UIColor colorWithRed:0.93333333333333 green:0.93333333333333 blue:0.93725490196078 alpha:1];
        _brownColorChair = [UIColor colorWithRed:0.73725490196078 green:0.63529411764706 blue:0.55686274509804 alpha:1];
        _thickGrayColorChair = [UIColor colorWithRed:0.47058823529412 green:0.47843137254902 blue:0.50196078431373 alpha:1];
        _whiteColorChair = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1];
        _blueColorChair;

    }
    return self;
}

@end
