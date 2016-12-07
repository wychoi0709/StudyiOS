//
//  Card.m
//  W9CardDeck
//
//  Created by 최원영 on 2016. 11. 30..
//  Copyright © 2016년 최원영. All rights reserved.
//
//  카드를 추상화한 클래스

#import "Card.h"

@implementation Card

/**
 *  초기화 함수(숫자와 심볼을 만들 때 받는다)
 */
-(instancetype)initWithCardNumber:(int)cardNumber withCardSimbol:(NSString*)cardSimbol
{
    self = [super init];
    if (self) {
        _cardNumber = cardNumber;
        _cardSimbol = cardSimbol;
    }
    return self;
}

@end
