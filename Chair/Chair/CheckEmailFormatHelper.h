//
//  CheckEmailFormatHelper.h
//  Chair
//
//  Created by 최원영 on 2017. 2. 26..
//  Copyright © 2017년 최원영. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CheckEmailFormatHelper : NSObject

+ (BOOL)isValidEmailAddress:(NSString *)emailAddress ;

+ (BOOL) validateEmail:(NSString*) emailAddress ;

@end
