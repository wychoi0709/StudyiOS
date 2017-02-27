//
//  MyDesignerList.h
//  Chair
//
//  Created by 최원영 on 2017. 1. 12..
//  Copyright © 2017년 최원영. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyDesignerList : NSObject

@property NSMutableArray *myDesignerList;

+(MyDesignerList *) getMyDesignerListObject;
-(instancetype) init;
-(void) refreshMyDesignerList;
-(void) addMyDesigner:(NSDictionary*)designer ;
-(void) removeMyDesigner:(NSDictionary*)designer;
- (Boolean)isMyDeisnger:(NSDictionary*)designer;


@property NSMutableDictionary *userInfo;
@property NSUserDefaults *standardDefault;
@property NSInteger customerId;

@end
