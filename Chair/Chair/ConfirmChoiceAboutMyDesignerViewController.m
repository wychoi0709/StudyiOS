//
//  ConfirmChoiceAboutMyDesignerViewController.m
//  Chair
//
//  Created by 최원영 on 2017. 1. 11..
//  Copyright © 2017년 최원영. All rights reserved.
//

#import "ConfirmChoiceAboutMyDesignerViewController.h"
#import "DesignerAddNetworkService.h"
#import "MyDesignerList.h"
#import "DesignerListInALocation.h"

@interface ConfirmChoiceAboutMyDesignerViewController ()



@end

@implementation ConfirmChoiceAboutMyDesignerViewController


/**
 *  << 생명주기에 대한 메소드 >>
 *  뷰의 로드가 완료
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"내 디자이너 등록 확인창 ViewDidLoad 시작");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


/**
 *  << 버튼에 대한 메소드 >>
 *  취소 버튼을 클릭한다.
 */
- (IBAction)cancelBtnTouched:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


/**
 *  확인 버튼을 클릭하면, 내 디자이너에 추가하고 네트워크를 실행한다.
 */
- (IBAction)confrimBtnTouched:(UIButton *)sender {
    
    //내 정보에서 성별정보를 가져와서 isMale을 확인한다.
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    NSString *gender = [userInfo objectForKey:@"sex"];
    Boolean isMale;
    if( [gender isEqualToString:@"M"] ){
        isMale = true;
    } else {
        isMale = false;
    }
    
    //만약 해당 지역의 디자이너 리스트에 현 디자이너가 있다면, DesignerListInALocation에 값을 넣고(MyDesignerList는 자동 갱신), 아니면 MyDesignerList에 넣는다.
    if([[DesignerListInALocation getDesignerListObject] isMyDesignerInThisLocation:_designerInfo]) {
        [[DesignerListInALocation getDesignerListObject] addMyDesignerInThisLocation:_designerInfo withIsMale: isMale];
    } else {
        [[MyDesignerList getMyDesignerListObject] addMyDesigner:_designerInfo withIsMale: isMale];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
