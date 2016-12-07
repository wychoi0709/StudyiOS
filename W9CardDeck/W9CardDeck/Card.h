//
//  Card.h
//  W9CardDeck
//
//  Created by 최원영 on 2016. 11. 30..
//  Copyright © 2016년 최원영. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property NSString* cardNumber;
@property NSString* cardSimbol;

-(id)initWithCardNumber:(NSString*)cardNumber withCardSimbol:(NSString*)cardSimbol;

@end
