//
//  ConfirmCancelAboutMyDesignerViewController.m
//  Chair
//
//  Created by 최원영 on 2017. 1. 11..
//  Copyright © 2017년 최원영. All rights reserved.
//

#import "ConfirmCancelAboutMyDesignerViewController.h"
#import "DesignerCancelNetworkService.h"

@interface ConfirmCancelAboutMyDesignerViewController ()

@property NSInteger customerId;
@property NSInteger designerId;
@property NSIndexPath *indexPath;

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
    DesignerCancelNetworkService *designerCancelNetworkService = [[DesignerCancelNetworkService alloc] init];
    [designerCancelNetworkService cancelMyDesignerRequest:_customerId withDesignerId:_designerId withIndexPath:_indexPath];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


/**
 *  << 옵저버에 대한 콜백 메소드 >>
 *  확인 모달 창에 진입한 뒤 디자이너, 회원 정보를 받는 콜백 메소드
 */
-(void) loadInformations:(NSNotification*) noti {
    NSDictionary *userInfo = [[noti userInfo] objectForKey:@"userInfo"];
    NSDictionary *designerInfo = [[noti userInfo] objectForKey:@"designerInfo"];
    _indexPath = [[noti userInfo] objectForKey:@"indexPath"];
    _customerId = [[userInfo objectForKey:@"id"] integerValue];
    _designerId = [[designerInfo objectForKey:@"id"] integerValue];
}

@end
