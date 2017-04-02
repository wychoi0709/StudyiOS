//
//  ChattingRoomViewController.h
//  Chair
//
//  Created by 최원영 on 2017. 2. 28..
//  Copyright © 2017년 최원영. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChattingRoomViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *designerStageNameLabel;
@property NSString *chatroomId;
@property NSString *designerUid;
@property NSString *customerUid;
@property NSString *senderId;
@property NSString *takerId;
@property Boolean isDesigner;
@property NSDictionary *takenPersonInfo;
@property NSDictionary *sendingPersonInfo;

@end
