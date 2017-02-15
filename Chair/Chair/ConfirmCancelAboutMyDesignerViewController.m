//
//  ConfirmCancelAboutMyDesignerViewController.m
//  Chair
//
//  Created by 최원영 on 2017. 1. 11..
//  Copyright © 2017년 최원영. All rights reserved.
//

#import "ConfirmCancelAboutMyDesignerViewController.h"
#import "DesignerCancelNetworkService.h"
#import "MyDesignerList.h"
#import "DesignerListInALocation.h"

@interface ConfirmCancelAboutMyDesignerViewController ()

@property NSDictionary *designerInfo;


@end

@implementation ConfirmCancelAboutMyDesignerViewController

/**
 *  << 생명주기에 대한 메소드 >>
 *  뷰의 로드가 완료
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
    [notiCenter addObserver:self selector:@selector(loadInformations:) name:@"userAndDesignerInfo" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/**
 *  현 VC가 없어질 떄 실행되는 메소드
 */
- (void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


/**
 *  << 버튼에 대한 메소드 >>
 *  취소 버튼을 클릭한다.
 */
- (IBAction)cancelBtnTouched:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  확인 버튼을 클릭하면, 취소 네트워크를 실행한다.
 */
- (IBAction)confrimBtnTouched:(UIButton *)sender {

    //만약 해당 지역의 디자이너 리스트에 현 디자이너가 있다면, DesignerListInALocation에 값을 빼고(MyDesignerList는 자동 갱신), 아니면 MyDesignerList의 값을 뺀다.
    if([[DesignerListInALocation getDesignerListObject] isMyDesignerInThisLocation:_designerInfo]) {
        [[DesignerListInALocation getDesignerListObject] removeMyDesignerInThisLocation:_designerInfo];
    } else {
        [[MyDesignerList getMyDesignerListObject] removeMyDesigner:_designerInfo];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


/**
 *  << 옵저버에 대한 콜백 메소드 >>
 *  확인 모달 창에 진입한 뒤 디자이너, 회원 정보를 받는 콜백 메소드
 */
-(void) loadInformations:(NSNotification*) noti {
    _designerInfo = [[noti userInfo] objectForKey:@"designerInfo"];
}

@end
