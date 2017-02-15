//
//  DesignerList.h
//  Chair
//
//  Created by 최원영 on 2017. 1. 13..
//  Copyright © 2017년 최원영. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DesignerListInALocation : NSObject

@property NSMutableArray *designerList;

+(DesignerListInALocation *) getDesignerListObject;
-(instancetype) init;
-(void) addMyDesignerInThisLocation:(NSDictionary*)designer ;
-(void) removeMyDesignerInThisLocation:(NSDictionary*)designer;
-(NSMutableArray*) getMyDesignerlistInThisLocation;
-(Boolean) isMyDesignerInThisLocation:(NSDictionary*)designer;

@end
