//
//  RandomCardSupplyFactory.m
//  W9CardDeck
//
//  Created by 최원영 on 2016. 11. 30..
//  Copyright © 2016년 최원영. All rights reserved.
//

#import "RandomCardSupplyFactory.h"

@implementation RandomCardSupplyFactory


/**
 *  랜덤한 카드를 뽑아서 노티를 보냅니다.
 **/
- (void)randomize
{
    //카드에 넣을 숫자와, 심볼을 랜덤으로 하나 생성한다.
    int randomNumber = [self getRandomNumber];
    NSString *randomSimbol = [self getRandomSimbol];
    
    //카드를 하나 만든다.
    _card = [[Card alloc] initWithCardNumber:randomNumber withCardSimbol:randomSimbol];
    
    //노티로 보낼 데이터를 담는다.
    NSDictionary *dic = [NSDictionary dictionaryWithObject:_card forKey:@"card"];
    
    //센터를 만들고, 노티를 보낸다.
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter postNotificationName:@"randomizeCard" object:self userInfo:dic];
}


/**
 *  랜덤한 숫자를 뽑아줍니다.
 **/
- (int)getRandomNumber
{
    return (arc4random() % 13) + 1;
}


/**
 *  랜덤한 심볼을 뽑아줍니다.
 **/
- (NSString*)getRandomSimbol
{
    NSString *randomSimbol;
    int value = arc4random() % 4;
    
    if(value == 0) {
        randomSimbol = @"Spade";
    } else if (value == 1) {
        randomSimbol = @"Heart";
    } else if (value == 2) {
        randomSimbol = @"Diamond";
    } else {
        randomSimbol = @"Clover";
    }
    return randomSimbol;
}


@end
