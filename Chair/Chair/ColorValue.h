//
//  ColorValue.h
//  Chair
//
//  Created by 최원영 on 2016. 12. 30..
//  Copyright © 2016년 최원영. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ColorValue : NSObject

@property UIColor *brownColorChair;
@property UIColor *blueColorChair;
@property UIColor *whiteColorChair;
@property UIColor *grayColorChair;
@property UIColor *blackBlueColorChiar;
@property UIColor *thickGrayColorChair;

+(ColorValue *) getColorValueObject;
-(instancetype) init;

@end
